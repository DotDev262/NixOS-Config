{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  # Shared VS Code settings for all profiles
  sharedVSCodeSettings = {
    "workbench.colorTheme" = "Catppuccin Mocha";
    "workbench.iconTheme" = "catppuccin-icons";

    "editor.fontFamily" = "JetBrainsMono Nerd Font";
    "editor.fontSize" = 14;
    "editor.fontLigatures" = true;

    "editor.cursorStyle" = "phase";
    "editor.cursorBlinking" = "smooth";

    "telemetry.telemetryLevel" = "off";
    "telemetry.enableCrashReporter" = false;
  };
in
{
  ###############################
  ## Home
  ###############################
  home = {
    username = "aryan";
    homeDirectory = "/home/aryan";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;

  ###############################
  ## Git + GPG
  ###############################
  programs.git = {
    enable = true;
    userName = "DotDev262";
    userEmail = "dotdev262@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
      commit.gpgsign = true;
      gpg.program = "gpg";
    };

    signing = {
      key = "365E4C605DB88D45";
      signByDefault = true;
    };
  };

  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 7200;
    maxCacheTtl = 86400;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  ###############################
  ## GitHub CLI / NH
  ###############################
  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "./flake.nix";
  };

  ###############################
  ## Shell + Devbox + Direnv
  ###############################
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      btw = "echo i use nix os btw";
    };

    initExtra = ''
      set -h
      # Direnv hook
      eval "$(direnv hook bash)"
      # Devbox global env
      eval "$(devbox global shellenv --init-hook)"
    '';
  };

  ###############################
  ## VS Code (profiles work now)
  ###############################
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    profiles = {
      default = {
        userSettings = sharedVSCodeSettings;

        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ];
      };

      python = {
        userSettings = sharedVSCodeSettings;

        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          ms-python.python
          ms-python.vscode-pylance
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ];
      };

      java = {
        userSettings = sharedVSCodeSettings;

        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          vscjava.vscode-java-pack
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ];
      };

      flutter = {
        userSettings = sharedVSCodeSettings;

        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          dart-code.dart-code
          dart-code.flutter
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ];
      };

      typst = {
        userSettings = sharedVSCodeSettings;

        extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
          myriad-dreamin.tinymist
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
        ];
      };
    };
  };

  ###############################
  ## Packages
  ###############################
  home.packages = with pkgs; [
    zotero
    vivaldi
    vivaldi-ffmpeg-codecs
    python3Minimal
    libgccjit
    typst
    papers
    nil
    onlyoffice-desktopeditors
    aria2

    # Unstable
    pkgs-unstable.obsidian
    pkgs-unstable.gemini-cli
    pkgs-unstable.devbox
  ];
}
