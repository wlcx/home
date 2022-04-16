{ pkgs, lib, system, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins;
    [
      # More fancy shit
      nvim-treesitter
      # Language stuff
      nvim-lspconfig
      trouble-nvim
      rust-vim
    ] ++ lib.optionals (system != "aarch64-linux") [ vim-go ];
  programs.neovim.extraConfig = ''
    lua <<EOF
        ${builtins.readFile ./dev.lua}
    EOF
  '';
}
