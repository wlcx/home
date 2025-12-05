{ ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "monokai_pro";
      editor."soft-wrap".enable = true;
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
