{ config, pkgs, ... }:

let mypkgs = (import ./modules/pkgs.nix { inherit pkgs; });
in {
  home.packages = mypkgs.all;
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Sam Willcocks";
      userEmail = "sam@wlcx.cc";

      delta = { # Better diffs
        enable = true;
        options = { line-numbers = true; };
      };

      aliases = {
        a = "add";
        ap = "add -p";
        c = "commit";
        can = "commit --amend --no-edit";
        cm = "commit -m";
        co = "checkout";
        d = "diff";
        dc = "diff --cached";
        r = "rebase --autostash";
        ri = "rebase --autostash --interactive";
        st = "status";

        gone = ''
          ! "git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | a
                 │ wk '$2 == \"[gone]\" {print $1}' | xargs -r git branch -D"'';
      };
      extraConfig = {
        branch.sort = "-committerdate";
        log.showSignature = true;
        push.default = "current";
        include.path = "~/.gitconfig.local";
      };
    };
    fzf.enable = true;
    zsh = {
      enable = true;
      shellAliases = {
        g = "git";
        cat = "bat";
        hmswitch = ''home-manager switch --flake ".#$(hostname -s)"'';
      };
      prezto = {
        enable = true;
        prompt.theme = "giddie";
      };
    };
  };
}
