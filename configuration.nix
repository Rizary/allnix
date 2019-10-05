# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, fetchurl, lib, ... }:

let
  myHostName = "Rizilab";

in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      
      # include cachix
      ./cachix.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.kernelParams = [ "video=hyperv_fb:1920x1080 elevator=noop" ];
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

  virtualisation.docker.enable = true;

  fileSystems."/home/rizilab/nixosNFS" = {
    device = "/mnt/nixosNFS";
    options = ["bind"];
  };
  
  time.timeZone = "Asia/Jakarta";

  environment = {
    systemPackages = with pkgs; [
      ascii
      bash
      cabal2nix
      chromium
      cmake
      ctags
      curl
      direnv
      emacs
      file
      filezilla
      gcc
      gitAndTools.git
      gitFull
      gnumake
      libreoffice
      lsof
      manpages
      python2nix
      qemu
      remake
      rpPPPoE
      screen
      stdmanpages
      tree
      unrar
      unzip
      vim
      w3m
      wget
      wgetpaste
      which
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
      xkbVariant = "dvorak";
      xkbOptions = "eurosign:e";
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      modules = [ pkgs.xorg.xf86videofbdev ];
      videoDrivers = [ "hyperv_fb" ];
      #resolutions = [{ x = 1920; y = 1080; }];
    
    };
    mongodb = { enable = true ; };
    nfs = {
      server.enable = true;
      server.exports = ''
        /home/rizilab           192.168.1.0/24(insecure,rw,sync,no_subtree_check,crossmnt,fsid=0)
	/home/rizilab/nixosNFS  192.168.1.0/24(insecure,rw,sync,no_subtree_check)
      '';
    };
  
  };

  users = {
    defaultUserShell = "/run/current-system/sw/bin/bash";
    extraUsers.rizilab = {

      isNormalUser = true;
      createHome = true;
      uid = 1001;
      extraGroups = [ "wheel" "docker" "networkmanager" ];
      home = "/home/rizilab";
      openssh.authorizedKeys.keys = [
        ""
      ];
    };
  };
  nix.binaryCaches = [ "https://cache.nixos.org/" 
                       "https://nixcache.reflex-frp.org" 
                       "https://all-hies.cachix.org/"
                       "https://cache.dhall-lang.org"
                     ];
  nix.envVars = {
    NIX_GITHUB_PRIVATE_USERNAME = "";
    NIX_GITHUB_PRIVATE_PASSWORD = "";
  };
  nix.binaryCachePublicKeys = [ "ryantrinkle.com-1:JJiAKaRv9mWgpVAz8dwewnZe0AzzEAzPkagE9SP5NWI=" 
                                "all-hies.cachix.org-1:JjrzAOEUsD9ZMt8fdFbzo3jNAyEWlPAwdVuHw4RD43k="
                                "cache.dhall-lang.org:I9/H18WHd60olG5GsIjolp7CtepSgJmM2CsO813VTmM="                              
                              ];

  system.stateVersion = "19.03";

}
