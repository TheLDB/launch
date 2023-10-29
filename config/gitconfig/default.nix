{ pkgs, config, ... }: {
  programs.git = {
    enable = true;
    userEmail = "ldb@erikboles.com";
    userName = "TheLDB";
    signing = {
      gpgPath = "${pkgs.gnupg}/bin/gpg";
      key = "1C7644A0E4CF7D87AAD4654E27B1F725FAA9C7CB";
      signByDefault = true;
    };
    aliases = {
      redo = "commit --amend -S";
    };
    hooks = {
      commit-msg = ./hook-commit-msg.sh;
      pre-commit = ./hook-pre-commit.sh;
    };
    ignores = [
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon\r"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"
      "*~"
    ];
    lfs.enable = true;
    delta.enable = true;
    extraConfig = {
      core = {
        editor = "${pkgs.neovim}/bin/nvim";
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      protocol = {
        version = 2;
      };
      submodule = {
        fetchJobs = 4;
      };
      merge = {
        conflictstyle = "diff3";
      };
      push = {
        autoSetupRemote = true;
      };
    };
  };
}
