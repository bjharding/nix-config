{
  description = "My config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    polybar-themes = {
      url = "github:adi1090x/polybar-themes";
      flake = false;
    };
    wallpapers = {
      url = "github:bjharding/wallpapers";
      flake = false;
    };
  };

  outputs = 
    { self
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-linux" "x86_64-linux" ];
    in
    rec {
      overlays = {
        default = import ./overlay/default.nix;
        unstable = final: prev: {
          unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        };
      };

      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
          config.allowUnfree = true;
        }
      );

      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
        node = nixpkgs.legacyPackages.${system}.callPackage ./shells/node.nix { };
        python = nixpkgs.legacyPackages.${system}.callPackage ./shells/python.nix { };
        pythonVenv = nixpkgs.legacyPackages.${system}.callPackage ./shells/pythonVenv.nix { };
        lint = nixpkgs.legacyPackages.${system}.callPackage ./shells/lint.nix { };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);

      templates = import ./templates;

      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [ ./hosts/desktop ];
        };
      };

      homeConfigurations = {
        ben = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [ ./home-manager/ben.nix ];
        };
      };
    };
}
