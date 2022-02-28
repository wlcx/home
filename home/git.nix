{ ... }: {
  programs.git = {
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
      ca = "commit --amend";
      can = "commit --amend --no-edit";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      dc = "diff --cached";
      l = "log";
      lp = "log --patch";
      p = "push";
      pf = "push --force-with-lease";
      r = "rebase";
      rc = "rebase --continue";
      ra = "rebase --autostash";
      rai = "rebase --autostash --interactive";
      st = "status";

      gone = ''
        ! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' │ awk '$2 == "[gone]" {print $1}' | xargs -r git branch -D'';
    };
    extraConfig = {
      branch.sort = "-committerdate";
      log.showSignature = true;
      push.default = "current";
      init.defaultBranch = "main";
    };
    includes = [
      { path = "~/.gitconfig.local"; }
      {
        path = "~/.gitconfig.work";
        condition = "gitdir:~/work/";
      }
    ];
  };
}
