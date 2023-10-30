{ pkgs, lib, ... }: {
  home.activation = {
    zshRecompile = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      HM_REBUILD=1 $DRY_RUN_CMD ${pkgs.zsh}/bin/zsh -l -c 'exit'
    '';
  };  

  programs.zsh = {
    enable = true;

    # Compile scripts for faster loading times
    loginExtra = builtins.readFile ./.zlogin;
    initExtra = builtins.readFile ./.zshrc;

    dotDir = ".config/zsh";
    autocd = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;
    enableCompletion = false; # Manually enabled later
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      ignoreDups = true;
      save = 10000;
      share = true;
      size = 10000;
    };

    shellAliases = {
      g = "git";
      t = "task";
      p = "pnpm";
      c = "cargo";
      d = "docker";
      k = "kubectl";

      cat = "bat";
      ls = "eza";
      l = "eza -a";
      ll = "ls --color=auto -lah";
      la = "ls --color=auto -lah";

      nano = "nvim";
      vim = "nvim";
      htop = "btop";

      nix-rebuild = "darwin-rebuild switch --flake $DOTDIR";
      nix-gc = "nix-collect-garbage --delete-old";
    };

    sessionVariables = {
      DOTDIR = "$HOME/.config/dotfiles";
      LESSHISTFILE = "-";
      OS = "$(uname -s)";
      dd = "$DOTDIR";

      d = "$HOME/Developer";
    };
  };
}
