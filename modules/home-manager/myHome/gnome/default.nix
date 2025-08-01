{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.gnome;
in {
  imports = [./terminal.nix];
  options.myHome.gnome = with lib; {
    enable = mkEnableOption "gnome";
    font = {
      package = mkOption {
        type = types.package;
        default = pkgs.nerd-fonts.hack;
      };
      name = mkOption {
        type = types.str;
        default = "Hack Nerd Font";
      };
      size = mkOption {
        type = types.int;
        default = 14;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [cfg.font.package];
    dconf.settings = {
      "org/gnome/desktop/peripherals/trackball" = {
        scroll-wheel-emulation-button = 8;
        middle-click-emulation = true;
      };
      "org/gnome/desktop/sound".event-sounds = false;
      "org/gnome/mutter" = {
        workspaces-only-on-primary = true;
        dynamic-workspaces = true;
        edge-tiling = true;
      };
    };
  };
}
