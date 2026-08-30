{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  mkTmuxPlugin =
    {
      name,
      src,
      rtpFilePath ? "${name}.tmux",
    }:
    pkgs.tmuxPlugins.mkTmuxPlugin {
      pluginName = name;
      version = "flake";
      inherit src rtpFilePath;
    };

  currentPaneHostname = mkTmuxPlugin {
    name = "current-pane-hostname";
    src = inputs.tmux-current-pane-hostname.outPath;
    rtpFilePath = "current_pane_hostname.tmux";
  };

  tmuxTilish = mkTmuxPlugin {
    name = "tilish";
    src = inputs.tmux-tilish.outPath;
  };

  tmuxSshSplit = mkTmuxPlugin {
    name = "ssh-split";
    src = inputs.tmux-ssh-split.outPath;
  };
in
{
  # Required by the explicit X11 clipboard commands in tmux.conf.
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [
    pkgs.xsel
  ];

  programs.tmux = {
    enable = true;

    prefix = "M-o";
    baseIndex = 1;
    historyLimit = 999999999;
    keyMode = "vi";
    mouse = false;

    # Preserve the useful behavior previously enabled by tmux-sensible.
    focusEvents = true;
    aggressiveResize = true;

    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";

    # Preserve the traditional socket location so Linux tmux sessions can
    # remain available after logging out.
    secureSocket = false;

    plugins = [
      currentPaneHostname
      tmuxTilish

      {
        plugin = tmuxSshSplit;
        extraConfig = ''
          set-option -g @ssh-split-h-key '|'
          set-option -g @ssh-split-v-key '\'
          set-option -g @ssh-split-keep-cwd 'true'
          set-option -g @ssh-split-keep-remote-cwd 'true'
        '';
      }
    ];

    extraConfig = builtins.readFile ./config/tmux.conf;
  };
}
