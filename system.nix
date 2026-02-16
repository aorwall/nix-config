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

  # Shell
  programs.zsh.enable = true;

  # Required for nix-darwin
  system.stateVersion = 5;
}
