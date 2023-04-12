################################################################################
## NixOS Configuration File
################################################################################

{ config, pkgs, lib, ... }:

# Enable unstable channel for certain packages
let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in

{
  ##############################################################################
  ## Imports
  ##############################################################################

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ##############################################################################
  ## Boot Loader
  ##############################################################################

  # Whether to enable the systemd-boot (formerly gummiboot) EFI boot manager.
  boot.loader.systemd-boot.enable = true;

  # Whether the installation process is allowed to modify EFI boot variables.
  boot.loader.efi.canTouchEfiVariables = true;

  ##############################################################################
  ## General
  ##############################################################################

  # The time zone used when displaying times and dates.
  time.timeZone = "Asia/Kolkata";

  # Whether to periodically upgrade NixOS to the latest version.
  # system.autoUpgrade.enable = true;

  ##############################################################################
  ## Networking
  ##############################################################################

  networking = {
    # The name of the machine.
    hostName = "nixos";

    # Whether to enable support for IPv6.
    enableIPv6 = false;

    # Whether to enable wpa_supplicant.
    # wireless.enable = true;

    # Whether this interface should be configured with dhcp.
    interfaces.enp0s3.useDHCP = true;
  };

  ##############################################################################
  ## Package Management
  ##############################################################################

  # Set of default packages that aren't strictly necessary for a running system,
  # entries can be removed for a more minimal NixOS installation.
  environment.defaultPackages = [];

  nixpkgs.config = {
    # Allow all unfree packages.
    allowUnfree = true;

    # Allow all broken packages.
    allowBroken = true;

    # Allow certain unstable packages.
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # Cisco Packet Tracer
  # https://cpxiv.s3.amazonaws.com/cisco/CiscoPacketTracer_801_Ubuntu_64bit.deb;

  # The set of packages that appear in "/run/current-system/sw".
  environment.systemPackages = with pkgs; [
    # Basic Utilities
    wget zip unzip p7zip git
    feh fff
    micro xclip
    neovim

    # Xmonad Related
    haskellPackages.xmobar
    termonad
    dmenu

    # Languages
    ghc haskell-language-server
    python3

    # Extra
    firefox
    anki
    git
    ciscoPacketTracer8

    # Icons
    papirus-icon-theme

    # Fonts
    ubuntu_font_family
    recursive
    iosevka
  ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      recursive
      inter
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Inter" ];
      };
    };
  };

  ##############################################################################
  ## Graphical User Interface
  ##############################################################################

  services = {
    xserver = {
      # Whether to enable the X server.
  	  enable = true;

  	  # Enable touchpad support (enabled default in most desktopManager).
  	  libinput.enable = true;

      windowManager.xmonad = {
        # Whether to enable xmonad.
       	enable = true;

       	# Enable xmonad-{contrib,extras} in Xmonad.
       	enableContribAndExtras = true;

       	# Whether to enable unstable branch for xmonad.
       	haskellPackages = pkgs.unstable.haskellPackages;

       	# Extra packages available to ghc when rebuilding Xmonad.
       	extraPackages = haskellPackages: [
       	  haskellPackages.xmonad
       	  haskellPackages.xmonad-contrib
       	  haskellPackages.xmonad-extras
        ];
      };

      # Enable a xterm terminal as a desktop manager.
      desktopManager.xterm.enable = false;

      # No desktop manager and xmonad as the window manager.
      displayManager.defaultSession = "none+xmonad";

    };

    picom = {
      # Whether or not to enable Picom as the X.org composite manager.
      enable = true;

      # Opacity of active windows.
      activeOpacity = 1.0;

      # Opacity of inactive windows.
      inactiveOpacity = 0.9;

      # Draw window shadows.
      shadow = true;
    };
  };

  ##############################################################################
  ## Environment Variables
  ##############################################################################

  environment.variables = {
    # Terminal
  	EDITOR = "nvim";
    COLORTERM = "truecolor";
  	
    # Micro
  	MICRO_CONFIG_HOME = "/home/$USER/.config/micro";
  	MICRO_TRUECOLOR = "1";

  	# Xmonad
  	XMONAD_CONFIG_DIR = "/home/$USER/.config/xmonad";

    # Git
    GIT_PS1_SHOWCOLORHINTS = "true";
  };

  ##############################################################################
  ## VirtualBox
  ##############################################################################

  fileSystems."/vbshare" = {
    # Type of the file system.
    fsType = "vboxsf";

    # Name of the folder.
    device = "vbshare";

    # Options used to mount the file system.
    options = [ "rw" "nofail" ];
  };

  ##############################################################################
  ## Sound Settings
  ##############################################################################

  # Whether to enable ALSA sound.
  sound.enable = true;

  # Whether to enable the PulseAudio sound server.
  hardware.pulseaudio.enable = true;

  ##############################################################################
  ## User Management
  ##############################################################################

  users = {
    # The contents of the user and group files will simply be replaced on
    # system activation.
    mutableUsers = false;

    # Additional user accounts to be created automatically by the system.
    extraUsers = {
      # root = {
      #   hashedPassword = "!";
      # };

      hackstation = {
        isNormalUser = true;
        extraGroups = [ "users" "wheel" ];
        hashedPassword = "$6$cMj0UFK6UA73wzd1$X/idIp45ALWTpizc1/" +
        "kOYiuTtdtlyKj6sdh0w.XKCWbM9l.q2I5ARDED1g1n8lYGTpe47qFkVeGK18veUMLlA1";
        # openssh.authorizedKeys.keys = [ "" ];
      };
    };
  };

  ##############################################################################
  ## List Packages
  ##############################################################################

  environment.etc."current-system-packages".text =
  let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  ##############################################################################
  ## List Services
  ##############################################################################

  # Whether to enable the OpenSSH secure shell daemon,
  # which allows secure remote logins.
  services.openssh.enable = true;
}
