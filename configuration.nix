# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, fetchurl, ... }:

let
  myHostName = "Rizilab";

in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  nixpkgs.config = {
    allowUnfree = true;
  };

  networking = {
    hostName = "${myHostName}";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [80 443];
    firewall.enable = false;    
  };
  
  time.timeZone = "Asia/Jakarta";

  environment = {
    systemPackages = with pkgs; [
      ascii
      attic
      bash
      cabal2nix
      chromium
      cmake
      ctags
      curl
      emacs
      file
      filezilla
      gcc
      gimp
      gitAndTools.git
      gitFull
      gnumake
      inkscape
      kde4.kdemultimedia
      kde4.kdeaccessibility
      kde4.kdeadmin 
      kde4.kdeartwork
      kde4.kdebindings
      kde4.kdegraphics
      kde4.kdelibs
      kde4.kdenetwork
      kde4.kdesdk
      kde4.kdeutils
      kde4.kdetoys
      libreoffice
      lsof
      manpages
      python2nix
      qemu
      remake
      rpPPPoE
      screen
      stdmanpages
      telegram-cli
      tree
      unrar
      unzip
      vim
      w3m
      wget
      wgetpaste
      which
      xmonad-with-packages
      youtube-dl
      zsh
    ];
   
   shellAliases = {
     "lh" = "ls -lahg";
   }; 
  };
  
  security.sudo.enable = true;
  
  services = {
  openssh.enable = true;
  printing.enable = true;
  xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    displayManager.kdm.enable = true;
    desktopManager.kde4.enable = true;
    videoDrivers = [ "nvidia" ];
  };
  };

  users = {
    defaultUserShell = "/run/current-system/sw/bin/bash";
    extraUsers.R = {
      isNormalUser = true;
      createHome = true;
      uid = 1001;
      extraGroups = [ "wheel" "networkmanager" ];
      home = "/home/R";
    };
  };
  system.stateVersion = "16.09";

}
