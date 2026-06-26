{
  config,
  pkgs,
  pkgs-stable,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      editor = {
        line-number = "relative";
        cursorline = true;
      };
    };
  };

    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs-stable.vscode-marketplace; [
          eamodio.gitlens
          christian-kohler.path-intellisense
        ];
        userSettings = {
          "editor.formatOnSave" = true;
          "editor.cursorBlinking" = "phase";
          "editor.smoothScrolling" = true;
          "window.performance" = "smooth";
        };
      };
      profiles.typescript = {
        extensions = with pkgs-stable.vscode-marketplace; [
          dbaeumer.vscode-eslint
          esbenp.prettier-vscode
          pmneo.tsimporter
          christian-kohler.path-intellisense
        ];
        userSettings = {
          "editor.formatOnSave" = true;
          "typescript.tsdk" = "${pkgs.typescript}/lib/node_modules/typescript";
        };
      };
    profiles.python = {
      extensions = with pkgs-stable.vscode-marketplace; [
        ms-python.python
        # ms-python.vscode-pylance
        ms-python.mypy-type-checker
        charliermarsh.ruff
      ];
      userSettings = {
        "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python";
        "editor.formatOnSave" = true;
      };
    };
    profiles.java = {
      extensions = with pkgs-stable.vscode-marketplace; [
        vscjava.vscode-java-pack
      ];
    };
    profiles.typst = {
      extensions = with pkgs-stable.vscode-marketplace; [
        myriad-dreamin.tinymist
      ];
      userSettings = {};
    };
  };

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "main";
      user.name = "DotDev262";
      user.email = "dotdev262@gmail.com";
      user.signingkey = "1C3896781C75E5AD";
      credential.helper = "libsecret";
      commit.gpgsign = true;
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = "$all";
    };
  };

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  programs.zoxide.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  programs.fzf.enable = true;
  programs.lazygit.enable = true;
  programs.bat.enable = true;
  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      # Initialize zoxide
      eval "$(zoxide init bash)"

      # Use gpg-agent for SSH
      export GPG_TTY=$(tty)
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
      gpgconf --launch gpg-agent

      # Set GH_TOKEN from agenix secret
      if [ -f "/run/user/$(id -u)/agenix/gh-token" ]; then
        export GH_TOKEN=$(cat "/run/user/$(id -u)/agenix/gh-token")
      fi

      # Nix Helper flake path
      export NH_FLAKE="${config.home.homeDirectory}/nixos-config"

      '';
    shellAliases = {
      rebuild = "nh os switch";
    };
  };

  home.packages = with pkgs; [
    gh
    libsecret
    nil
    ripgrep
    fd
    eza
    mypy
    # Language Tools
    typst

    # New CLI Tools
    just
    lazydocker
    comma
    dust
    alejandra
    
    (writeShellScriptBin "crush" ''
      exec nix run github:numtide/nix-ai-tools#crush -- "$@"
    '')
  ];
}
