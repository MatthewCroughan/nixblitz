{
  nix-bitcoin.generateSecrets = true;
  services.clightning = {
    enable = true;
    plugins.clboss.enable = true;
  };
}
