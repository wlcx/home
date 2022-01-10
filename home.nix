{ config, pkgs, ... }:

let mypkgs = (import ./modules/pkgs.nix { inherit pkgs; });
in {
  home.packages = mypkgs.all;
  programs = {
    home-manager.enable = true;

    # Shell and env-y stuff
    zsh = {
      enable = true;
      envExtra = ''
        export SSH_AUTH_SOCK=/Users/sam.willcocks/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
      '';
      shellAliases = {
        g = "git";
        cat = "bat";
        hmswitch = ''home-manager switch --flake ".#$(hostname -s)"'';
        nrswitch = "nixos-rebuild switch --flake '.#'";
      };
      prezto = {
        enable = true;
        prompt.theme = "giddie";
      };
      plugins = [{
        name = "zsh-z";
        file = "share/zsh-z/zsh-z.plugin.zsh";
        src = pkgs.zsh-z;
      }];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      nix-direnv.enableFlakes = true;
    };

    fzf.enable = true;

    # Tools
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
  };
}
