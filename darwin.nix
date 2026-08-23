{ username, ... }:

let
  homeDirectory = "/Users/${username}";
in
{
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;

  users.users.${username} = {
    name = username;
    home = homeDirectory;
  };

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
      # "font-terminus"
      "visual-studio-code"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    # Make username available to imported Home Manager modules.
    extraSpecialArgs = {
      inherit username;
    };

    users.${username} = { ... }: {
      imports = [ ./home.nix ];

      home.username = username;
      home.homeDirectory = homeDirectory;

      # Keep GUI applications owned by Homebrew or manual installations.
      targets.darwin.copyApps.enable = false;

      # Alacritty is installed manually, but its configuration is declarative.
      xdg.configFile."alacritty/alacritty.toml".text = ''
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
