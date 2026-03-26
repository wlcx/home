{
  # The basics that you'll want everywhere
  default = ./default.nix;
  # A machine for development
  dev =
    { ... }:
    {
      imports = [
        ./git.nix
        ./vim.nix
        ./vim-dev
        ./helix.nix
      ];
    };
  # A machine for dev with a GUI
  # TODO: detect this automatically somehow?
  dev-gui =
    { ... }:
    {
      imports = [ ./vscode.nix ];
      programs.wezterm = {
        enable = true;
        extraConfig = ''
          return {
            color_scheme = "GruvboxDarkHard",
            keys = {
              {
                key = 'd',
                mods = 'SUPER',
                action = wezterm.action.SplitVertical{domain='CurrentPaneDomain'},
              },
              {
                key = 'D',
                mods = 'SUPER | SHIFT',
                action = wezterm.action.SplitHorizontal{domain='CurrentPaneDomain'},
              },
            },
          }
        '';
      };
    };
  tpmssh = ./tpmssh.nix;
  # Sensitive stuff
  sensitive =
    { ... }:
    {
      imports = [
        ./passwords.nix
        ./gpg.nix
      ];
    };
  # A MacOS machine
  mac = ./macs.nix;
  # A machine you want to do docker stuff on
  docker = ./docker.nix;
  # A machine you want to do aws stuff on
  aws = ./aws.nix;
  # A server
  server =
    { ... }:
    {
      imports = [
        ./default.nix
        ./git.nix
        ./vim.nix
      ];
    };
}
