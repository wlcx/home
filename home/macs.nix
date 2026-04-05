{
  pkgs,
  lib,
  ...
}:
{
  # Mac specific packages.
  # TODO: have this in a central packages place rather than here
  home.packages = with pkgs; [
    pngpaste
    mypkgs.qrclip
  ];
  home.sessionPath = [
    "/Applications/Sublime Merge.app/Contents/SharedSupport/bin"
  ];
  # Use secretive for SSH agent
  programs.ssh.matchBlocks.all = lib.mkIf pkgs.stdenv.isDarwin {
    host = "*";
    extraOptions."IdentityAgent" =
      "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };
  programs.zsh.sessionVariables.SSH_AUTH_SOCK = "$HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  programs.zsh.initContent = "[ -e /opt/homebrew/bin/brew ] && eval $(/opt/homebrew/bin/brew shellenv)";
}
