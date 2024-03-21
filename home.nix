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
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    pkgs.hello
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
#    pkgs.neovim
   # pkgs.tmux
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
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

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
     EDITOR = "nvim";
  };

  programs.neovim = {
    enable = true;
    extraConfig = ''
      set number relativenumber
      set expandtab
      set tabstop=2
      set shiftwidth=2
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
	  '';
    plugins = with pkgs.tmuxPlugins; [
		  sensible
	    vim-tmux-navigator
      yank
		  {
			  plugin = dracula;
			  extraConfig = ''
				  set -g @dracula-show-battery false
				  set -g @dracula-show-powerline true
				  set -g @dracula-refresh-rate 10
          set -g @dracula-plugins "weather"
          set -g @dracula-show-flags true
          set -g @dracula-show-left-icon session
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
