{
  # The basics that you'll want everywhere
  default = ./default.nix;
  # A machine for development
  dev = {...}: {
    imports = [ ./git.nix ./rust.nix ./vim.nix ./vim-dev ./vscode.nix ];
  };
  # Sensitive stuff
  sensitive = {...}: {
    imports = [
      ./passwords.nix
      ./gpg.nix
    ];
  };
  # A MacOS machine
  mac = ./macs.nix;
  # A machine you want to do docker stuff on
  docker = ./docker.nix;
  # A machine you want to do aws stuff on
  aws = ./aws.nix;
  # A server
  server = {...}: {imports = [./default.nix ./git.nix ./vim.nix];};
}
