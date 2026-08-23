{ username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Improves Home Manager integration on non-NixOS Linux distributions.
  targets.genericLinux.enable = true;

  xdg.enable = true;

  # Ubuntu normally starts with Bash.
  programs.bash.enable = true;

  # Alacritty itself is installed through APT.
  # Home Manager manages only its configuration.
  xdg.configFile."alacritty/alacritty.yml".text = ''
    selection:
      save_to_clipboard: true

    font:
      normal:
        family: monospace
        style: Regular
  '';
}
