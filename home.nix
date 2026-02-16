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
    jq

    # Data
    redis

    # AI tools
    gemini-cli

    # Test reporting
    allure
  ];

  # Zsh — fully managed by home-manager
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      # Navigation (previously from OMZ)
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Git (previously from OMZ)
      g = "git";
      ga = "git add";
      gaa = "git add --all";
      gb = "git branch";
      gc = "git commit";
      gcam = "git commit -am";
      gcmsg = "git commit -m";
      gco = "git checkout";
      gd = "git diff";
      gds = "git diff --staged";
      gf = "git fetch";
      gl = "git pull";
      glog = "git log --oneline --decorate --graph";
      gp = "git push";
      gpf = "git push --force-with-lease";
      grb = "git rebase";
      grbi = "git rebase -i";
      gst = "git status";
      gsw = "git switch";
      gswc = "git switch -c";

      # Kubernetes (previously from OMZ kubectl plugin)
      k = "kubectl";
      kg = "kubectl get";
      kgp = "kubectl get pods";
      kgs = "kubectl get services";
      kgd = "kubectl get deployments";
      kgn = "kubectl get nodes";
      kgi = "kubectl get ingress";
      kgns = "kubectl get namespaces";
      kd = "kubectl describe";
      kdp = "kubectl describe pod";
      kds = "kubectl describe service";
      kdd = "kubectl describe deployment";
      kl = "kubectl logs";
      klf = "kubectl logs -f";
      kaf = "kubectl apply -f";
      kdf = "kubectl delete -f";
      kex = "kubectl exec -it";
      kns = "kubens";
      kctx = "kubectx";

      # Ls
      l = "ls -lah";
      la = "ls -lAh";
      ll = "ls -lh";

      # Claude Code
      claude = "command claude --dangerously-skip-permissions";
      cc = "claude";
      ccc = "claude -c";

      # Clipboard / screenshot helpers
      cpimg = ''pngpaste /tmp/clipboard.png && echo "/tmp/clipboard.png"'';
      ssimg = ''screencapture -i /tmp/screenshot.png && echo "Screenshot saved. Read /tmp/screenshot.png to view it."'';
    };

    sessionVariables = {
      LSCOLORS = "ExGxFxdaCxDaDahbadacec";
      LS_COLORS = "di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=0;41:sg=0;43:tw=0;42:ow=0;44";
    };

    initContent = ''
      # take: mkdir + cd
      take() { mkdir -p "$1" && cd "$1"; }

      # PATH additions
      export PATH="$HOME/.local/bin:$PATH"
      export PATH="/Users/albert/.antigravity/antigravity/bin:$PATH"

      # SDKMAN
      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
      [ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"

      # Poetry completions
      if command -v poetry &>/dev/null; then
        source <(poetry completions zsh)
      fi

      # Poetry activation function
      pactivate() {
        source poetry-activate
      }

      # Bun completions
      [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

      # Google Cloud SDK
      if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then
        source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
      fi
      if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then
        source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
      fi

      # stern pretty-print (JSON logs from moatless namespace)
      sternpp() {
        local pattern="''${1:-moatless-vibe-backend|moatless-ws}"
        local tail="''${2:-20}"
        stern -n moatless "$pattern" --tail="$tail" -o json 2>/dev/null | jq --unbuffered -rR -f ~/.config/stern/fmt.jq
      }

      # Reset prompt on Ctrl+C
      TRAPINT() {
        zle && zle reset-prompt
        return $(( 128 + $1 ))
      }
    '';
  };

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
