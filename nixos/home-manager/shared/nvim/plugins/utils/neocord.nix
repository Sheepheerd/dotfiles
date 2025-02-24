{
  programs.nixvim = {
    plugins.neocord = {
      enable = true;
      settings = {
        auto_update = true;
        blacklist = [ ];
        # client_id = "1157438221865717891";
        debounce_timeout = 10;
        editing_text = "Editing %s";
        enable_line_number = true;
        logo = "auto";
        logo_tooltip = "NeoVim";
        file_assets = null;
        file_explorer_text = "Browsing...";
        git_commit_text = "Committing changes...";
        global_timer = true;
        line_number_text = "No";
        log_level = null;
        main_image = "language";
        plugin_manager_text = "Managing plugins...";
        reading_text = "Reading...";
        show_time = true;
        terminal_text = "Using Terminal...";
        workspace_text = "Working on Code";
      };
    };
  };
}
