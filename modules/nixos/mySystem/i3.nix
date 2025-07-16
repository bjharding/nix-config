{ config, lib, pkgs, ... }:

let
  cfg = config.mySystem.i3;
in
{
  options.mySystem.i3 = {
    enable = lib.mkEnableOption "i3";
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        firefox
        wl-clipboard
        spotify

        # i3 essentials
        i3status
        i3lock
        dmenu
        rofi # application launcher
        dunst # notification daemon
        feh # for wallpaper
        picom # compositor for transparency
        arandr # screen layout editor
        lxappearance # GTK theme configuration
        xfce.thunar # file manager
        xfce.xfce4-terminal # terminal
        networkmanagerapplet # network tray icon
        pavucontrol # audio control
        xclip # clipboard manager
      ];
    };

    services = {
      xserver = {
        enable = true;
        xkb.layout = "us";
        displayManager = {
          lightdm = {
            enable = true;
            greeters.slick.enable = true;
          };
        };
        desktopManager = {
          xterm.enable = false;
        };
        windowManager.i3 = {
          enable = true;
          extraPackages = with pkgs; [];
          package = pkgs.i3-gaps; # i3 with gaps between windows
          configFile = null; # Let users configure themselves in ~/.config/i3/config
        };
      };

      # Udev rules
      udev.packages = [];

      # Audio services
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        jack.enable = true;
      };
    };

    programs = {
      zsh.vteIntegration = true;
      # kdeconnect = {
      #   enable = true;
      #   package = pkgs.kdeconnect;
      # };
    };

    security.rtkit.enable = true;

    # i3-specific settings
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      font-awesome # for i3status icons
      dejavu_fonts
    ];

    # Set up authentication agent for GUI privilege escalation dialogs
    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    # Autostart common system tray applications
    systemd.user.services = {
      nm-applet = {
        description = "Network Manager Applet";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet";
          RestartSec = 5;
          Restart = "always";
        };
      };
    };
  };
}
