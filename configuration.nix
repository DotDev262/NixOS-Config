# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib,... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  hardware.bluetooth.powerOnBoot = false;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aryan = {
    isNormalUser = true;
    description = "Aryan";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  wget
  git
  helix
  gnomeExtensions.alphabetical-app-grid
  gnomeExtensions.syncthing-toggle
  ];

  environment.gnome.excludePackages = with pkgs;[
    baobab
    cheese
    epiphany
    simple-scan
    yelp
    evince
    geary
    gnome-characters gnome-contacts gnome-maps gnome-connections gnome-weather gnome-software
  ];
  
  fonts.packages = with pkgs;[
    nerd-fonts.jetbrains-mono
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.flatpak.enable = true;
  services.flatpak.remotes = [{
  name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo";
	}];
  services.flatpak.packages = [
    "com.obsproject.Studio"
    "app.zen_browser.zen"
    "io.ente.auth"
  ];
  
  services.syncthing = {
  	enable = true;
  	group = "users";
  	user = "aryan";
  	dataDir = "/home/aryan/Documents";
  	configDir = "/home/aryan/.config/syncthing";
  };
  
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  
  xdg.mime = {
  enable = true;
  defaultApplications = {
    "x-scheme-handler/http" = "app.zen_browser.zen.desktop";
    "x-scheme-handler/https" = "app.zen_browser.zen.desktop";
    "text/html" = "app.zen_browser.zen.desktop";
  };
};

# Disable power-profiles-daemon (required)
services.power-profiles-daemon.enable = false;

# Enable TLP
services.tlp = {
  enable = true;

  # Optional tuning
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "powersave";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    # Charging thresholds
    STOP_CHARGE_THRESH_BAT0 = 80;
  };
};


  
  virtualisation.docker = {
  # Consider disabling the system wide Docker daemon
  enable = false;

  rootless = {
    enable = true;
    setSocketVariable = true;
    # Optionally customize rootless Docker daemon settings
    daemon.settings = {
      dns = [ "1.1.1.1" "8.8.8.8" ];
      registry-mirrors = [ "https://mirror.gcr.io" ];
    };
  };
};

services.fprintd.enable = true;

security.pam.services = {
  sudo.fprintAuth = true;
  gdm-fingerprint.enable = true;
};

# Override the patched module's forced login fingerprint (conflicts with GDM)
security.pam.services.login.fprintAuth = lib.mkForce false;



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
