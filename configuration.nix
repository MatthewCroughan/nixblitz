{ config, pkgs, lib, ... }:
{

  imports = [
    ./examples/launchTtydOnBoot.nix
    ./examples/launchLnbitsOnBoot.nix
    ./examples/launchClightningOnBoot.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = lib.mkForce [ "bridge" "macvlan" "tap" "tun" "loop" "atkbd" "ctr" ];
    supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "ext4" "vfat" ];
  };

  environment.systemPackages = with pkgs; [ vim git ];

  networking = {
    interfaces."wlan0".useDHCP = true;
    wireless = {
      interfaces = [ "wlan0" ];
      enable = true;
      networks = {
        networkSSID.psk = "password";
      };
    };
  };

  hardware.enableRedistributableFirmware = true;

  users = {
    users.matthew = {
      password = "piratesrus";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPppjyeJucsIQrj0TMWRuTggwrdkHEOawmcfn2nSvnFX matthew@t480"
      ];
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };

  networking.hostName = "lnblitz";

  # Enable ssh on boot
  services.openssh.enable = true;

  # Open port 19999 for Netdata
  networking.firewall.allowedTCPPorts = [ 19999 ];
  services.netdata.enable = true;

  # Enable Avahi mDNS, you should be able to reach http://lnblitz:19999
  # to reach netdata when booted
  services.avahi = {
    openFirewall = true;
    nssmdns = true; # Allows software to use Avahi to resolve.
    enable = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
