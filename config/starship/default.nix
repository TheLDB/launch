{ pkgs, ... }: {
  programs.starship = {
    enable = true;

    settings = {
      username = {
        style_user = "fg:196 bold";
        style_root = "fg:196 bold";
        format = "[$user](fg:196) [@](fg:196) ";
        disabled = false;
        show_always = true;
      };

      directory = {
        truncate_to_repo = false;
        format = "[$path](fg:196)[$read_only]($read_only_style) ";
        read_only = " 🔒";
      };

      character = { success_symbol = "[=>](bold fg:034)"; };

      git_status = {
        conflicted = "🏳️";
        ahead = "🏎️💨";
        behind = "😰";
        diverged = "😵";
        up_to_date = "[✓](green)";
        untracked = "🤷‍♂️";
        stashed = "📦";
        modified = "📝";
        staged = "[++($count)](green)";
        renamed = "👅";
        deleted = "🗑️";
      };

      aws = {
        symbol = "☁︎ ";
        style = "fg:034";
      };
    };
  };
}