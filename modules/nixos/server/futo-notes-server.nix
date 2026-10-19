{
  lib,
  config,
  pkgs,
  ...
}:
let
  servicePort = 3005;
  serviceName = "futo-notes";
  serviceHost = "notes.heerd.dev";

  dataDir = "/var/lib/futo-notes";
  networkName = "futo-notes-net";

  serverImage = "gitlab.futo.org:5050/futo-notes/futo-notes-server/server:stable";
  postgresImage = "postgres:16";

  adminPassword = "CHANGE-ME-admin-password";
  postgresDb = "futo_notes";
  postgresUser = "futo_notes";
  postgresPassword = "CHANGE-ME-postgres-password";
in
{
  options.solarsystem.modules.server.futo-notes =
    lib.mkEnableOption "enable ${serviceName} on server";
  config = lib.mkIf config.solarsystem.modules.server.futo-notes {

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    systemd.tmpfiles.rules = [
      "d ${dataDir} 0750 root root -"
      "d ${dataDir}/blobs 0750 root root -"
      "d ${dataDir}/postgres 0700 999 999 -"
    ];

    systemd.services.futo-notes-network = {
      description = "create ${networkName} docker network";
      after = [ "docker.service" ];
      requires = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        ${pkgs.docker}/bin/docker network inspect ${networkName} >/dev/null 2>&1 \
          || ${pkgs.docker}/bin/docker network create ${networkName}
      '';
    };

    virtualisation.oci-containers.containers = {

      futo-notes-postgres = {
        image = postgresImage;
        autoStart = true;
        environment = {
          POSTGRES_USER = postgresUser;
          POSTGRES_PASSWORD = postgresPassword;
          POSTGRES_DB = postgresDb;
        };
        volumes = [ "${dataDir}/postgres:/var/lib/postgresql/data" ];
        extraOptions = [
          "--network=${networkName}"
          "--network-alias=postgres"
          "--health-cmd=pg_isready -U ${postgresUser} -d ${postgresDb}"
          "--health-interval=5s"
          "--health-timeout=3s"
          "--health-retries=15"
        ];
      };

      futo-notes-server = {
        image = serverImage;
        autoStart = true;
        dependsOn = [ "futo-notes-postgres" ];
        environment = {
          PORT = "3000";
          BLOB_DIR = "/data/blobs";
          LOG_LEVEL = "info";
          AUTH_MODE = "password";
          FUTO_NOTES_PASSWORD = adminPassword;
          DATABASE_URL = "postgres://${postgresUser}:${postgresPassword}@postgres:5432/${postgresDb}";
        };
        volumes = [ "${dataDir}/blobs:/data/blobs" ];
        ports = [ "127.0.0.1:${toString servicePort}:3000" ];
        extraOptions = [ "--network=${networkName}" ];
      };

    };

    systemd.services.docker-futo-notes-postgres = {
      after = [ "futo-notes-network.service" ];
      requires = [ "futo-notes-network.service" ];
    };

    systemd.services.docker-futo-notes-server = {
      after = [
        "futo-notes-network.service"
        "blocky.service"
      ];
      requires = [ "futo-notes-network.service" ];
      serviceConfig.RestartSec = "15s";
    };

    services.nginx = {
      virtualHosts = {
        "${serviceHost}" = {
          enableACME = true;
          forceSSL = true;
          acmeRoot = null;
          locations = {
            "/" = {
              proxyPass = "http://127.0.0.1:${toString servicePort}";
              proxyWebsockets = true;
              recommendedProxySettings = true;
              extraConfig = ''
                proxy_buffering      off;
                proxy_read_timeout   3600s;
                proxy_send_timeout   3600s;
                client_max_body_size 512M;
              '';
            };
          };
        };
      };
    };

  };

}
