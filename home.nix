{ config, pkgs, ... }:

{
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "Sam Willcocks";
    userEmail = "sam@wlcx.cc";
  };
}
