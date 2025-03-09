{ config, lib, pkgs, ... }:

{
  options.mySystem = with lib; {
    vmHost = mkOption {
      type = types.bool;
      default = false;
    };
    dockerHost = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.mySystem.vmHost {
      users.users.${config.mySystem.user}.extraGroups = [ "libvirtd" ];
      virtualisation.libvirtd.enable = true;
    })
    (lib.mkIf config.mySystem.dockerHost {
      users.users.${config.mySystem.user}.extraGroups = [ "docker" ];
      virtualisation.docker = {
        enable = true;
      };
    })
  ];
}
