{ pkgs, ... }: {
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  homebrew = {
    enable = true;
    caskArgs = {
      no_quarantine = true;
    };
    casks = [
      "1password"
      "daisydisk"
      "discord"
      "arc"
      "imageoptim"
      "monitorcontrol"
      "mullvadvpn"
      "orbstack"
      "raycast"
      "spotify"
      "tailscale"
      "xcodes"
    ];
  };

  networking = {
    knownNetworkServices = [
      "Wi-Fi"
    ];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 0;
      };
    };
  };

  programs.zsh = {
    enable = true;
    promptInit = "";
    enableCompletion = false; # Handled by local zshrc after zcompile runs
  };

  system.defaults = {
    CustomUserPreferences = {
      "com.apple.dock" = {
        show-recent-count = 1;
      };
      # "com.knollsoft.Rectangle" = {
      #   leftHalf.modifierFlags = 1179648;
      #   rightHalf.modifierFlags = 1179648;
      #   center.modifierFlags = 1179648;
      #   maximize.modifierFlags = 1179648;
      #
      #   leftHalf.keyCode = 4;
      #   rightHalf.keyCode = 37;
      #   center.keyCode = 38;
      #   maximize.keyCode = 40;
      # };
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.5;
      showhidden = true;
      show-recents = true;
      wvous-tl-corner = 12; # Notification Center
      wvous-tr-corner = 12;
      wvous-bl-corner = 11; # Launchpad
      wvous-br-corner = 11;
    };

    finder = {
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    menuExtraClock.ShowSeconds = true;
    screencapture.type = "png";
  };

  time.timeZone = "America/Denver";

  users.users.landonboles = {
    name = "landonboles";
    home = "/Users/landonboles";
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.landonboles = { pkgs, lib, ... }: {
    home.stateVersion = "23.05";
    home.activation = {
      # nix-darwin doesn't set defaults when running as sudo
      smartCardDisablePairing = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD /usr/bin/sudo /usr/bin/defaults write /Library/Preferences/com.apple.security.smartcard UserPairing -bool false
      '';
    };

    programs.home-manager.enable = true;
    imports = [
      ./packages.nix
      ./env
      ./gitconfig
      ./zsh
      # ./gnupg - idk what this is
      ./nvim
      # ./tui - dont like
    ];
  };

  system.patches = [
    (pkgs.writeText "pam_tid.patch" ''
      --- /etc/pam.d/sudo	2023-09-28 09:27:50
      +++ /etc/pam.d/sudo	2023-09-28 09:27:54
      @@ -1,4 +1,6 @@
       # sudo: auth account password session
      +auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
      +auth       sufficient     pam_tid.so
       auth       include        sudo_local
       auth       sufficient     pam_smartcard.so
       auth       required       pam_opendirectory.so
    '')
  ];
}
