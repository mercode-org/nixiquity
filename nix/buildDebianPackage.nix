{ stdenv
, dpkg
, fakeroot
, debhelper
, lib
}:

/*
  I think I've clearly lost my mind...
  Am I even reading this right?

  *dpkg on nix*
*/

{ nativeBuildInputs ? []
, buildFlags ? []
, ...
} @ args:
stdenv.mkDerivation (args // {

  nativeBuildInputs = [
    dpkg
    debhelper
    fakeroot

  ] ++ nativeBuildInputs;

  buildPhase = ''
    patchShebangs debian # mainly because of debian/rules, though there are all sorts of things in there
    dpkg-buildpackage -d ${lib.escapeShellArgs buildFlags}
  '';

})
