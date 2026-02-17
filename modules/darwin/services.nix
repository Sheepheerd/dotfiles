{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.solarsystem.isDarwin) {

    # services = {
    #   tailscale = {
    #     enable = true;
    #     overrideLocalDns = true;
    #   };
    #
    # };
  };

}
