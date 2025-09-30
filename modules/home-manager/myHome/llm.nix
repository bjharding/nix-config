{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.myHome.llm;
in {
  options.myHome.llm = with lib; {
    enable = mkEnableOption "llm";
    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address for Ollama to listen on. Use 0.0.0.0 to listen on all interfaces.";
    };
    port = mkOption {
      type = types.port;
      default = 11434;
      description = "Port for Ollama to listen on.";
    };
    acceleration = mkOption {
      type = types.str;
      default = "cuda";
      description = "Acceleration type (cuda, rocm, or none)";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ollama
    ];
  };
}
