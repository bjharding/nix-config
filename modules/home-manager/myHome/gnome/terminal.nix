{
  config,
  lib,
  pkgs,
  ...
}: let
  fontName = lib.mkForce "Maple Mono NF";
  fontSize = 15;
in {
  config = lib.mkIf config.myHome.gnome.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        font = {
          normal = {
            family = fontName;
            style = "Regular";
          };
          bold = {
            family = fontName;
            style = "Bold";
          };
          italic = {
            family = fontName;
            style = "Italic";
          };
          bold_italic = {
            family = fontName;
            style = "Bold Italic";
          };
          size = fontSize;
        };
      };
      settings = {
        terminal.shell = {
          args = ["new-session" "-A" "-D" "-s" "main"];
          program = "${pkgs.tmux}/bin/tmux";
        };
      };
    };
  };
}
