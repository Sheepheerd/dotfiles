let
  user1 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICpZpyRBRFJjaGXkwiBRZPUt84UgRC3wtvLGLECfB2Tm sheep@solis";
  system1 =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeEzgqmMsRUCdUz40diLky/tcYmFSh4u6aofEhOPvZ1tMMeG0OORhHTIRJIssFLveeTBwlpT8ladfrTiEWkiayNV2kXwkgXz5Sn9GGYVZxQLONl/9zKsnKf62RgnjmDaKhTZGsMbOX7bpMV9NCZ4JOjiiMYzu3+nNaA2y6JWER8Nkseu8rYzXuBcxe6unDd99V6fSLb9LZT9y3kAyiaUvHDtOH8kB6qfNUhExQyr/FtSFm7x9s5rd5jdX898l4PXieS1V8Wcmd5TSGSNvyWkhN5LvhjN9cjkDmMnZWMLEdIPmqhyMSuLvyj50F2ZQdyAB/+2gEiMp4N/lS4q3UE42GJ3bJsDYLTo5plr14rx8Q0N8KPN07wcjLm4pw5oiiV3dICbLeCWaJb58kOjEEAazNJoW+ulx5ETRYLcL4aZc7jg9gzYgapyvt5ZtjGYPH2BYvxFuNEMnC8OmwSFVKQ5rGisP1SSy6jNRO/GnpX94kS8Qh/fKBnejuGlYgQTeYsqWlD5X2BqU6rdiJAOf5G4ISe6hi12q6TsMx32xWrnvShuxaCR7s8+PmWzTsnDPDm96LNcpnuQpDSLT6uFThX49l/f/6csWcN/RPie2+22it+XiMM5C9O1YNuaIhiY+J67B8fZ2pntJI1F7TIsnMmapNRnfua3W7nB9jlMlBFH6EsQ== root@solis";
  systems = [ system1 ];
in {
  "immich.age".publicKeys = [ system1 user1 ];
  "firefly.core.age".publicKeys = [ system1 user1 ];
  "firefly.db.age".publicKeys = [ system1 user1 ];
  # "homepage.age".publicKeys = [ system1 user1 ];
}
