{ config, pkgs, kapi-vim, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  home = {
    stateVersion = "24.05";
    packages = with pkgs; [
      kapi-vim.packages.${system}.default
      kapi-vim.packages.${system}.lsp

      direnv
      nix-direnv

      nixpkgs-fmt
      nixd

      docker
      docker-buildx

      cmake
      pkg-config

      # networking tools
      tcpdump
      wireguard-tools
      wireguard-go
      curl

      # IaaS tools
      awscli2
      gh

      # tools stack
      git
      pre-commit
      tmux
      tree

      _1password-gui
      _1password
    ];
  };

  programs = {
    home-manager.enable = true;

    bash = {
      enable = true;
      profileExtra = "exec zsh -l";
    };

    zsh = {
      enable = true;
      autocd = true;
      loginExtra = "export SHELL=$(which zsh)";
      logoutExtra = "export SHELL=";
      syntaxHighlighting.enable = true;
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "sudo" "git" "colored-man-pages" "tmux" ];
        theme = "lukerandall";
      };
    };

    alacritty = {
      enable = true;
    };

    tmux = {
      enable = true;
      shell = "${pkgs.zsh}/bin/zsh";
      terminal = "xterm-256color";
      mouse = true;
      keyMode = "vi";
      newSession = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        resurrect
        { plugin = continuum; extraConfig = "set -g @continuum-restore 'off'"; }
        dracula
      ];
      extraConfig = ''
        set -wg mode-style bg=#c6c8d1,fg=#33374c
        set -g pane-border-status top

        set-option -g prefix C-Space
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"
        bind-key & kill-window
        bind-key x kill-pane

        set -s set-clipboard external
        bind -Tcopy-mode MouseDragEnd1Pane send -X copy-selection-no-clear 'xsel -i'
      '';
    };

    zellij = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  home.file = {
    ".config/alacritty/alacritty.yml".source = ./alacritty.yml;
    ".config/git/config".source = ./git_config;
    ".config/zellij/config.kdl".source = ./zellij.kdl;
    ".config/zellij/layouts/default.kdl".source = ./zellij-default-layout.kdl;
  };
}
