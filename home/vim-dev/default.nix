{
  pkgs,
  lib,
  system,
  ...
}: {
  programs.neovim.plugins = with pkgs.vimPlugins;
    [
      # More fancy shit
      nvim-treesitter
      trouble-nvim
      # Language server/completions 
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      # Language specific
      go-nvim
      rust-vim
      vim-terraform
      vim-protobuf
      vim-javascript
      vim-vue-plugin
      dhall-vim
      kotlin-vim
      Jenkinsfile-vim-syntax
      html5-vim
    ]
    # delve is unsupported on aarch64-linux and golangci-lint is broken on darwin
    # (see https://github.com/NixOS/nixpkgs/issues/168984).
    ++ lib.optionals (system != "aarch64-linux" && !pkgs.stdenv.isDarwin) [vim-go];
  programs.neovim.extraConfig = ''
    lua <<EOF
        ${builtins.readFile ./dev.lua}
        ${builtins.readFile ./lspconfig-volar.lua}
    EOF
  '';
}
