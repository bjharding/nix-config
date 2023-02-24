{
  description = "My config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    neovim-plugins.url = "github:LongerHV/neovim-plugins-overlay";
    neovim-plugins.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , nixos-hardware
    , flake-utils
    , home-manager
    , neovim-nightly-overlay
    , agenix
    , neovim-plugins
    , ...
    }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs flake-utils.lib.defaultSystems;
    in
    rec {
      overlays = {
        default = import ./overlay/default.nix;
        unstable = final: prev: {
          unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        };
        neovimNightly = neovim-nightly-overlay.overlay;
        neovimPlugins = neovim-plugins.overlays.default;
        agenix = agenix.overlays.default;
      };

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      devShells = forAllSystems
        (system: {
          default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
          lint = nixpkgs.legacyPackages.${system}.callPackage
            ({ pkgs, ... }: pkgs.mkShellNoCC {
              nativeBuildInputs = with pkgs; [ actionlint selene statix nixpkgs-fmt yamllint ];
            })
            { };
        });

      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);

      templates = import ./templates;

      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      homeConfigurations = {
        # VM
        ben = home-manager.lib.homeManagerConfiguration {
          pkgs = legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = (builtins.attrValues homeManagerModules) ++ [
            ./home-manager/vm.nix
          ];
        };
      };
    };
}
