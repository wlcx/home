{
  description = "Samw's home environment, as managed by nix/home-manager.";
  inputs = {
    # Nixpkgs
    nixpkgs = {url = "github:nixos/nixpkgs/release-22.11";};
    # Other modules
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
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
      (final: prev: rec {
        # Make my local packages available as pkgs.mypkgs.<foo>
        mypkgs = prev.callPackage ./pkgs {};
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
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            modules = [
              { home = { 
              inherit username;
              homeDirectory =
                if (inputs.nixpkgs.lib.systems.elaborate system).isDarwin
                then "/Users/${username}"
                else "/home/${username}";
              stateVersion = "21.11";
            };}] ++ profiles ++ [{nixpkgs.overlays = overlays;}];
            extraSpecialArgs = {inherit system;};
          };
      };

      # Standalone home-manager configurations
      homeConfigurations = {
        boron = lib.mkHome {
          system = "aarch64-darwin";
          profiles = with profiles; [default dev dev-gui sensitive mac docker aws];
          username = "samuel.willcocks";
        };
        zinc = lib.mkHome {
          system = "aarch64-darwin";
          profiles = with profiles; [default dev dev-gui sensitive mac];
        };
        luroy = lib.mkHome {
          system = "x86_64-linux";
          profiles = with profiles; [default dev];
        };
      };
    }
    # Per-system things
    // (inputs.flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = overlays ++ [inputs.devshell.overlay];
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
          inputs.home-manager.defaultPackage.${system}
        ];
      };
    })));
}
