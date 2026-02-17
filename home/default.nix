{ pkgs, ... }:
{
  imports = [
    ./shell.nix
    ./git.nix
    ./programs.nix
    ./secrets.nix
  ];

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
    jq
    comma

    # Data
    redis

    # AI tools
    gemini-cli

    # Secrets
    age
    sops

    # Test reporting
    allure
  ];
}
