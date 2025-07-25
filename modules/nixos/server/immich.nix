{
  config,
  lib,
  pkgs,
  self,
  ...
}:

let
  cfg = config.solarsystem.modules.server.immich;
in
{
  options.solarsystem.modules.server.immich =
    lib.mkEnableOption "Enable the Immich photo service with Podman backend.";

  config = lib.mkIf cfg {

    age.secrets.immich = {
      file = self + /secrets/server/immich.age;
      owner = "sheep";
      group = "users";
      mode = "0440";
    };

    # Runtime
    virtualisation.podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        # Required for container networking to be able to use names.
        dns_enabled = true;
      };
    };

    # Enable container name DNS for non-default Podman networks.
    # https://github.com/NixOS/nixpkgs/issues/226365
    networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

    virtualisation.oci-containers.backend = "podman";

    # Containers
    virtualisation.oci-containers.containers."immich_machine_learning" = {
      image = "ghcr.io/immich-app/immich-machine-learning:release";
      environmentFiles = [ config.age.secrets.immich.path ];
      volumes = [ "immich_model-cache:/cache:rw" ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=immich-machine-learning"
        "--network=immich_default"
      ];
    };
    systemd.services."podman-immich_machine_learning" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [
        "podman-network-immich_default.service"
        "podman-volume-immich_model-cache.service"
      ];
      requires = [
        "podman-network-immich_default.service"
        "podman-volume-immich_model-cache.service"
      ];
      partOf = [ "podman-compose-immich-root.target" ];
      wantedBy = [ "podman-compose-immich-root.target" ];
    };
    virtualisation.oci-containers.containers."immich_postgres" = {
      image = "docker.io/tensorchord/pgvecto-rs:pg14-v0.2.0@sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
      environmentFiles = [ config.age.secrets.immich.path ];
      volumes = [ "/mnt/one-t-ssd/immich-app/data/postgres:/var/lib/postgresql/data:rw" ];
      cmd = [
        "postgres"
        "-c"
        "shared_preload_libraries=vectors.so"
        "-c"
        ''search_path="$user", public, vectors''
        "-c"
        "logging_collector=on"
        "-c"
        "max_wal_size=2GB"
        "-c"
        "shared_buffers=512MB"
        "-c"
        "wal_compression=on"
      ];
      log-driver = "journald";
      extraOptions = [
        ''--health-cmd=pg_isready --dbname="''${POSTGRES_DB}" --username="''${POSTGRES_USER}" || exit 1; Chksum="$(psql --dbname="''${POSTGRES_DB}" --username="''${POSTGRES_USER}" --tuples-only --no-align --command='SELECT COALESCE(SUM(checksum_failures), 0) FROM pg_stat_database')"; echo "checksum failure count is $Chksum"; [ "$Chksum" = '0' ] || exit 1''
        "--health-interval=5m0s"
        "--health-start-period=5m0s"
        "--health-startup-interval=30s"
        "--network-alias=database"
        "--network=immich_default"
      ];
    };
    systemd.services."podman-immich_postgres" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [ "podman-network-immich_default.service" ];
      requires = [ "podman-network-immich_default.service" ];
      partOf = [ "podman-compose-immich-root.target" ];
      wantedBy = [ "podman-compose-immich-root.target" ];
    };
    virtualisation.oci-containers.containers."immich_redis" = {
      image = "docker.io/redis:6.2-alpine@sha256:905c4ee67b8e0aa955331960d2aa745781e6bd89afc44a8584bfd13bc890f0ae";
      environmentFiles = [ config.age.secrets.immich.path ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=redis-cli ping || exit 1"
        "--network-alias=redis"
        "--network=immich_default"
      ];
    };
    systemd.services."podman-immich_redis" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [ "podman-network-immich_default.service" ];
      requires = [ "podman-network-immich_default.service" ];
      partOf = [ "podman-compose-immich-root.target" ];
      wantedBy = [ "podman-compose-immich-root.target" ];
    };
    virtualisation.oci-containers.containers."immich_server" = {
      image = "ghcr.io/immich-app/immich-server:release";
      environmentFiles = [ config.age.secrets.immich.path ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/mnt/one-t-ssd/immich-app/data/library:/usr/src/app/upload:rw"
      ];
      ports = [ "100.113.25.38:2283:2283/tcp" ];
      dependsOn = [
        "immich_postgres"
        "immich_redis"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=immich-server"
        "--network=immich_default"
      ];
    };
    systemd.services."podman-immich_server" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
      };
      after = [ "podman-network-immich_default.service" ];
      requires = [ "podman-network-immich_default.service" ];
      partOf = [ "podman-compose-immich-root.target" ];
      wantedBy = [ "podman-compose-immich-root.target" ];
    };

    # Networks
    systemd.services."podman-network-immich_default" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f immich_default";
      };
      script = ''
        podman network inspect immich_default || podman network create immich_default
      '';
      partOf = [ "podman-compose-immich-root.target" ];
      wantedBy = [ "podman-compose-immich-root.target" ];
    };

    # Volumes
    systemd.services."podman-volume-immich_model-cache" = {
      path = [ pkgs.podman ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''
        podman volume inspect immich_model-cache || podman volume create immich_model-cache
      '';
      partOf = [ "podman-compose-immich-root.target" ];
      wantedBy = [ "podman-compose-immich-root.target" ];
    };

    # Root service
    # When started, this will automatically create all resources and start
    # the containers. When stopped, this will teardown all resources.
    systemd.targets."podman-compose-immich-root" = {
      unitConfig = {
        Description = "Root target generated by compose2nix.";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
