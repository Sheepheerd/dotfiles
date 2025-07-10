{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 16;
        modules-left = [ "hyprland/workspaces" "battery" "custom/playerlabel" ];
        modules-right = [ "tray" "pulseaudio" "clock" ];

        "clock" = {
          format = " {:%H:%M}";
          tooltip = true;
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = " {:%d/%m}";
        };

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = true;
          disable-scroll = false;
          on-scroll-up = "hyprctl dispatch workspace -1";
          on-scroll-down = "hyprctl dispatch workspace +1";
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            urgent = "";
            active = "";
            default = "󰧞";
            sort-by-number = true;
          };
        };

        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{icon} {time}";
          format-icons = [ "" "" "" "" "" ];
        };

        "bluetooth" = {
          format = "";
          format-connected = "󰂱";
          format-disabled = "󰂲";
          rotate = 0;
          format-connected-battery = "{icon} {num_connections}";
          format-icons = [ "󰥇" "󰤾" "󰤿" "󰥀" "󰥁" "󰥂" "󰥃" "󰥄" "󰥅" "󰥆" "󰥈" ];
          tooltip-format = ''
            {controller_alias}
            {num_connections} connected'';
          tooltip-format-connected = ''
            {controller_alias}
            {num_connections} connected

            {device_enumerate}'';
          tooltip-format-enumerate-connected = "{device_alias}";
          tooltip-format-enumerate-connected-battery =
            "{device_alias}	{icon} {device_battery_percentage}%";
        };

        "tray" = {
          icon-size = 16;
          spacing = 5;
        };

        "backlight" = {
          format = "{icon} {percent}%";
          "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-muted = "󰝟";
          format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
          on-click = "bash ~/.scripts/volume mute";
          on-scroll-up = "bash ~/.scripts/volume up";
          on-scroll-down = "bash ~/.scripts/volume down";
          scroll-step = 5;
          on-click-right = "pavucontrol";
        };

        "custom/hyprpicker" = {
          format = "󰈋";
          on-click = "hyprpicker -a -f hex";
          on-click-right = "hyprpicker -a -f rgb";
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0px;
        font-family: "CaskaydiaCove NFP";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(20, 20, 20, 0.95); /* very dark background */
        border-bottom: 1px solid #1f1f1f;
        color: #eaeaea; /* soft white text */
      }

      /* Workspaces */
      #workspaces {
        background: #1f1f1f;
        margin: 5px;
        padding: 0 5px;
        border-radius: 16px;
      }

      #workspaces button {
        padding: 0 5px;
        border-radius: 16px;
        color: #888888; /* soft gray for inactive */
      }

      #workspaces button.active {
        color: #eaeaea;
        background-color: transparent;
      }

      #workspaces button:hover {
        background-color: #333333;
        color: #ffffff;
      }

      /* Generic Module Styling */
      #custom-date,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #custom-randwall,
      #custom-launcher {
        background: transparent;
        padding: 5px;
        margin: 5px;
        border-radius: 8px;
        color: #eaeaea;
      }

      /* Date & Power Specific Styles */
      #custom-date {
        color: #b0b0b0;
      }

      #custom-power {
        color: #1a1a1a;
        background-color: #cc6666;
        border-radius: 5px;
        margin: 5px 10px 5px 0;
        padding: 5px 10px;
      }

      /* Tray Styling */
      #tray {
        background: #1f1f1f;
        margin: 5px;
        border-radius: 16px;
        padding: 0 5px;
      }

      /* Clock Styling */
      #clock {
        color: #eaeaea;
        background-color: #1f1f1f;
        border-radius: 0 0 0 24px;
        padding-left: 13px;
        padding-right: 15px;
        margin: 0 0 0 10px;
        font-weight: bold;
      }

      /* Battery States */
      #battery {
        color: #a6e3a1; /* soft green for normal battery */
      }

      #battery.charging {
        color: #a6e3a1;
      }

      #battery.warning:not(.charging) {
        background-color: #cc6666;
        color: #1a1a1a;
        border-radius: 5px;
      }

      /* Backlight */
      #backlight {
        background-color: #1f1f1f;
        color: #cc6666;
        margin: 5px;
        padding: 0;
      }

      /* Pulseaudio (Volume) */
      #pulseaudio {
        color: #eaeaea;
        border-radius: 8px;
        margin-left: 0;
      }

      #pulseaudio.muted {
        background: transparent;
        color: #888888;
      }

      /* Custom Launcher */
      #custom-launcher {
        color: #eaeaea;
        background-color: #1f1f1f;
        border-radius: 0 24px 0 0;
        margin: 0;
        padding: 0 20px 0 13px;
        font-size: 20px;
      }

      #custom-launcher button:hover {
        background-color: #333333;
        color: #ffffff;
      }

      /* Playerctl & Playerlabel */
      #custom-playerctl {
        background: #1f1f1f;
        padding-left: 15px;
        padding-right: 14px;
        border-radius: 16px;
        margin: 5px 0;
      }

      #custom-playerlabel {
        background: transparent;
        padding-left: 10px;
        padding-right: 15px;
        border-radius: 16px;
        margin: 5px 0;
      }

      /* Window Module */
      #window {
        background: #1f1f1f;
        padding-left: 15px;
        padding-right: 15px;
        border-radius: 16px;
        margin: 5px 0;
      }





    '';

  };
  home.file.".scripts/volume" = {
    text =

      ''
            #!/bin/sh
        down() {
          pamixer -d 5
          volume=$(pamixer --get-volume)
          [ $volume -gt 0 ] && volume=$(expr $volume)
          dunstify -a "VOLUME" "Decreasing to $volume%" -h int:value:"$volume" -i audio-volume-low-symbolic -r 2593 -u normal
          canberra-gtk-play -i dialog-error -d "error"
        }

        up() {
          pamixer -i 5
          volume=$(pamixer --get-volume)
          [ $volume -lt 100 ] && volume=$(expr $volume)
          dunstify -a "VOLUME" "Increasing to $volume%" -h int:value:"$volume" -i audio-volume-high-symbolic -r 2593 -u normal
          canberra-gtk-play -i dialog-error -d "error"
        }

        mute() {
          muted="$(pamixer --get-mute)"
          if $muted; then
            pamixer -u
            dunstify -a "VOLUME" "UNMUTED" -i audio-volume-high-symbolic -r 2593 -u normal
          else
            pamixer -m
            dunstify -a "VOLUME" "MUTED" -i audio-volume-muted-symbolic -r 2593 -u normal
          fi
        }

        case "$1" in
        up) up ;;
        down) down ;;
        mute) mute ;;
        esac

      '';
    executable = true;
  };
}
