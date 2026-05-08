{
  lib,
  config,
  pkgs,
  ...
}:

let
  ffmpeg-encoder-plugin = pkgs.stdenv.mkDerivation (finalAttrs: {
    pname = "ffmpeg-encoder-plugin";
    version = "1.1.0";

    src = pkgs.fetchFromGitHub {
      owner = "EdvinNilsson";
      repo = "ffmpeg_encoder_plugin";
      tag = "v${finalAttrs.version}";
      hash = "sha256-orghLIzz9rUnUwka9C71Z2nj+qxHuggrKNlYjLKswQw=";
    };

    nativeBuildInputs = with pkgs; [
      cmake
      ffmpeg-full
    ];

    buildInputs = with pkgs; [ ffmpeg ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp ffmpeg_encoder_plugin.dvcp $out/

      runHook postInstall
    '';
  });

  davinci-resolve-studio =
    let
      davinci-patched = pkgs.davinci-resolve-studio.davinci.overrideAttrs (old: {
        # Note: $out IS /opt/resolve
        postInstall = ''
          mkdir -p $out/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/
          cp ${ffmpeg-encoder-plugin}/ffmpeg_encoder_plugin.dvcp $out/IOPlugins/ffmpeg_encoder_plugin.dvcp.bundle/Contents/Linux-x86-64/
        '';
      });
    in

    # the following was copied from davinci's derivation from nixpkgs.
    # if davinci updates, this should be updated too
    # but remember to replace "davinci" with "davinci-patched"
    pkgs.buildFHSEnv {
      inherit (davinci-patched) pname version;

      targetPkgs =
        pkgs:
        with pkgs;
        [
          alsa-lib
          aprutil
          bzip2
          dbus
          expat
          fontconfig
          freetype
          glib
          libGL
          libGLU
          libarchive
          libcap
          librsvg
          libtool
          libuuid
          libxcrypt # provides libcrypt.so.1
          libxkbcommon
          nspr
          ocl-icd
          opencl-headers
          python3
          python3.pkgs.numpy
          udev
          xdg-utils # xdg-open needed to open URLs
          xorg.libICE
          xorg.libSM
          xorg.libX11
          xorg.libXcomposite
          xorg.libXcursor
          xorg.libXdamage
          xorg.libXext
          xorg.libXfixes
          xorg.libXi
          xorg.libXinerama
          xorg.libXrandr
          xorg.libXrender
          xorg.libXt
          xorg.libXtst
          xorg.libXxf86vm
          xorg.libxcb
          xorg.xcbutil
          xorg.xcbutilimage
          xorg.xcbutilkeysyms
          xorg.xcbutilrenderutil
          xorg.xcbutilwm
          xorg.xkeyboardconfig
          zlib
        ]
        ++ [ davinci-patched ];

      extraPreBwrapCmds = ''
        mkdir -p ~/.local/share/DaVinciResolve/license || exit 1
        mkdir -p ~/.local/share/DaVinciResolve/Extras || exit 1
      '';

      extraBwrapArgs = [
        ''--bind "$HOME"/.local/share/DaVinciResolve/license ${davinci-patched}/.license''
        ''--bind "$HOME"/.local/share/DaVinciResolve/Extras ${davinci-patched}/Extras''
      ];

      runScript = "${lib.getExe pkgs.bash} ${pkgs.writeText "davinci-wrapper" ''
        export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
        export QT_PLUGIN_PATH="${davinci-patched}/libs/plugins:$QT_PLUGIN_PATH"
        export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib:/usr/lib32:${davinci-patched}/libs
        ${davinci-patched}/bin/resolve
      ''}";

      extraInstallCommands = ''
        mkdir -p $out/share/applications $out/share/icons/hicolor/128x128/apps
        ln -s ${davinci-patched}/share/applications/*.desktop $out/share/applications/
        ln -s ${davinci-patched}/graphics/DV_Resolve.png $out/share/icons/hicolor/128x128/apps/davinci-resolve-studio.png
      '';

      passthru = {
        inherit davinci-patched;
        updateScript = lib.getExe (
          pkgs.writeShellApplication {
            name = "update-davinci-resolve";
            runtimeInputs = [
              pkgs.curl
              pkgs.jq
              pkgs.common-updater-scripts
            ];
            text = ''
              set -o errexit
              drv=pkgs/by-name/da/davinci-resolve/package.nix
              currentVersion=${lib.escapeShellArg davinci-patched.version}
              downloadsJSON="$(curl --fail --silent https://www.blackmagicdesign.com/api/support/us/downloads.json)"

              latestLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
              update-source-version davinci-resolve "$latestLinuxVersion" --source-key=davinci.src

              # Since the standard and studio both use the same version we need to reset it before updating studio
              sed -i -e "s/""$latestLinuxVersion""/""$currentVersion""/" "$drv"

              latestStudioLinuxVersion="$(echo "$downloadsJSON" | jq '[.downloads[] | select(.urls.Linux) | .urls.Linux[] | select(.downloadTitle | test("DaVinci Resolve")) | .downloadTitle]' | grep -oP 'DaVinci Resolve Studio \K\d+\.\d+(\.\d+)?' | sort | tail -n 1)"
              update-source-version davinci-resolve-studio "$latestStudioLinuxVersion" --source-key=davinci.src
            '';
          }
        );
      };
    };
in

{
  options.solarsystem.modules.youtube = lib.mkEnableOption "youtube config";
  config = lib.mkIf config.solarsystem.modules.youtube {

    programs.obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      plugins = with pkgs.obs-studio-plugins; [
        droidcam-obs
        obs-vaapi
      ];
    };

    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive
      davinci-resolve-studio
      v4l-utils
      scrcpy
    ];

    boot = {
      # Make v4l2loopback kernel module available to NixOS.
      extraModulePackages = with config.boot.kernelPackages; [
        v4l2loopback
      ];
      # Activate kernel module(s).
      kernelModules = [
        # Virtual camera.
        "v4l2loopback"
        # Virtual Microphone. Custom DroidCam v4l2loopback driver needed for audio.
        #    "snd-aloop"
      ];
    };

  };
}
