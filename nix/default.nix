{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  debian = callPackage ./debian { };
  nixiquity = callPackage ./nixiquity.nix { };
  partman = callPackage ./partman { };
})
