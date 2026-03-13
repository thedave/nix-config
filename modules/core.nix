{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    tmux
    curl
  ];

  environment.systemPath = [ "/opt/homebrew/bin" ];

  users.users."david" = {
    name = "david";
    home = "/Users/david";
  };

  launchd.user.agents.amphetamine-startup = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Amphetamine" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  launchd.user.agents.moom-startup = {
    serviceConfig = {
      ProgramArguments = [ "/usr/bin/open" "-a" "Moom Classic" ];
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  # Enabler zsh system wide
  programs.zsh.enable = true;

  # Tell nix-darwin who the primary user is for Homebrew and user settings
  system.primaryUser = "david";

  # Modify macOS system defaults
  system.defaults = {
    dock = {
      autohide = true;

      # Hot corners
      # Possible values:
      #  0: no-op
      #  2: Mission Control
      #  3: Application Windows
      #  4: Desktop
      #  5: Start Screen Saver
      #  6: Disable Screen Saver
      #  7: Dashboard
      # 10: Put Display to Sleep
      # 11: Launchpad
      # 12: Notification Center
      # 13: Lock Screen
      # 14: Quick Note

      wvous-tl-corner = 13;
      wvous-tr-corner = 2;
      wvous-bl-corner = 4;
      wvous-br-corner = 3;
    };

    finder.AppleShowAllExtensions = true;

    screencapture.location = "/Users/david/Desktop/screenshots";
  };

  system.activationScripts.accessibilitySettings.text = ''
    echo "Setting Accessibility Scroll-to-Zoom..."

    # 1. Enable Scroll-to-Zoom
    defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

    # 2. Set Modifier to Control
    defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

    # 3. Set Panning Mode to Continuous (0)
    # This makes the screen move with the mouse
    defaults write com.apple.universalaccess closeViewPanningMode -int 0

    # Optional: Restart the accessibility daemon to apply changes immediately
    killall universalaccessd || true
  '';

  system.activationScripts.postActivation.text = ''
    DOCKUTIL="/opt/homebrew/bin/dockutil"
    USER="david"

    # Make sure screenshot directory exists
    echo "Setting Screen Capture Location..."
    sudo -u $USER mkdir -p /Users/$USER/Desktop/screenshots

    # Use dockutil to manage the dock
    # --no-restart prevents the Dock from flickering until the end
    echo "Configuring Dock..."
    sudo -u $USER $DOCKUTIL --remove all --no-restart

    # Add Applications
    sudo -u $USER $DOCKUTIL --add "/Applications/Zed.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/Applications/Visual Studio Code.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/Applications/Cursor.app" --no-restart

    #sudo -u $USER $DOCKUTIL --add "" --type spacer --section apps --no-restart

    # Terminal Apps
    sudo -u $USER $DOCKUTIL --add "/Applications/iTerm.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/Applications/Warp.app" --no-restart

    # Add a Spacer (Small or Large)
    #sudo -u $USER $DOCKUTIL --add "" --type spacer --section apps --no-restart

    # Misc Apps
    sudo -u $USER $DOCKUTIL --add "/Applications/Google Chrome.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/Applications/Slack.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/System/Applications/Messages.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/Applications/Spotify.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/Applications/Bitwarden.app" --no-restart
    sudo -u $USER $DOCKUTIL --add "/System/Applications/System Settings.app" --no-restart

    # Add a Folder (e.g., Downloads with specific view settings)
    sudo -u $USER $DOCKUTIL --add "/Users/$USER/Downloads" --view grid --display stack --section others --no-restart

    sudo -u $USER killall Dock

    # Nudge the system to notice
    sudo -u $USER killall SystemUIServer
  '';

  # Enable Touch ID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # Allow unfree packages (hashcat, etc.)
  nixpkgs.config.allowUnfree = true;

  # Required Nix settings
  nix.enable = false;
  system.stateVersion = 4;
}
