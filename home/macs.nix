{ ... }: {
  home.sessionVariables = {
    # Use secretive for SSH agent
    "SSH_AUTH_SOCK" =
      "/Users/$USERNAME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };
}
