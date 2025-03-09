{ pkgs, config, lib, ... }:

let
  cfg = config.myHome.llm;
in
{
  options.myHome.llm.enable = lib.mkEnableOption "llm";
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      ollama
    ];

    # Create a systemd user service for Ollama
    systemd.user.services.ollama = {
      Unit = {
        Description = "Ollama AI service";
        After = ["network.target"];
      };

      Service = {
        Environment = [
          "PATH=${pkgs.lib.makeBinPath [pkgs.nvidia-docker]}"
          "OLLAMA_HOST=127.0.0.1:11434"
          "NVIDIA_VISIBLE_DEVICES=all"
          "OLLAMA_CUDA=1"
        ];
        ExecStart = "${pkgs.ollama}/bin/ollama serve";
        Restart = "always";
      };

      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
