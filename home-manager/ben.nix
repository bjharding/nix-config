{ inputs, lib, config, pkgs, ... }: {
  imports = [
    ./features/cli
    ./features/browser/firefox.nix
    ./features/productivity
    ./features/tmux
    ./features/i3
    ./features/desktop/wallpaper
  ];

  nixpkgs = {
    overlays = [
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
      permittedInsecurePackages = pkgs.lib.optional (pkgs.obsidian.version == "1.4.16") "electron-25.9.0";
    };
  };

  home = {
    username = "ben";
    homeDirectory = "/home/ben";
  };

  # for i3. not sure if it should be here
  # home.file = {
  #   # xrandr - set primary screen
  #   ".screenlayout/monitor.sh".source = ../hosts/desktop/i3/dual-monitors.sh;
  # };

  home.packages = with pkgs; [
    act
    any-nix-shell        # fish support for nix shell
    arandr               # simple GUI for xrandr
    colordiff
    direnv
    discord
    docker-compose
    firefox
    go
    kitty
    lutris              # battle.net
    wine
    netcat
    ollama
    openssh
    path-of-building
    polybar
    prusa-slicer
    nixfmt
    rofi
    spotify-tui
    vscode
    wget
    yj
    yq

    rofi # application launcher, the same as dmenu
    polybar # status bar
    pywal # generate color scheme from wallpaper
    calc
    networkmanager_dmenu # network manager

    dunst # notification daemon
    i3lock # default i3 screen locker
    xautolock # lock screen after some time
    picom # transparency and shadows
    feh # set wallpaper
    xcolor # color picker
    xsel # for clipboard support in x11, required by tmux's clipboard support

    acpi # battery information
    arandr # screen layout manager
    dex # autostart applications
    xbindkeys # bind keys to commands
    xorg.xbacklight # control screen brightness, the same as light
    xorg.xdpyinfo # get screen information
    scrot # minimal screen capture tool, used by i3 blur lock to take a screenshot
    sysstat # get system information
    alsa-utils # provides amixer/alsamixer/...
    flameshot
    psmisc # killall/pstree/prtstat/fuser/...
    nushell

    todoist-electron
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
