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
      language-server.basedpyright = {
        command = "basedpyright-langserver";
        args = [ "--stdio" ];
      };
      language = [
        {
          name = "python";
          roots = [
            "pyproject.toml"
            "setup.py"
            "poetry.lock"
            ".git"
          ];
          language-servers = [
            {
              name = "basedpyright";
            }
          ];
        }
      ];
    };
  };
}
