{ pkgs, ... }:
{
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
      "workbench.preferredLightColorTheme" = "Gruvbox Light Hard";
      "files.trimTrailingWhitespace" = true;
      "emmet.includeLanguages"."django-html" = "html";
      # Don't try to write to the nix-managed .ssh/config
      "remote.SSH.configFile" = "~/.ssh/config.local";
      "editor.rulers" = [ 90 ];
    };
  };
}
