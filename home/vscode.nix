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
      "window.autoDetectColorScheme" = true;
      "workbench.preferredDarkColorTheme" = "Gruvbox Dark Hard";
      "files.trimTrailingWhitespace" = true;
      # Don't try to write to the nix-managed .ssh/config
      "remote.SSH.configFile" = "~/.ssh/config.local";
      "editor.rulers" = [ 90 ];
    };
  };
}
