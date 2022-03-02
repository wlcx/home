{
  dev = { ... }: { imports = [ ./default.nix ./git.nix ./rust.nix ./vim.nix ]; };
  laptop = { ... }: {
    imports = [ ./default.nix ./git.nix ./macs.nix ./rust.nix ./vim.nix ./passwords.nix ];
  };
}
