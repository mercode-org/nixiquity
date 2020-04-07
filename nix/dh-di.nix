{ stdenv
, fetchurl
, perl
, zlib
, bzip2
, xz
, makeWrapper
, coreutils
, perlPackages
, gettext
, dpkg
, autoconf
, automake
, libtool
, debhelper
}:

stdenv.mkDerivation rec {
  dhSub = true;

  pname = "dh-di";
  version = "10";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/dh-di/dh-di_${version}.tar.xz";
    sha256 = "0bc1lj3i7npr8xw1vbcdkp1142nj8wvl08kqjg275qsjs2b51xgk";
  };

  makeFlags = [
    "PERLLIBDIR=$(out)/${perl.libPrefix}/Debian/Debhelper"
    "PREFIX=$(out)"
  ];

  patchPhase = ''
    sed 's|$(DESTDIR)/usr|$(PREFIX)|g' -i Makefile
    patchShebangs .
  '';

  buildInputs = [
    perl
    dpkg
    zlib
    bzip2
    xz
  ];

  nativeBuildInputs = [
    makeWrapper
    perl
    perlPackages.Po4a
    gettext
  ];

  postInstall =
    ''
      for i in $out/bin/*; do
        if head -n 1 $i | grep -q perl; then
          wrapProgram $i --prefix PERL5LIB : $out/${perl.libPrefix}:${debhelper}/${perl.libPrefix}
        fi
      done
    '';

  meta = with stdenv.lib; {
    description = "debhelper add-on to call autoreconf and clean up after the build";
    homepage = "https://tracker.debian.org/pkg/dh-autoreconf";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
