{ pkgs, lib, system, ... }: {
  programs.neovim.plugins = with pkgs.vimPlugins;
    [
      # More fancy shit
      nvim-treesitter
      # Language stuff
      nvim-lspconfig
      trouble-nvim
      rust-vim
      vim-terraform
      vim-protobuf
    ]
    # delve is unsupported on aarch64-linux and golangci-lint is broken on x86_64-darwin
    # (see https://github.com/NixOS/nixpkgs/issues/168984).
    ++ lib.optionals (system != "aarch64-linux" && system != "x86_64-darwin") [ vim-go ];
  programs.neovim.extraConfig = ''
    lua <<EOF
        ${builtins.readFile ./dev.lua}
    EOF
  '';
}
