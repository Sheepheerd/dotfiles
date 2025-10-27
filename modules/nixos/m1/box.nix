{
  lib,
  config,
  pkgs,
  ...
}:

let
  dockerfile = ''
    FROM quay.io/fedora/fedora-minimal:42
    WORKDIR /

    RUN dnf install -y 'dnf5-command(copr)' && \
        dnf copr enable -y @asahi/mesa && \
        dnf copr enable -y @asahi/fedora-remix-scripts

    # Add i386 and x86_64 repos for Mesa/FEX
    RUN echo '[copr:copr.fedorainfracloud.org:group_asahi:mesa-i386]' > /etc/yum.repos.d/group_asahi-mesa-i386.repo && \
        echo 'baseurl=https://download.copr.fedorainfracloud.org/results/@asahi/mesa/fedora-$releasever-i386/' >> /etc/yum.repos.d/group_asahi-mesa-i386.repo && \
        echo 'enabled=1' >> /etc/yum.repos.d/group_asahi-mesa-i386.repo && \
        echo 'gpgcheck=0' >> /etc/yum.repos.d/group_asahi-mesa-i386.repo && \
        echo '[copr:copr.fedorainfracloud.org:group_asahi:mesa-x86_64]' > /etc/yum.repos.d/group_asahi-mesa-x86_64.repo && \
        echo 'baseurl=https://download.copr.fedorainfracloud.org/results/@asahi/mesa/fedora-$releasever-x86_64/' >> /etc/yum.repos.d/group_asahi-mesa-x86_64.repo && \
        echo 'enabled=1' >> /etc/yum.repos.d/group_asahi-mesa-x86_64.repo && \
        echo 'gpgcheck=0' >> /etc/yum.repos.d/group_asahi-mesa-x86_64.repo

    RUN dnf clean all && dnf upgrade -y
    RUN dnf install -y asahi-platform-metapackage-fex steam alsa-utils vim bash sudo wget curl tar gzip which less
    CMD ["/bin/bash"]
  '';

  generateDistroboxSteam = pkgs.writeShellScriptBin "generate-distrobox-steam" ''
        #!/usr/bin/env bash
        set -euo pipefail

        echo "[box] Setting up Fedora Asahi Steam Distrobox..."
        mkdir -p ~/distrobox/steam

        echo "[box] Writing Dockerfile..."
        cat > ~/distrobox/steam/Dockerfile <<'EOF'
    ${dockerfile}
    EOF

        cd ~/distrobox/steam

        # prefer podman over docker
        CONTAINER_TOOL=$(command -v podman || command -v docker)

        if ! $CONTAINER_TOOL images | grep -q "steam"; then
          echo "[box] Building image 'steam:latest'..."
          $CONTAINER_TOOL build . --tag steam:latest
        else
          echo "[box] Image already exists, skipping build."
        fi

        if ! distrobox-list | grep -q steam; then
          echo "[box] Creating Distrobox container 'steam'..."
          distrobox-create --name steam --image steam:latest --home ~/Distrobox/steam
        else
          echo "[box] Container already exists, skipping creation."
        fi

        echo "[box] Done."
  '';

  matlabScript = pkgs.writeShellScriptBin "matlab" ''
    #!/usr/bin/env bash
    set -euo pipefail
    distrobox enter steam -- muvm -- FEXBash "/home/sheep/matlab/bin/matlab"
  '';
in
{
  options.solarsystem.modules.box = lib.mkEnableOption "Install scripts for Asahi Fedora Steam Distrobox and MATLAB launcher";

  config = lib.mkIf config.solarsystem.modules.box {
    environment.systemPackages = [
      generateDistroboxSteam
      matlabScript
      pkgs.distrobox
      pkgs.podman
    ];
  };
}
