{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    #    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    ./hardware-configuration.nix
    ./networking.nix
    ./vm-variant.nix
  ];

  mySystem = {
    gnome.enable = true;
    gaming.enable = true;
    vmHost = true;
    dockerHost = true;
    home-manager = {
      enable = true;
      home = ./home.nix;
    };
    # nix.substituters = [ "nasgul" ];
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      #   grub = {
      #     enable = true;
      #     device = "nodev";
      #     efiSupport = true;
      #     zfsSupport = true;
      #   };
    };
    # kernelParams = [ "module_blacklist=i915" ];
    # supportedFilesystems = [ "zfs" ];
    # zfs = {
    #   forceImportRoot = false;
    # };
    # kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    # binfmt.emulatedSystems = [ "aarch64-linux" ];
    # initrd.luks = {
    #   fido2Support = true;
    #   devices.cryptroot = {
    #     device = "/dev/disk/by-uuid/9155264d-cd48-4d15-bb74-00a9351053d9";
    #     allowDiscards = true;
    #     preOpenCommands = ''
    #       read -rsp "Yubikey PIN: " YUBIKEY_PIN
    #       echo -n "''$YUBIKEY_PIN" > /crypt-ramfs/yubikey-pin
    #     '';
    #     postOpenCommands = ''
    #       rm -f /crypt/ramfs/yubikey-pin
    #     '';
    #     fido2 = {
    #       passwordLess = true;
    #       gracePeriod = 60;
    #       credentials = [
    #         # Generate and add credentials to the LUKS device:
    #         # fido2luks credential --pin
    #         # sudo fido2luks add-key /dev/nvme0n1p2 <credentials-id> -P --salt "string:"
    #         "9c024837f97e2dd71cbf9c22f00c967426fbb467391e5584d84e524c202a27fae5573e145cc68e353f6e86139fb5b43c" # Yubi
    #         "78e68b8392dc93d9ad7a4584718633f9f57a09d6b4d2c6b47504687a343c93beb5ec375588464c78c461a246726ec275" # Yubi-backup
    #         "\" \"--pin\" \"--pin-source\" \"/crypt-ramfs/yubikey-pin" # Ugly hack to inject additional arguments to fido2luks
    #       ];
    #     };
    #   };
    # };
  };
  services = {
    # zfs.autoScrub = {
    #   enable = true;
    #   interval = "weekly";
    # };
    # sanoid = {
    #   enable = true;
    #   interval = "daily";
    #   templates.default = {
    #     hourly = 0;
    #     daily = 14;
    #     monthly = 3;
    #     yearly = 0;
    #   };
    #   datasets = {
    #     "rpool/root" = {
    #       useTemplate = [ "default" ];
    #     };
    #     "rpool/root/home" = {
    #       useTemplate = [ "default" ];
    #     };
    #     "rpool/root/var" = {
    #       useTemplate = [ "default" ];
    #     };
    #   };
    # };

    # xserver.videoDrivers = [ "nvidia" ];

    # Enable openssh only to provide key for agenix
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      # openFirewall = false;
    };
    # nix-serve = {
    #   enable = true;
    #   openFirewall = true;
    #   secretKeyFile = config.age.secrets.cache_priv_key.path;
    # };
    # printing = {
    #   enable = true;
    #   drivers = with pkgs; [
    #     xerox-generic-driver
    #   ];
    # };
    # avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    # };
    # udev.packages = with pkgs; [ qmk-udev-rules yubikey-personalization via ];
    # pcscd.enable = true;

  };
  #   hardware.bluetooth.enable = true;

  #   powerManagement = {
  #     cpuFreqGovernor = "ondemand";
  #     cpufreq.min = 800000;
  #     cpufreq.max = 4700000;
  #   };

  networking = {
    hostName = "ben-desktop";
    # hostId = "0c55ff12";
  };

  #   virtualisation.docker.storageDriver = "zfs";
  environment.systemPackages = with pkgs; [
    # deploy-rs
    # unstable.yubioath-flutter
  ];
  users.users.${config.mySystem.user}.extraGroups = [ "dialout" ];
  hardware.graphics = {
    enable = true;
    #    extraPackages = [
    #      pkgs.vaapiVdpau
    #      pkgs.libvdpau-va-gl
    #    ];
  };

  #  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  # this is for vscode remote ssh
  programs.nix-ld.enable = true;

  #   age.secrets = {
  #     cache_priv_key.file = ../../secrets/mordor_cache_priv_key.pem.age;
  #     extra_access_tokens = {
  #       file = ../../secrets/extra_access_tokens.age;
  #       mode = "0440";
  #       group = config.users.groups.keys.name;
  #     };
  #   };
  system.stateVersion = "24.05";
}
