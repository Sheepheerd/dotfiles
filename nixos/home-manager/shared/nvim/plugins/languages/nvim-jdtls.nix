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

  jdtlsFeaturesDir = "${pkgs.jdt-language-server}/share/java/jdtls/features";
  featureFiles = builtins.attrNames (builtins.readDir jdtlsFeaturesDir);
  matchingFile = builtins.head (builtins.filter
    (f: builtins.match "org.eclipse.equinox.executable_.*.jar" f != null)
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
        cmd = [
          "java"
          "-data"
          "${config.home.homeDirectory}/.cache/jdtls/workspace"
          "-jar"
          jarPath
          "-configuration"
          "${pkgs.jdt-language-server}/share/java/jdtls/config_linux/config.ini"
        ];
        init_options = { bundles = allBundles; };
      };
    };
  };
}
