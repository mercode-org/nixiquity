{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  buildDebianPackage = callPackage ./buildDebianPackage.nix { };
  debconf = callPackage ./debconf.nix { };
  debian-installer-utils = callPackage ./debian-installer-utils.nix { };
  libdebian-installer = callPackage ./libdebian-installer.nix { };
  nixiquity = callPackage ./nixiquity.nix { };
  partman = callPackage ./partman { };
})
