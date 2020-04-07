{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  debian = callPackage ../debian { };
  buildDebianPackage = debian.buildDebianPackage;

  util = callPackage ./util.nix { };

  partman-base = util.mkPartman {
    name = "partman-base";

    buildInputs = [ pkgs.parted ];
  };

  partman-ufs = util.mkPartman {
    name = "partman-ufs";
  };
})
