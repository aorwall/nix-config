{ ... }: {
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      cleanup = "none"; # Change to "zap" once fully migrated
    };

    taps = [
      "d99kris/nchat"
      "hashicorp/tap"
    ];

    brews = [
      "argocd"
      "claude-squad"
      "d99kris/nchat/nchat"
      "hashicorp/tap/terraform"
      "nvm"
      "chruby"
      "ruby-install"
      "ruby"
    ];

    casks = [
      "alt-tab"
      "blackhole-2ch"
      "claude-code"
      "codex"
      "ghostty"
    ];
  };
}
