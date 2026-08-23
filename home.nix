{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    eza
    fd
    jq
    ripgrep
  ];

  programs.git.enable = true;
  programs.zsh.enable = true;
  programs.home-manager.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.shellAliases = {
    ll = "eza -la";
    cat = "bat";
  };

  # Keep this value unchanged after the initial installation.
  home.stateVersion = "26.05";
}
