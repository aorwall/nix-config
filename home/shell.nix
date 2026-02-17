{ ... }:
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    historySubstringSearch.enable = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = true;
    };

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
      kcn = "kubens";
      kns = "kubens";
      kctx = "kubectx";

      # Ls (eza)
      l = "eza -lah";
      la = "eza -lAh";
      ll = "eza -lh";

      # Claude Code
      claude = "command claude --dangerously-skip-permissions";
      cc = "claude";
      ccc = "claude -c";

      # Nix
      nix-update = "cd ~/.config/nix-config && nix flake update && sudo /run/current-system/sw/bin/darwin-rebuild switch --flake .#albert-mbp && git add flake.lock && git commit -m 'chore: update flake inputs'";

      # Clipboard / screenshot helpers
      cpimg = ''pngpaste /tmp/clipboard.png && echo "/tmp/clipboard.png"'';
      ssimg = ''screencapture -i /tmp/screenshot.png && echo "Screenshot saved. Read /tmp/screenshot.png to view it."'';
    };

    initContent = ''
      # Nix update reminder (checks once per day, warns if flake.lock > 7 days old)
      if [[ ! -f /tmp/.nix-update-check-$UID ]] || [[ $(find /tmp/.nix-update-check-$UID -mmin +1440 2>/dev/null) ]]; then
        touch /tmp/.nix-update-check-$UID
        _nix_lock="$HOME/.config/nix-config/flake.lock"
        if [[ -f "$_nix_lock" ]]; then
          _nix_age=$(( ($(date +%s) - $(stat -f%m "$_nix_lock")) / 86400 ))
          if (( _nix_age >= 7 )); then
            echo "\033[33m[nix] flake.lock is ''${_nix_age} days old. Run 'nix-update' to update.\033[0m"
          fi
          unset _nix_age
        fi
        unset _nix_lock
      fi

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
}
