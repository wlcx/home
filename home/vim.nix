# This module sets up a "full" neovim install with plugins and unicorns. It also
# makes neovim the default editor and aliases vim to nvim.
{ pkgs, ... }: {
  home.sessionVariables = { "EDITOR" = "nvim"; };
  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-nix rust-vim ];
    extraConfig = ''
      set relativenumber
      let g:rustfmt_autosave = 1
    '';
  };
  programs.zsh.shellAliases = { vim = "nvim"; };
}
