{ config, lib, pkgs, ... }:

let
  cfg = config.myHome.tmux;
in
{
  options.myHome.tmux = with lib; {
    enable = mkEnableOption "tmux";
  };

  config = lib.mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      prefix = "C-a";
      terminal = "tmux-256color";
      escapeTime = 10;
      keyMode = "vi";
      newSession = true;
      plugins = with pkgs; [
        tmuxPlugins.yank
        {
          plugin = tmuxPlugins.power-theme;
          extraConfig = ''
            set -g @tmux_power_theme '#99C794'
          '';
        }
      ];
      extraConfig = ''
        # TERM override
        set terminal-overrides "xterm*:RGB"

        # Enable mouse
        set -g mouse on

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        bind-key x kill-pane # skip "kill-pane 1? (y/n)" prompt
        set -g detach-on-destroy off  # don't exit from tmux when closing a session"

        # Pane movement shortcuts (same as vim)
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Copy mode using 'Esc'
        unbind [
        bind Escape copy-mode

        # Start selection with 'v' and copy using 'y'
        bind-key -T copy-mode-vi v send-keys -X begin-selection

        # Custom
        bind-key -r C run-shell "tmux new-window 'bash -c \"~/.nix-profile/bin/tmux-cht\"'"
        bind-key -r f run-shell "tmux new-window 'bash -c \"~/.nix-profile/bin/tmux-sessionizer\"'"
      '';
    };
    home.packages = with pkgs; [
      (writeShellScriptBin "tmux-sessionizer" (builtins.readFile ./tmux-sessionizer.sh))
      (writeShellScriptBin "tmux-cht" (builtins.readFile ./tmux-cht.sh))
    ];
  };
}
