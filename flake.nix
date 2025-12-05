{
  description = "Samw's home environment, as managed by nix/home-manager.";
  inputs = {
    # Nixpkgs
    nixpkgs = {url = "github:nixos/nixpkgs/release-25.05";};
    nixpkgs-unstable = {url = "github:nixos/nixpkgs";};
    # Other modules
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    devshell = {
      url = "github:numtide/devshell";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: let
    overlays = [
      # Add our own local packages
      (final: prev: {
        # Make my local packages available as pkgs.mypkgs.<foo>
        mypkgs = prev.callPackage ./pkgs {};
      })
      # more up to date ssh-tpm-agent. Can probably ditch this post-24.05
      (final: prev: {
        ssh-tpm-agent = (import inputs.nixpkgs-unstable { system = prev.system; }).ssh-tpm-agent;
      })
    ];
  in (rec {
      profiles = import ./home/profiles.nix;
      lib = {
        mkHome = {
          profiles,
          system,
          username ? "samw",
        }:
          inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = (import inputs.nixpkgs { 
              inherit system;
              config.allowUnfree = true;  # Yes I know it's bad for me
            });
            modules = [
              { home = { 
              inherit username;
              homeDirectory =
                if (inputs.nixpkgs.lib.systems.elaborate system).isDarwin
                then "/Users/${username}"
                else "/home/${username}";
              stateVersion = "21.11";
            };}] ++ profiles ++ [
              {nixpkgs.overlays = overlays;}
              # See comment in home/default.nix.
              ({ pkgs, ... }: {
                nix = {
                  enable = true;
                  package = pkgs.nix;
                  settings.experimental-features = "nix-command flakes";
                  settings.max-jobs = "auto"; # Gotta go fast (build derivations in parallel)
                  # Pin the nixpkgs registry to our locked nixpkgs. This means that we
                  # get the same packages via e.g. nix shell as we have at the system
                  # level, so less duplication overall and no more fetching that 30MB src
                  # every time you run nix shell.
                  registry.nixpkgs.flake = inputs.nixpkgs;
                };
              })
            ];
            extraSpecialArgs = {inherit system;};
          };
      };

      # Standalone home-manager configurations
      homeConfigurations = {
        zinc = lib.mkHome {
          system = "aarch64-darwin";
          profiles = with profiles; [default dev dev-gui sensitive mac];
        };
        luroy = lib.mkHome {
          system = "x86_64-linux";
          profiles = with profiles; [default dev];
        };
        phosphorus = lib.mkHome {
          system = "aarch64-darwin";
          profiles = with profiles; [default dev sensitive mac];
        };
      };
    }
    # Per-system things
    // (inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = overlays ++ [inputs.devshell.overlays.default];
      };
      platform = pkgs.lib.systems.elaborate system;
    in {
      # Flake interface to my local packages.
      # - `callPackage` puts some junk in mypkgs (`override` and
      #   `overrideDerivation`) so we filter out anything that isn't a derivation
      # - We also filter out any packages that aren't supported on the current
      #   platform.
      packages = with pkgs.lib; (filterAttrs (_: v: (isDerivation v && meta.availableOn platform v)) pkgs.mypkgs);
      formatter = pkgs.alejandra;
      # A devshell with useful utils
      devShells.default = pkgs.devshell.mkShell {
        packages = [
          inputs.home-manager.packages.${system}.default
        ];
      };
    })));
}
