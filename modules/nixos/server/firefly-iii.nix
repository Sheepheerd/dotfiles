{
  self,
  lib,
  config,
  pkgs,
  ...
}:

let
  serviceName = "firefly-iii";
  serviceUser = "firefly-iii";
  domain = "bank.heerd.dev";
  importerDomain = "bank-import.heerd.dev";
  importer = config.services.firefly-iii-data-importer;
  autoImportName = "firefly-iii-simplefin-import";
  importConfig = config.age.secrets.firefly-simplefin-config.path;
in
{
  options.solarsystem.modules.server.${serviceName} = lib.mkEnableOption "Enable Firefly III service";

  config = lib.mkIf config.solarsystem.modules.server.${serviceName} {
    # Secrets
    age.secrets = {
      firefly-app-key = {
        file = self + /secrets/server/firefly.appkey.age;
        owner = serviceUser;
        group = "nginx";
        mode = "0440";
      };
      # FIREFLY_III_ACCESS_TOKEN + SIMPLEFIN_TOKEN for the data importer
      firefly-importer-env = {
        file = self + /secrets/server/firefly-importer.age;
        mode = "0400";
      };
      # Import config JSON downloaded from the data importer web UI (account mapping)
      firefly-simplefin-config = {
        file = self + /secrets/server/firefly-simplefin-config.age;
        owner = importer.user;
        group = importer.group;
        mode = "0400";
      };
    };

    # Firefly III
    services.firefly-iii = {
      enable = true;
      dataDir = "/vault/data/firefly-iii";
      enableNginx = true;
      virtualHost = domain;
      settings = {
        TZ = "America/New_York";
        APP_ENV = "production";
        APP_KEY_FILE = config.age.secrets.firefly-app-key.path;
        DB_CONNECTION = "sqlite";
        APP_URL = "https://${domain}";
      };
    };

    # Nginx virtual host w/ ACME DNS
    services.nginx.virtualHosts.${domain} = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
    };

    # Data importer (SimpleFIN)
    services.firefly-iii-data-importer = {
      enable = true;
      dataDir = "/vault/data/firefly-iii-data-importer";
      enableNginx = true;
      virtualHost = importerDomain;
      settings = {
        TZ = "America/New_York";
        APP_ENV = "production";
        APP_URL = "https://${importerDomain}";
        FIREFLY_III_URL = "https://${domain}";
        VANITY_URL = "https://${domain}";
        # The CLI importer only reads configs from these directories
        IMPORT_DIR_ALLOWLIST = "/run/${autoImportName}";
      };
    };

    # Daily SimpleFIN -> Firefly III import. Credentials come from the agenix
    # env file; importConfig only supplies the account mapping (any
    # access_token in it is overridden). The last 7 days are re-fetched each
    # run; duplicate detection drops what was already imported.
    # Setup and maintenance: docs/firefly-iii.md
    systemd.services.${autoImportName} = {
      description = "Import SimpleFIN transactions into Firefly III";
      after = [
        "network-online.target"
        "firefly-iii-data-importer-setup.service"
        "phpfpm-firefly-iii.service"
      ];
      wants = [ "network-online.target" ];
      requires = [ "firefly-iii-data-importer-setup.service" ];
      path = [ pkgs.jq ];
      script = ''
        # The config secret starts out empty; skip until accounts are mapped
        if ! jq -e '.accounts | length > 0' ${importConfig} >/dev/null 2>&1; then
          echo "No account mapping in ${importConfig} yet, skipping (see docs/firefly-iii.md)"
          exit 0
        fi
        # SIMPLEFIN_TOKEN must be the claimed access URL (https://user:pass@...);
        # a one-time setup token only works through the web UI. Strip whitespace:
        # a trailing newline ends up in the URL and SimpleFIN answers 404
        token=$(printf '%s' "''${SIMPLEFIN_TOKEN:-}" | tr -d '[:space:]')
        case "$token" in
          https://*@*) ;;
          *)
            echo "SIMPLEFIN_TOKEN is not a SimpleFIN access URL (https://user:pass@...)" >&2
            exit 1
            ;;
        esac
        config="$RUNTIME_DIRECTORY/simplefin.json"
        jq --arg token "$token" '. + {
          access_token: $token,
          flow: "simplefin",
          date_range: "partial",
          date_range_number: 7,
          date_range_unit: "d",
          rules: true,
          ignore_duplicate_transactions: true,
          # "classic" hash matching misses re-fetched SimpleFIN transactions;
          # external_id (ff3-<account>-<transaction id>) is stable across runs
          duplicate_detection_method: "cell",
          unique_column_type: "external-id"
        }' ${importConfig} > "$config"
        # The importer exits NOTHING_WAS_IMPORTED (73) both on quiet days and when
        # SimpleFIN fails, so tell them apart by its output
        log="$RUNTIME_DIRECTORY/import.log"
        set +e
        ${importer.package}/artisan importer:import "$config" 2>&1 | tee "$log"
        rc=''${PIPESTATUS[0]}
        set -e
        if grep -q '^Error message:' "$log"; then
          exit 1
        fi
        if [ "$rc" -eq 73 ]; then
          exit 0
        fi
        # Skipped duplicates ([a115]) count as errors and exit 1; that's the
        # normal result of re-fetching the last 7 days
        errors=$(grep -oE 'There are [0-9]+ error\(s\)' "$log" | tail -n 1 | grep -oE '[0-9]+' || echo 0)
        dups=$(grep -cE '^Import index [0-9]+: \[a115\]' "$log" || true)
        if [ "$rc" -eq 1 ] && [ "$errors" -gt 0 ] && [ "$dups" -eq "$errors" ]; then
          echo "Skipped $dups duplicate(s), nothing else failed"
          exit 0
        fi
        exit "$rc"
      '';
      serviceConfig = {
        Type = "oneshot";
        EnvironmentFile = config.age.secrets.firefly-importer-env.path;
        User = importer.user;
        Group = importer.group;
        WorkingDirectory = importer.package;
        RuntimeDirectory = autoImportName;
        RuntimeDirectoryMode = "0700";
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ importer.dataDir ];
        NoNewPrivileges = true;
      };
    };

    systemd.timers.${autoImportName} = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 06:00:00";
        RandomizedDelaySec = "30m";
        Persistent = true;
      };
    };

    # Secrets are read by the setup unit and baked into the importer's config cache
    systemd.services.firefly-iii-data-importer-setup = {
      serviceConfig.EnvironmentFile = config.age.secrets.firefly-importer-env.path;
      restartTriggers = [ config.age.secrets.firefly-importer-env.file ];
    };

    services.nginx.virtualHosts.${importerDomain} = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
    };

    # Let the importer reach Firefly III locally instead of through tailscale DNS
    networking.hosts."127.0.0.1" = [ domain ];

  };
}
