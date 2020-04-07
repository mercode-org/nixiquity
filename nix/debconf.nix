{ fetchgit
, stdenv
, perl
, gettext
, perlPackages
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "debconf";
  version = "1.5.73";

  src = fetchgit {
    url = "https://salsa.debian.org/pkg-debconf/debconf.git";
    rev = "debian/${version}";
    sha256 = "1i86r4zpqrysd493n95g0m87z5l8ppr6gyj9214glcrdi37203bm";
  };

  nativeBuildInputs = [
    gettext
    perlPackages.Po4a
    makeWrapper
  ];

  buildInputs = [
    perl
  ];

  patchPhase = ''
    patchShebangs doc/graph.pl
  '';

  preFixupPhases = ["moveFiles" "patchBins"];

  moveFiles = ''
    mv $out/usr/* $out
  '';

  patchBins = ''
    sed "s|perl|perl -I$out|g" -i $out/bin/*
  '';

  installFlags = ["prefix=$(out)"];
}
