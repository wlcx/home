{ config, pkgs, ... }:

{
  home.stateVersion = "22.05";

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Sam Willcocks";
      userEmail = "sam@wlcx.cc";
      aliases = {
        st = "status";
        co = "checkout";
        d = "diff";
        cim = "commit -m";
        a = "add";
        ap = "add -p";
      };
    };
    fzf.enable = true;
    zsh = {
      enable = true;
      shellAliases = { g = "git"; };
      prezto = {
        enable = true;
        prompt.theme = "giddie";
      };
    };
  };
}
