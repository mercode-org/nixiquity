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
}:

/*
  I think I've clearly lost my mind...
  Am I even reading this right?

  *dpkg on nix*
*/

with lib;

{ nativeBuildInputs ? []
, buildFlags ? []
, ...
} @ args:
stdenv.mkDerivation (args // {

  nativeBuildInputs = [
    dpkg
    debhelper
    dh-autoreconf
    fakeroot

    autoconf
    automake
    gettext
    libtool
    pkgconfig

  ] ++ nativeBuildInputs;

  buildPhase = ''
    patchShebangs debian # mainly because of debian/rules, though there are all sorts of things in there
    find debian -type f -exec sed -i \
      -e s,/usr/share/dpkg,${dpkg}/share/dpkg,g \
      {} +

    export PERL5LIB="$PERL5LIB:${lib.makeSearchPath perl.libPrefix ([ debhelper dh-autoreconf ] ++ nativeBuildInputs)}"

    dpkg-buildpackage -d ${lib.escapeShellArgs buildFlags}
  '';

})
