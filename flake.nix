{
  description = "My config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:NixOS/nixos-hardware/master";
#    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    neovim-plugins.url = "github:LongerHV/neovim-plugins-overlay";
    neovim-plugins.inputs.nixpkgs.follows = "nixpkgs";

    fish-bobthefish-theme = {
      url = github:gvolpe/theme-bobthefish;
      flake = false;
    };

  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
#    , flake-utils
    , home-manager
    , neovim-nightly-overlay
    , neovim-plugins
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      forEachSystem = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      forEachPkgs = f: forEachSystem (sys: f nixpkgs.legacyPackages.${sys});
#      forAllSystems = nixpkgs.lib.genAttrs flake-utils.lib.defaultSystems;
    in
    {
      overlays = {
        default = import ./overlay/default.nix;
        unstable = final: prev: {
          unstable = nixpkgs-unstable.legacyPackages.${prev.system};
        };
        neovimNightly = neovim-nightly-overlay.overlay;
        neovimPlugins = neovim-plugins.overlays.default;
#        agenix = agenix.overlays.default;
      };

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

#      devShells = forAllSystems
#        (system: {
#          default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
#          lint = nixpkgs.legacyPackages.${system}.callPackage
#            ({ pkgs, ... }: pkgs.mkShellNoCC {
#              nativeBuildInputs = with pkgs; [ actionlint selene statix nixpkgs-fmt yamllint ];
#            })
#            { };
#        });

      devShells = forEachPkgs (pkgs: import ./shell.nix { inherit pkgs; });

#      formatter = forAllSystems (system: nixpkgs.legacyPackages."${system}".nixpkgs-fmt);

      formatter = forEachPkgs (pkgs: pkgs.nixpkgs-fmt);

      templates = import ./templates;

#      packages = forEachPkgs (pkgs: (import ./pkgs { inherit pkgs; }) // {
#        neovim = let
#          homeCfg = home-manager.lib.homeManagerConfiguration {
#            inherit pkgs;
#            extraSpecialArgs = { inherit inputs outputs; };
#            modules = [ ./home/misterio/generic.nix ];
#          };
#          pkg = homeCfg.config.programs.neovim.finalPackage;
#          init = homeCfg.config.xdg.configFile."nvim/init.lua".source;
#        in pkgs.writeShellScriptBin "nvim" ''
#          ${pkg}/bin/nvim -u ${init} "$@"
#        '';
#      });

#      legacyPackages = forAllSystems (system:
#        import inputs.nixpkgs {
#          inherit system;
#          overlays = builtins.attrValues overlays;
#          config.allowUnfree = true;
#        }
#      );

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
          modules = [ ./home-manager/vm.nix ];
        };
      };
    };
}
