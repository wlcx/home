{
  dev = { ... }: {
    imports = [ ./default.nix ./git.nix ./rust.nix ./vim.nix ./vim-dev.nix ];
  };
  laptop = { ... }: {
    imports = [
      ./default.nix
      ./git.nix
      ./macs.nix
      ./rust.nix
      ./vim.nix
      ./vim-dev.nix
      ./passwords.nix
    ];
  };
  server = { ... }: { imports = [ ./default.nix ./git.nix ./vim.nix ]; };
}
