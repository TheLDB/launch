{ pkgs, pkgs-unstable, lib, config, ... }: {
  home.packages = [
    pkgs.rustup
    pkgs.temurin-bin-17
    pkgs.gradle
    pkgs-unstable.nodejs_18
    pkgs-unstable.nodePackages_latest.pnpm
    pkgs-unstable.nodePackages_latest.eslint_d
    pkgs-unstable.prettierd
    pkgs.nmap
    pkgs.mongosh
    pkgs.mongodb-tools
    pkgs.certbot
    pkgs.ldid
    pkgs.gh
    pkgs.awscli2
    pkgs.xz
    pkgs-unstable.rnix-lsp
    pkgs-unstable.lua-language-server
    pkgs-unstable.jdt-language-server
    pkgs.nodePackages_latest.svelte-language-server
    pkgs-unstable.nodePackages_latest.vscode-langservers-extracted
    pkgs-unstable.nodePackages_latest.yaml-language-server
    pkgs-unstable.stylua
    pkgs-unstable.eza
  ];

  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPath = "/tmp/ssh_socket-%r@%h:%p";
    controlPersist = "60m";
    forwardAgent = true;
    includes = [
      "${config.home.homeDirectory}/.ssh/private.config"
      "${config.home.homeDirectory}/.orbstack/ssh/config"
    ];
    matchBlocks = {
      "localhost" = {
        extraOptions = {
          "StrictHostKeyChecking" = "no";
          "UserKnownHostsFile" = "/dev/null";
        };
      };

      "gh" = {
        user = "git";
        hostname = "github.com";
      };
    };
  };

  home.file = {
    ".huskyrc".text = ''
      HOOKS_DIR=$(git config --global core.hooksPath)
      HOOK_PATH="$HOOKS_DIR/$hook_name"

      # hook_name is from the husky script
      if [ -f "$HOOK_PATH" ]; then
        source "$HOOK_PATH"
      fi
    '';
  };

  home.activation = {
    configureRust = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      	  $DRY_RUN_CMD ${pkgs.rustup}/bin/rustup default stable
      	'';
  };
}
