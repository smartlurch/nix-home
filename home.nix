{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "eddie";
  home.homeDirectory = "/home/eddie";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "FantasqueSansMono" ]; })
    pkgs.ranger
    pkgs.bat
    pkgs.zoxide
    pkgs.htop
    pkgs.eza
    pkgs.dust
    pkgs.dua
    pkgs.fd
    pkgs.bottom
    pkgs.just
    pkgs.glances
    pkgs.alacritty
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/eddie/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
     #EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      #plenary-nvim
      dracula-vim
      #gruvbox-material
      vim-visual-multi
      #mini-nvim
    ];
    extraConfig = ''
      set number relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
      colorscheme dracula
      set smartindent
      set autoindent
      set spell
      set history=1000
      filetype on
      filetype plugin on
      filetype indent on
      syntax on
      set cursorline
      set scrolloff=10
      set hlsearch
      set nowrap
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
		  set -g mouse on
      unbind r
      bind r source-file ~/.tmux.conf

      set -g prefix C-s

      #act like vim
      setw -g mode-keys vi
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R
      set -g status-position top
      # Start windows and panes at 1, not 0
      set -g base-index 1
      setw -g pane-base-index 1
	  '';
    plugins = with pkgs.tmuxPlugins; [
		  #sensible
      #powerline
	    vim-tmux-navigator
      yank
		  {
			  plugin = dracula;
			  extraConfig = ''
				  set -g @dracula-show-battery true
				  set -g @dracula-show-powerline true
          set -g @dracula-plugins "cpu-usage ram-usage git time"
				  set -g @dracula-refresh-rate 10
          set -g @dracula-show-flags true
          set -g @dracula-show-left-icon session
          set -g @dracula-cpu-usage-label "CPU"
          set -g @dracula-ram-usage-label "RAM"
          # available plugins: battery, cpu-usage, git, gpu-usage, ram-usage, tmux-ram-usage, network, network-bandwidth, network-ping, ssh-session, attached-clients, network-vpn, weather, time, mpc, spotify-tui, kubernetes-context, synchronize-panes
          set -g @dracula-show-empty-plugins false
          set -g @dracula-show-location false
          set -g @dracula-fixed-location "Metairie, La"
			  '';
		  }
	    {
          plugin = resurrect;
          extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
          resurrect_dir="$HOME/.tmux/resurrect"
          set -g @resurrect-dir $resurrect_dir
          set -g @resurrect-capture-pane-contents 'on'
          set -g @resurrect-hook-post-save-all "sed 's/--cmd[^ ]* [^ ]* [^ ]*//g' $resurrect_dir/last | sponge $resurrect_dir/last"
          set -g @resurrect-processes '"~nvim"'
          '';
        }
        {
            plugin = continuum;
            extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
            '';
        }
      ];  
    };

  programs.git = {
    enable = true;
    userName = "Eddie LeBlanc";
    userEmail = "eddie.leblanc@gmail.com";
  };

  programs.gitui.enable = true;
  programs.lazygit.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
