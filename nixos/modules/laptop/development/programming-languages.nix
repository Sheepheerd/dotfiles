{ pkgs, pkgs-unstable, ... }:

{

  environment.systemPackages = with pkgs; [
    go
    (python312Full.withPackages
      (ps: with ps; [ pygobject3 gobject-introspection pyqt6-sip ]))
    nodePackages_latest.nodejs
    nodePackages_latest.pnpm
    yarn
    lua
    jdk
    cargo
    jdt-language-server
    uv
    nixfmt
    rustfmt
    rust-analyzer
    #    vscode-extensions.vadimcn.vscode-lldb.adapter
    clojure
  ];
}
