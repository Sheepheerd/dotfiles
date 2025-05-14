{ pkgs, config, ... }:

let
  javaDebugPath = pkgs.vscode-extensions.vscjava.vscode-java-debug;
  javaTestPath = pkgs.vscode-extensions.vscjava.vscode-java-test;

  debugJarFiles = builtins.attrNames (builtins.readDir
    "${javaDebugPath}/share/vscode/extensions/vscjava.vscode-java-debug/server");
  debugJarPaths = map (name:
    "${javaDebugPath}/share/vscode/extensions/vscjava.vscode-java-debug/server/${name}")
    debugJarFiles;

  testJarFiles = builtins.attrNames (builtins.readDir
    "${javaTestPath}/share/vscode/extensions/vscjava.vscode-java-test/server");
  testJarPaths = map (name:
    "${javaTestPath}/share/vscode/extensions/vscjava.vscode-java-test/server/${name}")
    testJarFiles;

  allBundles = debugJarPaths ++ testJarPaths;

  jdtlsFeaturesDir = "${pkgs.jdt-language-server}/share/java/jdtls/plugins";
  featureFiles = builtins.attrNames (builtins.readDir jdtlsFeaturesDir);
  matchingFile = builtins.head (builtins.filter
    (f: builtins.match "org.eclipse.equinox.launcher_1.*.jar" f != null)
    featureFiles);
  jarPath = "${jdtlsFeaturesDir}/${matchingFile}";
in {
  programs.nixvim = {
    extraPackages = with pkgs; [
      jdt-language-server
      vscode-extensions.vscjava.vscode-java-test
      vscode-extensions.vscjava.vscode-java-debug
    ];
    plugins.jdtls = {
      enable = true;
      settings = {
        # cmd = [
        #   "java"
        #   "-Declipse.application=org.eclipse.jdt.ls.core.id1"
        #   "-Dosgi.bundles.defaultStartLevel=4"
        #   "-Declipse.product=org.eclipse.jdt.ls.core.product"
        #   "-Dlog.protocol=true"
        #   "-Dlog.level=ALL"
        #   "-Xmx1g"
        #   "--add-modules=ALL-SYSTEM"
        #   "--add-opens"
        #   "java.base/java.util=ALL-UNNAMED"
        #   "--add-opens"
        #   "java.base/java.lang=ALL-UNNAMED"
        #   "-jar"
        #   # jarPath
        #   "${pkgs.jdt-language-server}/share/java/jdtls/plugins/org.eclipse.equinox.launcher_1.6.1000.v20250131-0606.jar"
        #   "-configuration"
        #   "${pkgs.jdt-language-server}/share/java/jdtls/config_linux"
        #   "-data"
        #   "${config.home.homeDirectory}/.cache/jdtls/workspace"
        # ];
        cmd = [ "${pkgs.jdt-language-server}/bin/jdtls" ];
        init_options = { bundles = allBundles; };
      };
    };
  };
}
