#{ pkgs, ... }:
{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    bat
    eza
    fd
    gh
    jq
    lf
    ripgrep
  ];

  programs.git = {
    enable = true;

    settings.user = {
      name = "aryzhk0v";
      email = "125603030+aryzhk0v@users.noreply.github.com";
    };
  };
  programs.zsh = {
    enable = true;

    initContent = lib.mkOrder 560 ''
      if [[ -d "${pkgs.zsh}/share/zsh/$ZSH_VERSION/functions" ]]; then
        fpath=(''${fpath:#*/share/zsh/*/functions})
        fpath=(
          "${pkgs.zsh}/share/zsh/$ZSH_VERSION/functions"
          $fpath
        )
      fi
    '';

    completionInit = ''
      autoload -Uz compinit

      mkdir -p "$HOME/.cache/zsh"
      dump="$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

      if [[ -r "$dump" ]]; then
        compinit -C -d "$dump"
      else
        compinit -d "$dump"
      fi
    '';
  };

  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    initLua = ''
    vim.opt.clipboard = "unnamedplus"
    if vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil then
      vim.g.clipboard = "osc52"
    end
    '';
  };

  home.shellAliases = {
    ll = "eza -la";
    l = "eza -l";
    cat = "bat";
  };

  # Keep this value unchanged after the initial installation.
  home.stateVersion = "26.05";
}
