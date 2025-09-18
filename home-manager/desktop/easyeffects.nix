{ config, pkgs, ... }:
let
  system = pkgs.system;
in {
  home.packages = with pkgs; [ easyeffects ];
  systemd.user.services.easyeffects = {
    Unit = {
      Description = "Easyeffects daemon";
      Requires = [ "dbus.service" ];
      PartOf = [ "pipewire.service" ];
    };

    Install.WantedBy = [ "default.target" ];

    Service = {
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
  home.file.".config/easyeffects/output/input.json" = {
    enable = system == "x86_64-linux";
    text = ''
         {
          "input": {
              "bass_enhancer#0": {
                  "amount": 0.0,
                  "blend": 0.0,
                  "bypass": false,
                  "floor": 20.0,
                  "floor-active": false,
                  "harmonics": 8.5,
                  "input-gain": 0.0,
                  "output-gain": 0.0,
                  "scope": 100.0
              },
              "blocklist": [],
              "compressor#0": {
                  "attack": 5.0,
                  "boost-amount": 6.0,
                  "boost-threshold": -72.0,
                  "bypass": false,
                  "dry": -100.0,
                  "hpf-frequency": 10.0,
                  "hpf-mode": "off",
                  "input-gain": 0.0,
                  "knee": -6.0,
                  "lpf-frequency": 20000.0,
                  "lpf-mode": "off",
                  "makeup": 0.0,
                  "mode": "Downward",
                  "output-gain": 0.0,
                  "ratio": 10.0,
                  "release": 5.0,
                  "release-threshold": -100.0,
                  "sidechain": {
                      "lookahead": 0.0,
                      "mode": "RMS",
                      "preamp": 0.0,
                      "reactivity": 10.0,
                      "source": "Middle",
                      "stereo-split-source": "Left/Right",
                      "type": "Feed-forward"
                  },
                  "stereo-split": false,
                  "threshold": -35.0,
                  "wet": 0.0
              },
              "crystalizer#0": {
                  "band0": {
                      "bypass": false,
                      "intensity": 0.0,
                      "mute": false
                  },
                  "band1": {
                      "bypass": false,
                      "intensity": -1.0,
                      "mute": false
                  },
                  "band10": {
                      "bypass": false,
                      "intensity": -10.0,
                      "mute": false
                  },
                  "band11": {
                      "bypass": false,
                      "intensity": -11.0,
                      "mute": false
                  },
                  "band12": {
                      "bypass": false,
                      "intensity": -12.0,
                      "mute": false
                  },
                  "band2": {
                      "bypass": false,
                      "intensity": -2.0,
                      "mute": false
                  },
                  "band3": {
                      "bypass": false,
                      "intensity": -3.0,
                      "mute": false
                  },
                  "band4": {
                      "bypass": false,
                      "intensity": -4.0,
                      "mute": false
                  },
                  "band5": {
                      "bypass": false,
                      "intensity": -5.0,
                      "mute": false
                  },
                  "band6": {
                      "bypass": false,
                      "intensity": -6.0,
                      "mute": false
                  },
                  "band7": {
                      "bypass": false,
                      "intensity": -7.0,
                      "mute": false
                  },
                  "band8": {
                      "bypass": false,
                      "intensity": -8.0,
                      "mute": false
                  },
                  "band9": {
                      "bypass": false,
                      "intensity": -9.0,
                      "mute": false
                  },
                  "bypass": false,
                  "input-gain": 0.0,
                  "output-gain": 0.0
              },
              "equalizer#0": {
                  "balance": 0.0,
                  "bypass": false,
                  "input-gain": 0.0,
                  "left": {
                      "band0": {
                          "frequency": 22.4,
                          "gain": 10.1,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band1": {
                          "frequency": 27.8,
                          "gain": 5.05,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band10": {
                          "frequency": 194.06,
                          "gain": 1.3,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band11": {
                          "frequency": 240.81,
                          "gain": -2.28,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band12": {
                          "frequency": 298.834,
                          "gain": -2.77,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band13": {
                          "frequency": 370.834,
                          "gain": -1.47,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band14": {
                          "frequency": 460.182,
                          "gain": -3.42,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band15": {
                          "frequency": 571.057,
                          "gain": -1.95,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band16": {
                          "frequency": 708.647,
                          "gain": -0.16,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band17": {
                          "frequency": 879.387,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band18": {
                          "frequency": 1091.26,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band19": {
                          "frequency": 1354.19,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band2": {
                          "frequency": 34.51,
                          "gain": 4.07,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band20": {
                          "frequency": 1680.47,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band21": {
                          "frequency": 2085.35,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band22": {
                          "frequency": 2587.79,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band23": {
                          "frequency": 3211.29,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band24": {
                          "frequency": 3985.01,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band25": {
                          "frequency": 4945.15,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band26": {
                          "frequency": 6136.63,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band27": {
                          "frequency": 7615.17,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band28": {
                          "frequency": 9449.96,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band29": {
                          "frequency": 11726.8,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band3": {
                          "frequency": 42.82,
                          "gain": 2.61,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band30": {
                          "frequency": 14552.2,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band31": {
                          "frequency": 18058.4,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band4": {
                          "frequency": 53.14,
                          "gain": 2.61,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band5": {
                          "frequency": 65.95,
                          "gain": 3.42,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band6": {
                          "frequency": 81.83,
                          "gain": 2.44,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band7": {
                          "frequency": 101.55,
                          "gain": 3.1,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band8": {
                          "frequency": 126.0,
                          "gain": 3.26,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band9": {
                          "frequency": 156.38,
                          "gain": 1.14,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      }
                  },
                  "mode": "IIR",
                  "num-bands": 32,
                  "output-gain": 0.0,
                  "pitch-left": 0.0,
                  "pitch-right": 0.0,
                  "right": {
                      "band0": {
                          "frequency": 22.4,
                          "gain": 10.1,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band1": {
                          "frequency": 27.8,
                          "gain": 5.05,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band10": {
                          "frequency": 194.06,
                          "gain": 1.3,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band11": {
                          "frequency": 240.81,
                          "gain": -2.28,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band12": {
                          "frequency": 298.834,
                          "gain": -2.77,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band13": {
                          "frequency": 370.834,
                          "gain": -1.47,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band14": {
                          "frequency": 460.182,
                          "gain": -3.42,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band15": {
                          "frequency": 571.057,
                          "gain": -1.95,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band16": {
                          "frequency": 708.647,
                          "gain": -0.16,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band17": {
                          "frequency": 879.387,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band18": {
                          "frequency": 1091.26,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band19": {
                          "frequency": 1354.19,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band2": {
                          "frequency": 34.51,
                          "gain": 4.07,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band20": {
                          "frequency": 1680.47,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band21": {
                          "frequency": 2085.35,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band22": {
                          "frequency": 2587.79,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band23": {
                          "frequency": 3211.29,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band24": {
                          "frequency": 3985.01,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band25": {
                          "frequency": 4945.15,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band26": {
                          "frequency": 6136.63,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band27": {
                          "frequency": 7615.17,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band28": {
                          "frequency": 9449.96,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band29": {
                          "frequency": 11726.8,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band3": {
                          "frequency": 42.82,
                          "gain": 2.61,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band30": {
                          "frequency": 14552.2,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band31": {
                          "frequency": 18058.4,
                          "gain": 0.0,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band4": {
                          "frequency": 53.14,
                          "gain": 2.61,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band5": {
                          "frequency": 65.95,
                          "gain": 3.42,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band6": {
                          "frequency": 81.83,
                          "gain": 2.44,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band7": {
                          "frequency": 101.55,
                          "gain": 3.1,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band8": {
                          "frequency": 126.0,
                          "gain": 3.26,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      },
                      "band9": {
                          "frequency": 156.38,
                          "gain": 1.14,
                          "mode": "RLC (BT)",
                          "mute": false,
                          "q": 4.36,
                          "slope": "x1",
                          "solo": false,
                          "type": "Bell",
                          "width": 4.0
                      }
                  },
                  "split-channels": false
              },
              "expander#0": {
                  "attack": 20.0,
                  "bypass": true,
                  "dry": -100.0,
                  "hpf-frequency": 10.0,
                  "hpf-mode": "off",
                  "input-gain": 0.0,
                  "knee": -6.0,
                  "lpf-frequency": 20000.0,
                  "lpf-mode": "off",
                  "makeup": 0.0,
                  "mode": "Upward",
                  "output-gain": 0.0,
                  "ratio": 4.0,
                  "release": 100.0,
                  "release-threshold": -100.0,
                  "sidechain": {
                      "lookahead": 0.0,
                      "mode": "RMS",
                      "preamp": 0.0,
                      "reactivity": 10.0,
                      "source": "Middle",
                      "stereo-split-source": "Left/Right",
                      "type": "Internal"
                  },
                  "stereo-split": false,
                  "threshold": -12.0,
                  "wet": 0.0
              },
              "level_meter#0": {
                  "bypass": false
              },
              "plugins_order": [
                  "stereo_tools#0",
                  "crystalizer#0",
                  "level_meter#0",
                  "compressor#0",
                  "equalizer#0",
                  "expander#0",
                  "rnnoise#0",
                  "bass_enhancer#0"
              ],
              "rnnoise#0": {
                  "bypass": false,
                  "enable-vad": false,
                  "input-gain": 0.0,
                  "model-path": "/home/sheep/.config/easyeffects/rnnoise/bd.rnnn",
                  "output-gain": 0.0,
                  "release": 20.0,
                  "vad-thres": 50.0,
                  "wet": 0.0
              },
              "stereo_tools#0": {
                  "balance-in": 0.0,
                  "balance-out": 0.0,
                  "bypass": false,
                  "delay": 0.0,
                  "input-gain": -19.3,
                  "middle-level": 0.0,
                  "middle-panorama": 0.0,
                  "mode": "LR > L+R (Mono Sum L+R)",
                  "mutel": false,
                  "muter": false,
                  "output-gain": -4.2,
                  "phasel": false,
                  "phaser": false,
                  "sc-level": 1.0,
                  "side-balance": 0.0,
                  "side-level": 0.0,
                  "softclip": false,
                  "stereo-base": 0.0,
                  "stereo-phase": 0.0
              }
          }
      }

    '';
  };

  home.file.".config/easyeffects/output/headset.json" = {
    enable = system == "x86_64-linux";
    text = ''
      {
         "output": {
             "bass_enhancer#0": {
                 "amount": -9.299999999999988,
                 "blend": -10.0,
                 "bypass": true,
                 "floor": 120.0,
                 "floor-active": false,
                 "harmonics": 10.0,
                 "input-gain": 0.0,
                 "output-gain": 0.0,
                 "scope": 80.0
             },
             "bass_enhancer#1": {
                 "amount": 2.0000000000000004,
                 "blend": 0.0,
                 "bypass": false,
                 "floor": 20.0,
                 "floor-active": false,
                 "harmonics": 8.5,
                 "input-gain": 0.0,
                 "output-gain": 0.0,
                 "scope": 80.0
             },
             "blocklist": [],
             "crystalizer#0": {
                 "band0": {
                     "bypass": false,
                     "intensity": 0.0,
                     "mute": false
                 },
                 "band1": {
                     "bypass": false,
                     "intensity": -1.0,
                     "mute": false
                 },
                 "band10": {
                     "bypass": false,
                     "intensity": -10.0,
                     "mute": false
                 },
                 "band11": {
                     "bypass": false,
                     "intensity": -11.0,
                     "mute": false
                 },
                 "band12": {
                     "bypass": false,
                     "intensity": -12.0,
                     "mute": false
                 },
                 "band2": {
                     "bypass": false,
                     "intensity": -2.0,
                     "mute": false
                 },
                 "band3": {
                     "bypass": false,
                     "intensity": -3.0,
                     "mute": false
                 },
                 "band4": {
                     "bypass": false,
                     "intensity": -4.0,
                     "mute": false
                 },
                 "band5": {
                     "bypass": false,
                     "intensity": -5.0,
                     "mute": false
                 },
                 "band6": {
                     "bypass": false,
                     "intensity": -6.0,
                     "mute": false
                 },
                 "band7": {
                     "bypass": false,
                     "intensity": -7.0,
                     "mute": false
                 },
                 "band8": {
                     "bypass": false,
                     "intensity": -8.0,
                     "mute": false
                 },
                 "band9": {
                     "bypass": false,
                     "intensity": -9.0,
                     "mute": false
                 },
                 "bypass": false,
                 "input-gain": 0.0,
                 "output-gain": 0.0
             },
             "equalizer#0": {
                 "balance": -6.38378239159465e-16,
                 "bypass": false,
                 "input-gain": 0.0,
                 "left": {
                     "band0": {
                         "frequency": 29.952623149688797,
                         "gain": 12.35,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band1": {
                         "frequency": 59.763340205038524,
                         "gain": 8.24,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372453,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band2": {
                         "frequency": 119.24354052777788,
                         "gain": 10.57,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band3": {
                         "frequency": 237.92214271853953,
                         "gain": 8.08,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band4": {
                         "frequency": 474.71708526294935,
                         "gain": 2.38,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372453,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band5": {
                         "frequency": 947.1851104970312,
                         "gain": 7.77,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band6": {
                         "frequency": 1889.8827562743609,
                         "gain": 2.38,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372449,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band7": {
                         "frequency": 3770.811843303749,
                         "gain": 8.42,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372449,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band8": {
                         "frequency": 7523.758767782307,
                         "gain": 11.06,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372453,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band9": {
                         "frequency": 15011.87233627273,
                         "gain": 11.06,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     }
                 },
                 "mode": "FIR",
                 "num-bands": 10,
                 "output-gain": 0.0,
                 "pitch-left": 0.0,
                 "pitch-right": 0.0,
                 "right": {
                     "band0": {
                         "frequency": 29.952623149688797,
                         "gain": 12.35,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band1": {
                         "frequency": 59.763340205038524,
                         "gain": 8.24,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372453,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band2": {
                         "frequency": 119.24354052777788,
                         "gain": 10.57,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band3": {
                         "frequency": 237.92214271853953,
                         "gain": 8.08,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band4": {
                         "frequency": 474.71708526294935,
                         "gain": 2.38,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372453,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band5": {
                         "frequency": 947.1851104970312,
                         "gain": 7.77,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band6": {
                         "frequency": 1889.8827562743609,
                         "gain": 2.38,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372449,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band7": {
                         "frequency": 3770.811843303749,
                         "gain": 8.42,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372449,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band8": {
                         "frequency": 7523.758767782307,
                         "gain": 11.06,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.5047602375372453,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     },
                     "band9": {
                         "frequency": 15011.87233627273,
                         "gain": 11.06,
                         "mode": "RLC (BT)",
                         "mute": false,
                         "q": 1.504760237537245,
                         "slope": "x1",
                         "solo": false,
                         "type": "Bell"
                     }
                 },
                 "split-channels": false
             },
             "plugins_order": [
                 "equalizer#0",
                 "bass_enhancer#0",
                 "crystalizer#0",
                 "bass_enhancer#1"
             ]
         }
         }

    '';
  };

}
