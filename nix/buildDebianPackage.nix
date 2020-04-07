{ stdenv
, dpkg
, fakeroot
, debhelper
, lib
, dh-autoreconf
, perl
, autoconf
, automake
, gettext
, libtool
, pkgconfig
, perlPackages
, strip-nondeterminism
, po-debconf
}:

/*
  I think I've clearly lost my mind...
  Am I even reading this right?

  *dpkg on nix*
*/

let
  dh-strip-nondeterminism = strip-nondeterminism.overrideAttrs(attr: attr // { perlPostHook = "true"; });
in

with lib;

{ nativeBuildInputs ? []
, buildFlags ? []
, sub ? false
, ...
} @ args:
stdenv.mkDerivation (args // {

  nativeBuildInputs = [
    dpkg
    debhelper
    dh-autoreconf
    fakeroot
    dh-strip-nondeterminism

    autoconf
    automake
    gettext
    libtool
    pkgconfig

    perl
    perlPackages.Po4a
    gettext

  ] ++ (optionals (!sub) [ po-debconf ]) ++ nativeBuildInputs;

  buildPhase = ''
    patchShebangs debian # mainly because of debian/rules, though there are all sorts of things in there
    find debian -type f -exec sed -i \
      -e s,/usr/share/dpkg,${dpkg}/share/dpkg,g \
      {} +

    export PERL5LIB="$PERL5LIB:${lib.makeSearchPath perl.libPrefix ([ debhelper dh-autoreconf dh-strip-nondeterminism ] ++ nativeBuildInputs)}"

    dpkg-buildpackage -d --no-sign ${lib.escapeShellArgs buildFlags}
  '';

})
