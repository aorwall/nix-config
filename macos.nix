{ ... }:
{
  # Keyboard remapping
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults = {
    # Keyboard
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
    };

    # Dock
    dock = {
      autohide = true;
      mru-spaces = false;
      show-recents = false;
    };

    # Finder
    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXSortFoldersFirst = true;
    };

    # Login window
    loginwindow = {
      GuestEnabled = false;
    };
  };

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
