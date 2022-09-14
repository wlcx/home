{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer
      jdinhlife.gruvbox
    ];
    userSettings = {
      "update.mode" = "none";
      "workbench.colorTheme" = "Gruvbox Dark Hard";
    };
  };
}
