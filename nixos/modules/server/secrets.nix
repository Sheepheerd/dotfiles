{ inputs, ... }: {
  environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

  age.secrets."immich.env" = {
    file = ./env/immich.age;
    owner = "sheep";
    group = "users";
  };
  age.secrets."firefly.core.env" = {
    file = ./env/firefly.core.age;
    owner = "sheep";
    group = "users";
  };
  age.secrets."firefly.db.env" = {
    file = ./env/firefly.db.age;
    owner = "sheep";
    group = "users";
  };
}
