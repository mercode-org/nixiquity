{ stdenv
, dpkg
, fakeroot
, debhelper
, lib
, dh-autoreconf
}:

/*
  I think I've clearly lost my mind...
  Am I even reading this right?

  *dpkg on nix*
*/

with lib;

{ nativeBuildInputs ? []
, buildFlags ? []
, dhSub ? false
, ...
} @ args:
stdenv.mkDerivation (args // {

  nativeBuildInputs = [
    dpkg
    debhelper
    fakeroot

  ] ++ (optionals (!dhSub) [ dh-autoreconf ]) ++ nativeBuildInputs;

  buildPhase = ''
    patchShebangs debian # mainly because of debian/rules, though there are all sorts of things in there
    find debian -type f -exec sed -i \
      -e s,/usr/share/dpkg,${dpkg}/share/dpkg,g \
      {} +

    dpkg-buildpackage -d ${lib.escapeShellArgs buildFlags}
  '';

})
