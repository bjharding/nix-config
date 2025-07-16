{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
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
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    kernelParams = ["module_blacklist=i915"];
  };
  services = {
    xserver.videoDrivers = ["nvidia"];

    # https://www.reddit.com/r/NixOS/comments/1bq2bx4/beginners_guide_to_sunshine_gamedesktop_streaming/
    avahi.publish.enable = true;
    avahi.publish.userServices = true;

    # Enable openssh only to provide key for agenix
    openssh = {
      enable = true;
      openFirewall = false;
    };
  };

  networking = {
    hostName = "ben-desktop";
    firewall = {
      allowedTCPPorts = [11434]; # ollama
    };
  };

  environment.systemPackages = with pkgs; [
    # deploy-rs
    # unstable.yubioath-flutter
  ];
  users.users.${config.mySystem.user}.extraGroups = ["dialout"];
  hardware.graphics = {
    enable = true;
  };

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

  system.stateVersion = "24.05";
}
