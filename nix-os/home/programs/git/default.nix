{config, pkgs, lib, ...}:
{
programs.git = {
enable = true;
userName = "Sheepheerd";
extraConfig = {
push = { autoSetupRemote = true; };
credential.helper = "${pkgs.git.override { withLibsecret = true; }
} /bin/git-credential-libsecret";
};
};
}
