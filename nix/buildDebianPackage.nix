{ stdenv
, dpkg
, fakeroot
}:

{ nativeBuildInputs ? []
, ...
} @ args:
stdenv.mkDerivation (args // {

  nativeBuildInputs = [
    dpkg
    fakeroot
  ] ++ nativeBuildInputs;

  buildPhase = ''
    patchShebangs debian/rules
    dpkg-buildpackage -d
  '';

})
