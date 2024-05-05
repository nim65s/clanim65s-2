{ config, ... }:
{
  networking.wireless = {
    allowAuxiliaryImperativeNetworks = true;
    enable = true;
    environmentFile = config.sops.secrets.wifi.path;
    networks = {
      azv.psk = "@AZV_PSK@";
      baroustan.psk = "@BAROUSTAN_PSK@";
    };
    userControlled.enable = true;
  };
}
