let
  landing = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsBdQfTn9bmW91d4IfXBfIYtzVjLCCaoI8P93JZu9esqnH5UtW1hFIe6Pn+Z32eX1D4e1W9nh8VBPr7oF5Kx0Sv9yZalnuvTpVrLMgJ4thrjJNvFw4uxF51LJOzSv9Wfz61iLoRZgJ45KyhtbzuKm5G3928JEIoDnoYtxajy59AQo12K1bi7r3L1QsN90CImFTrXtbOSODzTN7B+HbrXvFN3AwhaasTnzhX8iB8mw9mdwOPySanfI5cVCvH3qzhrWxgWPEXAkvHWwXdB87Zl2Vo/9aelPjL4HdOrZpYFcVIP4MFh91KqN+MKoxzKRJSPqvQTaj+r+JuLXO79V5D5KK23e/32rxUVXXMrrqsuOiTOVpq+0k7zIrnZ25FMrdwTufvHKADJdEe0DuWIdhqKuWm6UvlwBO8VRDeYP3a+YD+lNXm4RIhg3+3P2d+e9NDkmmuScO4N4pubU4KtkbLiM66QPjWNkNIsNawfMNKPL2eW98QmsBYu956ioDVwLMrYE= sheep@TheLanding
";

  solis = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICpZpyRBRFJjaGXkwiBRZPUt84UgRC3wtvLGLECfB2Tm sheep@solis";
  system1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCeEzgqmMsRUCdUz40diLky/tcYmFSh4u6aofEhOPvZ1tMMeG0OORhHTIRJIssFLveeTBwlpT8ladfrTiEWkiayNV2kXwkgXz5Sn9GGYVZxQLONl/9zKsnKf62RgnjmDaKhTZGsMbOX7bpMV9NCZ4JOjiiMYzu3+nNaA2y6JWER8Nkseu8rYzXuBcxe6unDd99V6fSLb9LZT9y3kAyiaUvHDtOH8kB6qfNUhExQyr/FtSFm7x9s5rd5jdX898l4PXieS1V8Wcmd5TSGSNvyWkhN5LvhjN9cjkDmMnZWMLEdIPmqhyMSuLvyj50F2ZQdyAB/+2gEiMp4N/lS4q3UE42GJ3bJsDYLTo5plr14rx8Q0N8KPN07wcjLm4pw5oiiV3dICbLeCWaJb58kOjEEAazNJoW+ulx5ETRYLcL4aZc7jg9gzYgapyvt5ZtjGYPH2BYvxFuNEMnC8OmwSFVKQ5rGisP1SSy6jNRO/GnpX94kS8Qh/fKBnejuGlYgQTeYsqWlD5X2BqU6rdiJAOf5G4ISe6hi12q6TsMx32xWrnvShuxaCR7s8+PmWzTsnDPDm96LNcpnuQpDSLT6uFThX49l/f/6csWcN/RPie2+22it+XiMM5C9O1YNuaIhiY+J67B8fZ2pntJI1F7TIsnMmapNRnfua3W7nB9jlMlBFH6EsQ== root@solis";
  systems = [ system1 ];
in
{
  "server/immich.age".publicKeys = [
    system1
    solis
    landing
  ];
  "server/firefly.env.age".publicKeys = [
    system1
    solis
    landing
  ];
  "server/firefly.appkey.age".publicKeys = [
    system1
    solis
    landing
  ];
}
