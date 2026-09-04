{ pkgs, lib, ... }:

{
  imports = [
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    bat
    chafa
    chawan
    curl
    dig
    eza
    fd
    file
    fdupes
    fzf
    gh
    kubectl
    less
    lf
    monolith
    ncdu
    jq
    pass
    rclone
    ripgrep
    tree
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

    # Keep the Nix/macOS duplicate function-tree fix.
    initContent = lib.mkOrder 560 ''
      if [[ -d "${pkgs.zsh}/share/zsh/$ZSH_VERSION/functions" ]]; then
	fpath=(''${fpath:#*/share/zsh/*/functions})
	fpath=(
	  "${pkgs.zsh}/share/zsh/$ZSH_VERSION/functions"
	  $fpath
	)
      fi

      if [[ -r "$HOME/.config/lf/lfcd.sh" ]]; then
	source "$HOME/.config/lf/lfcd.sh"
      fi
    '';
    oh-my-zsh = {
      enable = true;

      extraConfig = ''
	zstyle ':omz:update' mode disabled
	ZSH_DISABLE_COMPFIX=true
      '';

      plugins = [
	"git"
	"sudo"
	"extract"
	"fzf"
      ];

      theme = "afowler";
    };
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

  # The scripts choose the appropriate macOS or Linux tools at runtime.
  xdg.configFile."lf".source = ./config/lf;

  # Keep this value unchanged after the initial installation.
  home.stateVersion = "26.05";
}
