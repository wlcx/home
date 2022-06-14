{
  dev = {...}: {
    imports = [./default.nix ./git.nix ./rust.nix ./vim.nix ./vim-dev];
  };
  laptop = {...}: {
    imports = [
      ./default.nix
      ./git.nix
      ./macs.nix
      ./rust.nix
      ./vim.nix
      ./vim-dev
      ./passwords.nix
      ./gpg.nix
    ];
  };
  server = {...}: {imports = [./default.nix ./git.nix ./vim.nix];};
}
