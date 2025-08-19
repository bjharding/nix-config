{
  inputs,
  overlays,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mySystem;
  substituters = {};
in {
  imports = [
    ./fonts.nix
    ./gaming.nix
    ./gnome.nix
    ./i3.nix
    ./stylix.nix
    ./user.nix
    ./virt.nix
  ];

  options.mySystem = with lib; {
    nix.substituters = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = {
    time.timeZone = lib.mkDefault "Australia/Sydney";
    i18n.defaultLocale = lib.mkDefault "en_AU.UTF-8";

    nixpkgs = {
      inherit overlays;
      config.allowUnfree = true;
    };
    nix = {
      package = pkgs.nix;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      registry = lib.mapAttrs (_: value: {flake = value;}) inputs;
      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
      gc = {
        automatic = lib.mkDefault true;
        options = lib.mkDefault "--delete-older-than 14d";
        dates = lib.mkDefault "weekly";
      };
      settings = {
        auto-optimise-store = lib.mkDefault true;
        substituters = map (x: substituters.${x}.url) cfg.nix.substituters;
        trusted-public-keys = map (x: substituters.${x}.key) cfg.nix.substituters;
      };
    };

    services.openssh = with lib; {
      settings.PasswordAuthentication = mkDefault false;
      settings.PermitRootLogin = mkForce "no";
    };

    environment = {
      systemPackages = with pkgs; [
        git
        dnsutils
        pciutils
      ];
      shells = [pkgs.zsh];
    };
  };
}
