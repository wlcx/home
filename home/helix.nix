{ ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "monokai_pro";
      editor = {
        "soft-wrap".enable = true;
        "file-picker".hidden = false;  # Show hidden files (yes it's counter-intuitive)
        gutters = ["diagnostics" "line-numbers" "spacer" "diff"];
        whitespace.render = {
          space = "none";
          tab = "all";
          nbsp = "all";
          nnbsp = "all";
          newline = "none";
        };
      };
    };
    languages = {
      language-server.rust-analyzer.config = {
        # Don't get lost in .direnv etc and chew 100% cpu forever
        files.excludeDirs = [
          ".git"
          ".cargo"
          ".direnv"
        ];
      };
      language = [
        {
          name = "python";
          language-servers = [ "ty" "basedpyright" ];
        }
      ];
    };
  };
}
