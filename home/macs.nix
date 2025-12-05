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
  # Use secretive for SSH agent
  programs.ssh.matchBlocks.all = lib.mkIf pkgs.stdenv.isDarwin {
    host = "*";
    extraOptions."IdentityAgent" =
      "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };
  programs.zsh.initContent = "eval $(/opt/homebrew/bin/brew shellenv)";
}
