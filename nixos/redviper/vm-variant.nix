{
  config,
  lib,
  ...
}: {
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096;
      cores = 4;
    };
    # users.users.${config.mySystem.user}.hashedPassword = "$y$j9T$eqAujvURywlDsQKPXzPjo.$VydW81f92LoGsVB5I5d1X0Ez6dHKEVHLTvMf4NXzbv/";
    users.users.${config.mySystem.user}.initialPassword = "ben";
    services = {
      displayManager = {
        autoLogin = {
          enable = true;
          inherit (config.mySystem) user;
        };
      };
      xserver.displayManager = {
        gdm.autoSuspend = false;
      };
      # nix-serve.enable = lib.mkForce false;
      # resolved.extraConfig = lib.mkForce "";
    };
    # networking.wg-quick.interfaces = lib.mkForce { };
    # virtualisation.docker.storageDriver = lib.mkForce "overlay2";
  };
}
