{
  description = "My config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-plugins = {
      url = "github:LongerHV/neovim-plugins-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xenon = {
      url = "github:LongerHV/xenon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kubectl = {
      url = "github:LongerHV/kubectl-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    home-manager,
    neovim-plugins,
    xenon,
    kubectl,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    forAllSystems = nixpkgs.lib.genAttrs ["aarch64-linux" "x86_64-linux"];
    overlays = [
      neovim-plugins.overlays.default
      kubectl.overlays.default
      (final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        inherit (nixpkgs-unstable.legacyPackages.${prev.system}) neovim-unwrapped;
      })
    ];
    nixosModules = import ./modules/nixos;
    homeManagerModules = (import ./modules/home-manager) // xenon.homeManagerModules;
    legacyPackages = forAllSystems (
      system:
        import inputs.nixpkgs {
          inherit system overlays;
          config.allowUnfree = true;
        }
    );
  in {
    inherit legacyPackages nixosModules homeManagerModules;

    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix {};
      node = nixpkgs.legacyPackages.${system}.callPackage ./shells/node.nix {};
      go = nixpkgs.legacyPackages.${system}.callPackage ./shells/go.nix {};
      python = nixpkgs.legacyPackages.${system}.callPackage ./shells/python.nix {};
      pythonVenv = nixpkgs.legacyPackages.${system}.callPackage ./shells/pythonVenv.nix {};
      lint = nixpkgs.legacyPackages.${system}.callPackage ./shells/lint.nix {};
    });

    formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".alejandra);

    templates = import ./templates;

    nixosConfigurations = let
      defaultModules =
        (builtins.attrValues nixosModules)
        ++ [
          home-manager.nixosModules.default
          stylix.nixosModules.stylix
        ];
      specialArgs = {inherit inputs outputs overlays;};
    in {
      redviper = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          defaultModules
          ++ [
            ./nixos/redviper
          ];
      };

      work = nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules =
          defaultModules
          ++ [
            ./nixos/work
          ];
      };
    };

    homeConfigurations = {
      work = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs overlays;};
        modules =
          (builtins.attrValues homeManagerModules)
          ++ [
            ./home-manager/work.nix
          ];
      };

      home-dev = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs overlays;};
        modules =
          (builtins.attrValues homeManagerModules)
          ++ [
            ./home-manager/home-dev.nix
          ];
      };
    };
  };
}
