{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.solarsystem.modules.waybar;
in

{
  options.solarsystem.modules.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Waybar.";
    };

    settings = mkOption {
      type = types.attrs;
      default = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 16;
          "modules-left" = [
            "hyprland/workspaces"
            "battery"
            "custom/playerlabel"
          ];
          "modules-right" = [
            "tray"
            "pulseaudio"
            "clock"
          ];
          clock = {
            format = " {:%H:%M}";
            tooltip = true;
            "tooltip-format" = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            "format-alt" = " {:%d/%m}";
          };
          "hyprland/workspaces" = {
            "active-only" = false;
            "all-outputs" = true;
            "disable-scroll" = false;
            "on-scroll-up" = "hyprctl dispatch workspace -1";
            "on-scroll-down" = "hyprctl dispatch workspace +1";
            format = "{icon}";
            "on-click" = "activate";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "";
              urgent = "";
              # active = "";
              # default = "󰧞";
              "sort-by-number" = true;
            };
          };
          battery = {
            states = {
              good = 95;
              warning = 30;
              critical = 15;
            };
            format = "{icon}  {capacity}%";
            "format-charging" = "{capacity}% ";
            "format-plugged" = "{capacity}% ";
            "format-alt" = "{icon} {time}";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
            ];
          };
          bluetooth = {
            format = "";
            "format-connected" = "󰂱";
            "format-disabled" = "󰂲";
            rotate = 0;
            "format-connected-battery" = "{icon} {num_connections}";
            "format-icons" = [
              "󰥇"
              "󰤾"
              "󰤿"
              "󰥀"
              "󰥁"
              "󰥂"
              "󰥃"
              "󰥄"
              "󰥅"
              "󰥆"
              "󰥈"
            ];
            "tooltip-format" = ''
              {controller_alias}
              {num_connections} connected'';
            "tooltip-format-connected" = ''
              {controller_alias}
              {num_connections} connected

              {device_enumerate}'';
            "tooltip-format-enumerate-connected" = "{device_alias}";
            "tooltip-format-enumerate-connected-battery" = "{device_alias}	{icon} {device_battery_percentage}%";
          };
          tray = {
            "icon-size" = 16;
            spacing = 5;
          };
          backlight = {
            format = "{icon} {percent}%";
            "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
            ];
          };
          pulseaudio = {
            format = "{icon} {volume}%";
            "format-muted" = "󰝟";
            "format-icons" = {
              default = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            "on-click" = "bash ~/.scripts/volume mute";
            "on-scroll-up" = "bash ~/.scripts/volume up";
            "on-scroll-down" = "bash ~/.scripts/volume down";
            "scroll-step" = 5;
            "on-click-right" = "env DISPLAY=$DISPLAY pavucontrol";
          };
          "custom/hyprpicker" = {
            format = "󰈋";
            "on-click" = "hyprpicker -a -f hex";
            "on-click-right" = "hyprpicker -a -f rgb";
          };
        };
      };
      description = "Settings for Waybar mainBar";
    };

    style = mkOption {
      type = types.str;
      default = ''
        * {
          border: none;
          border-radius: 0px;
          font-family: "CaskaydiaCove NFP";
          font-size: 14px;
          min-height: 0;
        }

        window#waybar {
          background: rgba(20, 20, 20, 0.95);
          border-bottom: 1px solid #1f1f1f;
          color: #eaeaea;
        }

        #workspaces {
          background: #1f1f1f;
          margin: 5px;
          padding: 0 5px;
          border-radius: 16px;
        }

        #workspaces button {
          padding: 0 5px;
          border-radius: 16px;
          color: #888888;
        }

        #workspaces button.active {
          color: #eaeaea;
          background-color: transparent;
        }

        #workspaces button:hover {
          background-color: #333333;
          color: #ffffff;
        }

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

        #tray {
          background: #1f1f1f;
          margin: 5px;
          border-radius: 16px;
          padding: 0 5px;
        }

        #clock {
          color: #eaeaea;
          background-color: #1f1f1f;
          border-radius: 0 0 0 24px;
          padding-left: 13px;
          padding-right: 15px;
          margin: 0 0 0 10px;
          font-weight: bold;
        }

        #battery {
          color: #a6e3a1;
        }

        #battery.charging {
          color: #a6e3a1;
        }

        #battery.warning:not(.charging) {
          background-color: #cc6666;
          color: #1a1a1a;
          border-radius: 5px;
        }

        #backlight {
          background-color: #1f1f1f;
          color: #cc6666;
          margin: 5px;
          padding: 0;
        }

        #pulseaudio {
          color: #eaeaea;
          border-radius: 8px;
          margin-left: 0;
        }

        #pulseaudio.muted {
          background: transparent;
          color: #888888;
        }

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

        #window {
          background: #1f1f1f;
          padding-left: 15px;
          padding-right: 15px;
          border-radius: 16px;
          margin: 5px 0;
        }
      '';
      description = "CSS styling for Waybar";
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = cfg.settings;
      style = cfg.style;
    };
  };
}
