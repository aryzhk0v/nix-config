{ inputs, pkgs, username, ... }:

let
  homeDirectory = "/Users/${username}";
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;

  programs.zsh = {
    enable = true;

    # Home Manager manages fpath and compinit itself.
    enableGlobalCompInit = false;
  };
  users.users.${username} = {
    name = username;
    home = homeDirectory;
    shell = pkgs.zsh;
  };

  environment.shells = [
    pkgs.zsh
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;

      # Preserve Homebrew packages not declared here.
      cleanup = "none";
    };

    casks = [
      "firefox"
      "grandperspective"
      "hammerspoon"
      "openlogi"
      "visual-studio-code"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    # Make shared values and flake inputs available to Home Manager modules.
    extraSpecialArgs = {
      inherit inputs username;
    };

    users.${username} = { ... }: {
      imports = [ ./home.nix ];

      home.username = username;
      home.homeDirectory = homeDirectory;

      # Keep GUI applications owned by Homebrew or manual installations.
      targets.darwin.copyApps.enable = false;

      # Hammerspoon reads its configuration from ~/.hammerspoon/init.lua.
      home.file.".hammerspoon/init.lua".source =
        ./config/hammerspoon/init.lua;

      # Alacritty is installed manually, but its configuration is declarative.
      xdg.configFile."alacritty/alacritty.toml".text = ''
        [terminal]
	shell = { program = "/run/current-system/sw/bin/zsh", args = ["-l"] }
        [window]
        option_as_alt = "Both"

        [[hints.enabled]]
        command = { program = "open", args = [ "-gu" ] }
        hyperlinks = true
        post_processing = true
        persist = false
        mouse.enabled = true
        binding = { key = "F", mods = "Command|Shift" }
        regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`\\\\]+"

        [selection]
        save_to_clipboard = true

        [font.normal]
        family = "Menlo"
        style = "Regular"
      '';
    };
  };

  # Keep this value unchanged after the initial nix-darwin installation.
  system.stateVersion = 6;
}
