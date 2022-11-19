{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    mutableExtensionsDir = false;
    extensions = with pkgs.vscode-extensions; [
      matklad.rust-analyzer
      jdinhlife.gruvbox
      jnoortheen.nix-ide
      editorconfig.editorconfig
    ];
    userSettings = {
      "update.mode" = "none";
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "files.trimTrailingWhitespace" = true;
    };
  };
}
