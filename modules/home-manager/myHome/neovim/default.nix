{ config, lib, pkgs, ... }:

let
  neovim-unwrapped = pkgs.unstable.neovim-unwrapped.overrideAttrs (old: {
    meta = old.meta or { } // {
      maintainers = [ ];
    };
  });
in
{
  imports = [ ./plugins ];

  options.myHome.neovim = with lib; {
    enable = mkEnableOption "neovim";
    enableLSP = mkEnableOption "enableLSP";
  };

  config = lib.mkIf config.myHome.neovim.enable {
    home.sessionVariables.EDITOR = "nvim";
    programs.xenon = {
      enable = true;
      package = neovim-unwrapped;
      aliases = [ "nvim" "vim" "vi" ];
      initFiles = [
        ./init.lua
        ./theme.lua
        ./keymaps.lua
      ];
      extraPackages = with pkgs; [
        nodePackages.npm
      ];
    };
  };
}
