{ pkgs, lib }:

with builtins;
with lib;

lib.makeScope pkgs.newScope (self: with self; {
  buildDebianPackage = callPackage ./buildDebianPackage.nix { };
  srcUrl = pname: version:
    "mirror://debian/pool/main/${substring 0 (if hasPrefix "lib" pname then 4 else 1) pname}/${pname}/${pname}_${version}.tar.xz";

  # deb build
  debconf = callPackage ./debconf.nix { };
  debhelper = callPackage ./debhelper.nix { };
  dh-autoreconf = callPackage ./dh-autoreconf.nix { };
  po-debconf = callPackage ./po-debconf.nix { };
  intltool-debian = callPackage ./intltool-debian.nix { };

  # installer
  dh-di = callPackage ./dh-di.nix { };
  debian-installer-utils = callPackage ./debian-installer-utils.nix { };
  libdebian-installer = callPackage ./libdebian-installer.nix { };
})
