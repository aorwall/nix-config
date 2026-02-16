{ pkgs, ... }: {
  # Let Determinate manage the nix daemon and settings
  nix.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # User
  system.primaryUser = "albert";
  users.users.albert = {
    name = "albert";
    home = "/Users/albert";
  };

  # System packages (minimal — prefer home-manager for user tools)
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Make nix-darwin commands available in sudo PATH
  security.sudo.extraConfig = ''
    Defaults secure_path="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  '';


  # Shell
  programs.zsh.enable = true;

  # Required for nix-darwin
  system.stateVersion = 5;
}
