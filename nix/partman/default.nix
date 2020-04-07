{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  buildDebianPackage = callPackage ../buildDebianPackage.nix { };
  util = callPackage ./util.nix { };

  partman-base = util.mkPartman {
    name = "partman-base";
  };
})
