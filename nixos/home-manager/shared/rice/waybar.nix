{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 16;
        modules-left = [ "hyprland/workspaces" "battery" "custom/playerlabel" ];
        modules-center = [ "cpu" "memory" "disk" ];
        modules-right = [
          "tray"
          "custom/hyprpicker"
          "bluetooth"
          "network"
          "pulseaudio"
          "clock"
        ];

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

        "memory" = {
          format = "󰍛 {}%";
          format-alt = "󰍛 {used}/{total} GiB";
          interval = 5;
        };

        "cpu" = {
          format = "󰻠 {usage}%";
          format-alt = "󰻠 {avg_frequency} GHz";
          interval = 5;
        };

        "disk" = {
          format = "󰋊 {}%";
          format-alt = "󰋊 {used}/{total} GiB";
          interval = 5;
          path = "/mnt/Datos";
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

        "network" = {
          format-wifi = "󰤨";
          format-ethernet = "󰈀 {ifname}: Aesthetic";
          format-linked = "󰈀 {ifname} (No IP)";
          format-disconnected = "󰤭";
          format-alt = "󰈀 {ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{essid}";
          on-click-right = "nm-connection-editor";
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
        /*font-family: VictorMono, Iosevka Nerd Font, Noto Sans CJK;*/
        font-family: "CaskaydiaCove NFP";
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.5);
        border-bottom: 1px solid #282828;
        color: #f4d9e1;
      }

      #workspaces {
        background: #282828;
        margin: 5px 5px 5px 5px;
        padding: 0px 5px 0px 5px;
        border-radius: 16px;
        border: solid 0px #f4d9e1;
        font-weight: normal;
        font-style: normal;
      }
      #workspaces button {
        padding: 0px 5px;
        border-radius: 16px;
        color: #928374;
      }

      #workspaces button.active {
        color: #f4d9e1;
        background-color: transparent;
        border-radius: 16px;
      }

      #workspaces button:hover {
        background-color: #e6b9c6;
        color: black;
        border-radius: 16px;
      }

      #custom-date,
      #clock,
      #battery,
      #pulseaudio,
      #network,
      #custom-randwall,
      #custom-launcher {
        background: transparent;
        padding: 5px 5px 5px 5px;
        margin: 5px 5px 5px 5px;
        border-radius: 8px;
        border: solid 0px #f4d9e1;
      }

      #custom-date {
        color: #d3869b;
      }

      #custom-power {
        color: #24283b;
        background-color: #db4b4b;
        border-radius: 5px;
        margin-right: 10px;
        margin-top: 5px;
        margin-bottom: 5px;
        margin-left: 0px;
        padding: 5px 10px;
      }

      #tray {
        background: #282828;
        margin: 5px 5px 5px 5px;
        border-radius: 16px;
        padding: 0px 5px;
        /*border-right: solid 1px #282738;*/
      }

      #clock {
        color: #e6b9c6;
        background-color: #282828;
        border-radius: 0px 0px 0px 24px;
        padding-left: 13px;
        padding-right: 15px;
        margin-right: 0px;
        margin-left: 10px;
        margin-top: 0px;
        margin-bottom: 0px;
        font-weight: bold;
        /*border-left: solid 1px #282738;*/
      }

      #battery {
        color: #9ece6a;
      }

      #battery.charging {
        color: #9ece6a;
      }

      #battery.warning:not(.charging) {
        background-color: #f7768e;
        color: #24283b;
        border-radius: 5px 5px 5px 5px;
      }

      #backlight {
        background-color: #24283b;
        color: #db4b4b;
        border-radius: 0px 0px 0px 0px;
        margin: 5px;
        margin-left: 0px;
        margin-right: 0px;
        padding: 0px 0px;
      }

      #network {
        color: #f4d9e1;
        border-radius: 8px;
        margin-right: 5px;
      }

      #pulseaudio {
        color: #f4d9e1;
        border-radius: 8px;
        margin-left: 0px;
      }

      #pulseaudio.muted {
        background: transparent;
        color: #928374;
        border-radius: 8px;
        margin-left: 0px;
      }

      #custom-randwall {
        color: #f4d9e1;
        border-radius: 8px;
        margin-right: 0px;
      }

      #custom-launcher {
        color: #e5809e;
        background-color: #282828;
        border-radius: 0px 24px 0px 0px;
        margin: 0px 0px 0px 0px;
        padding: 0 20px 0 13px;
        /*border-right: solid 1px #282738;*/
        font-size: 20px;
      }

      #custom-launcher button:hover {
        background-color: #fb4934;
        color: transparent;
        border-radius: 8px;
        margin-right: -5px;
        margin-left: 10px;
      }

      #custom-playerctl {
        background: #282828;
        padding-left: 15px;
        padding-right: 14px;
        border-radius: 16px;
        /*border-left: solid 1px #282738;*/
        /*border-right: solid 1px #282738;*/
        margin-top: 5px;
        margin-bottom: 5px;
        margin-left: 0px;
        font-weight: normal;
        font-style: normal;
        font-size: 16px;
      }

      #custom-playerlabel {
        background: transparent;
        padding-left: 10px;
        padding-right: 15px;
        border-radius: 16px;
        /*border-left: solid 1px #282738;*/
        /*border-right: solid 1px #282738;*/
        margin-top: 5px;
        margin-bottom: 5px;
        font-weight: normal;
        font-style: normal;
      }

      #window {
        background: #282828;
        padding-left: 15px;
        padding-right: 15px;
        border-radius: 16px;
        /*border-left: solid 1px #282738;*/
        /*border-right: solid 1px #282738;*/
        margin-top: 5px;
        margin-bottom: 5px;
        font-weight: normal;
        font-style: normal;
      }

      #custom-wf-recorder {
        padding: 0 20px;
        color: #e5809e;
        background-color: #1e1e2e;
      }

      #cpu {
        background-color: #282828;
        /*color: #FABD2D;*/
        border-radius: 16px;
        margin: 5px;
        margin-left: 5px;
        margin-right: 5px;
        padding: 0px 10px 0px 10px;
        font-weight: bold;
      }

      #memory {
        background-color: #282828;
        /*color: #83A598;*/
        border-radius: 16px;
        margin: 5px;
        margin-left: 5px;
        margin-right: 5px;
        padding: 0px 10px 0px 10px;
        font-weight: bold;
      }

      #disk {
        background-color: #282828;
        /*color: #8EC07C;*/
        border-radius: 16px;
        margin: 5px;
        margin-left: 5px;
        margin-right: 5px;
        padding: 0px 10px 0px 10px;
        font-weight: bold;
      }

      #custom-hyprpicker {
        background-color: #282828;
        /*color: #8EC07C;*/
        border-radius: 16px;
        margin: 5px;
        margin-left: 5px;
        margin-right: 5px;
        padding: 0px 11px 0px 9px;
        font-weight: bold;
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
