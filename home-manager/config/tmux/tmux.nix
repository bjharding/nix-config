
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    terminal = "tmux-256color";
    keyMode = "vi";
    escapeTime = 10;
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
      set -ga terminal-overrides ",screen-256color*:Tc"
      set-option -g default-terminal "screen-256color"
      set -s escape-time 0
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
      set -g status-style 'bg=#333333 fg=#5eacd3'
      bind r source-file ~/.config/tmux/tmux.conf
      set -g base-index 1
      set-window-option -g mode-keys vi
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
      # Start session within src directory
      bind-key -r f run-shell "tmux neww ~/.local/scripts/tmux-sessionizer"
      # cht.sh
      bind-key -r i run-shell "tmux neww ~/.local/scripts/tmux-cht.sh"
      # Common (hardcoded projects)
      bind-key -r G run-shell "~/.local/scripts/tmux-sessionizer ~/src/work/manufacturing-portal"
      bind-key -r C run-shell "~/.local/scripts/tmux-sessionizer ~/src/work/ATS"
      bind-key -r R run-shell "~/.local/scripts/tmux-sessionizer ~/src/work/ats-config"
      bind-key -r S run-shell "~/.local/scripts/tmux-sessionizer ~/src/work/ats-client"
    '';
  };

  home.file = {
      ".local/scripts" = {
          recursive = true;
          source = ./scripts;
        };
    };

  home.file = {
      ".cht-config" = {
          source = ./cht-config;
        };
    };
}
