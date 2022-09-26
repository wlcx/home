{
  description = "Samw's home environment, as managed by nix/home-manager.";
  inputs = {
    # Nixpkgs
    nixpkgs = {url = "github:nixos/nixpkgs/nixos-22.05";};
    # Other modules
    home-manager = {
      url = "github:nix-community/home-manager/release-22.05";
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
        # Directly override yubikey-manager
        yubikey-manager = mypkgs.yubikey-manager;
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
            inherit username system;
            stateVersion = "21.11";
            homeDirectory =
              if (inputs.nixpkgs.lib.systems.elaborate system).isDarwin
              then "/Users/${username}"
              else "/home/${username}";
            # In home-manager 22.11 configuration/extraModules go away and are replaced
            # by a single "modules". So let's get ready for that.
            configuration = {...}: {};
            extraSpecialArgs = {inherit system;};
            extraModules = profiles ++ [{nixpkgs.overlays = overlays;}];
          };
      };

      # Standalone home-manager configurations
      homeConfigurations = {
        boron = lib.mkHome {
          system = "aarch64-darwin";
          profiles = with profiles; [default dev sensitive mac docker aws];
          username = "samuel.willcocks";
        };
        zinc = lib.mkHome {
          system = "aarch64-darwin";
          profiles = with profiles; [default dev sensitive mac];
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
