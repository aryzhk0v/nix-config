{ pkgs, ... }:

{
  home.packages = with pkgs; [
    bat
    eza
    fd
    gh
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
    initLua = ''
    vim.opt.clipboard = "unnamedplus"
    if vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil then
      vim.g.clipboard = "osc52"
    end
    '';
  };

  home.shellAliases = {
    ll = "eza -la";
    cat = "bat";
  };

  # Keep this value unchanged after the initial installation.
  home.stateVersion = "26.05";
}
