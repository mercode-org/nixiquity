{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  buildDebianPackage = callPackage ../buildDebianPackage.nix { };
  debconf = callPackage ../debconf.nix { };
  debhelper = callPackage ../debhelper.nix { };
  dh-autoreconf = callPackage ../dh-autoreconf.nix { };
  dh-di = callPackage ../dh-di.nix { };

  util = callPackage ./util.nix { };

  partman-base = util.mkPartman {
    name = "partman-base";

    buildInputs = [ pkgs.parted ];
  };

  partman-ufs = util.mkPartman {
    name = "partman-ufs";
  };
})
