{ stdenv
, dpkg
, fakeroot
}:

{
  nativeBuildInputs ? []
} @ args:
stdenv.mkDerivation (args // {

  nativeBuildInputs = [
    dpkg
    fakeroot
  ] ++ nativeBuildInputs;

  buildPhase = ''
    dpkg-buildpackage -d
  '';

})
