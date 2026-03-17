{config, ...}: {
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # Removes anything Homebrew installed that isn't listed here
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;

    brews = [
      "dockutil"
      "alejandra"
      "gemini-cli"
      "googleworkspace-cli"
    ];

    casks = [
      # Browsers
      "google-chrome"
      "thebrowsercompany-dia"
      "brave-browser"

      # Misc
      "spotify"
      "bitwarden"
      "slack"
      "obs"
      "obsidian"
      "anki"
      "elgato-control-center"
      "descript"
      "whatsapp"
      "monarch"
      "raycast"
      "zotero"

      # DevTools
      "proxyman"
      "gcloud-cli"

      # Config
      "linearmouse"

      # Window Manager
      "nikitabobko/tap/aerospace"

      # Vibe Code
      "claude-code"
      "claude"

      # Terminals
      "iterm2"
      "warp"

      # Data
      "base" # SQLite 3 editor/viewer
      "tad"

      # Editors
      "zed"
      "visual-studio-code"
      "cursor"

      # Work
      "microsoft-teams"
    ];

    masApps = {
      "Amphetamine" = 937984704;
      "Moom" = 419330170;
      "Loook" = 6745457230;
      "Nord VPN" = 905953485;
      "Okta Verify" = 490179405;
    };
  };
}
