{ clan-core, config, ... }:
{
  imports = [
    clan-core.clanModules.sshd
    clan-core.clanModules.disk-layouts
    clan-core.clanModules.root-password
  ];
}
