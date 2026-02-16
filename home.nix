{ pkgs, ... }: {
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # Cloud & Infrastructure
    azure-cli
    eksctl
    helmfile
    stern

    # Development tools
    ast-grep
    bun
    cmake
    automake
    bison
    go-task
    hugo
    imagemagick
    pipx
    protobuf
    scc
    vhs
    zig

    # Utilities
    ffmpeg
    pngpaste
    switchaudio-osx
    ripgrep

    # Data
    redis

    # AI tools
    gemini-cli

    # Test reporting
    allure
  ];

  # Programs with dedicated home-manager modules
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.gh = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };
}
