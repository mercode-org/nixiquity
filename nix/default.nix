{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  nixiquity = callPackage ./nixiquity.nix { };
  partman = callPackage ./partman { };
})
