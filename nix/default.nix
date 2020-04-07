{ pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  debian-installer-utils = callPackage ./debian-installer-utils.nix { };
  libdebian-installer = callPackage ./libdebian-installer.nix { };
  nixiquity = callPackage ./nixiquity.nix { };
})
