{
  self,
  lib,
  config,
  ...
}:
{
  options.solarsystem.modules.server.ssh = lib.mkEnableOption "enable ssh on server";
  config = lib.mkIf config.solarsystem.modules.server.ssh {
    services.openssh = {
      enable = true;
      startWhenNeeded = lib.mkForce false;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
        X11Forwarding = true;
      };
      # hostKeys = [
      #   {
      #     path = "/etc/ssh/ssh_host_ed25519_key";
      #     type = "ed25519";
      #   }
      # ];
    };
    users.users."${config.solarsystem.mainUser}".openssh.authorizedKeys.keyFiles = [
      (self + /secrets/keys/ssh/deathstar.pub)
      (self + /secrets/keys/ssh/novastar.pub)
    ];
    # users.users.root.openssh.authorizedKeys.keyFiles = [
    #   # (self + /secrets/keys/ssh/yubikey.pub)
    #   # (self + /secrets/keys/ssh/magicant.pub)
    # ];
    security.sudo.extraConfig = ''
      Defaults    env_keep+=SSH_AUTH_SOCK
    '';
  };
}
