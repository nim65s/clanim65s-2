{ ... }:
{
  imports = [ ./hardware-configuration.nix ];
  users.users.root.openssh.authorizedKeys.keys = [
    # IMPORTANT! Add your SSH key here
    # e.g. > cat ~/.ssh/id_ed25519.pub
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH38Iwc5sA/6qbBRL+uot3yqkuACDDu1yQbk6bKxiPGP nim@loon"
  ];

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  # Disable the default gnome apps to speed up deployment
  services.gnome.core-utilities.enable = false;
}
