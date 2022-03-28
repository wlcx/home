{ pkgs, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins; [
    # More fancy shit
    nvim-treesitter
    # Language stuff
    nvim-lspconfig
    trouble-nvim
    vim-nix
    rust-vim
    vim-go
  ];
  programs.neovim.extraConfig = ''
    lua <<EOF
        ${builtins.readFile ./dev.lua}
    EOF
  '';
}
