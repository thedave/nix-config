{
  config,
  pkgs,
  ...
}: {
  # Home Manager requires this to know which version it is running
  home.stateVersion = "25.11";

  # ── Packages ─────────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    # Shell utilities (previously brew formulae)
    bat # better cat
    fd # better find
    jq # JSON processor
    ripgrep # better grep
    wget # HTTP downloader

    # Version control
    gh # GitHub CLI

    # Databases
    duckdb

    # JVM / Scala
    jdk # OpenJDK (latest LTS)

    # Node.js  (replaces brew node + nvm for global tooling)
    nodejs_22 # matches your previous nvm v22.14.0
    pnpm # fast package manager

    # Python (one canonical version; use per-project flakes for 3.9/3.12)
    python314

    # Rust toolchain (replaces brew rust)
    rustup

    # Misc dev tools
    hashcat # password auditing
  ];

  # ── Git ───────────────────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "David Welch";
        email = "dwelch@zencore.dev";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    ignores = [
      ".DS_Store"
      ".direnv"
    ];
  };

  # ── Zsh ───────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";

    history = {
      size = 50000;
      save = 50000;
      share = true;
      ignoreDups = true;
      expireDuplicatesFirst = true;
    };

    # Built-in home-manager plugin integrations
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    historySubstringSearch = {
      enable = true;
      # Arrow keys search history by typed prefix
      searchUpKey = ["^[[A" "^P"];
      searchDownKey = ["^[[B" "^N"];
    };

    shellAliases = {
      ll = "ls -lah";
      g = "git";
      cat = "bat";
      find = "fd";
      grep = "rg";
      cd = "z"; # zoxide — smarter directory jumping

      # Nix Aliases
      rebuild = "sudo darwin-rebuild switch --flake ~/.config/nix#$(scutil --get LocalHostName)";
      update = "nix flake update ~/.config/nix && rebuild";
    };

    # Anything that doesn't have a dedicated home-manager option
    initContent = ''
      # Completions
      autoload -Uz compinit && compinit

      # Prompt: simple built-in until you add starship/p10k
      autoload -Uz vcs_info
      precmd() { vcs_info }
      zstyle ':vcs_info:git:*' formats ' (%b)'
      setopt PROMPT_SUBST
      PROMPT='%F{cyan}%~%f%F{yellow}''${vcs_info_msg_0_}%f %# '
    '';
  };

  # ── fzf ──────────────────────────────────────────────────────────────────────
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # ── zoxide ───────────────────────────────────────────────────────────────────
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # ── direnv ───────────────────────────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true; # caches nix develop shells for instant reload
  };

  # ── linearmouse ──────────────────────────────────────────────────────────────

  # Let home-manager manage itself
  programs.home-manager.enable = true;

  # We are leaving this entirely blank for now, but the scaffolding is
  # here whenever you want to start adding dotfiles!
  # Let Home Manager install and manage Zsh
  # This tells Home Manager to manage the XDG directories
  xdg.enable = true;
}
