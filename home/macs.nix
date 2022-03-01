{ pkgs, lib, ... }: {
  # Use secretive for SSH agent
  programs.ssh.matchBlocks.all = lib.mkIf pkgs.stdenv.isDarwin {
    host = "*";
    extraOptions."IdentityAgent" =
      "~/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };
}
