{ clan-core, config, ... }:
{
  imports = [
    clan-core.clanModules.sshd
    clan-core.clanModules.diskLayouts
    clan-core.clanModules.root-password
  ];
  networking.wireless = {
    environmentFile = config.sops.secrets.wifi.path;
    networks = {
      azv.psk = "@AZV_PSK@";
      baroustan.psk = "@BAROUSTAN_PSK@";
    };
  };
}
