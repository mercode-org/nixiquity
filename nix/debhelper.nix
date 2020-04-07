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
}:

# http://deb.debian.org/debian/pool/main/d/debhelper/debhelper_12.10.tar.xz

stdenv.mkDerivation rec {
  pname = "debhelper";
  version = "12.10";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/debhelper/debhelper_${version}.tar.xz";
    sha256 = "0sk774jcaqjy2pkafzvcvgx6b2nhx0x6nizrakcch6ha7prndvvl";
  };

  makeFlags = [
    "PERLLIBDIR=$(out)/${perl.libPrefix}/Debian/Debhelper"
    "PREFIX=$(out)"
  ];

  # we can't "buildDebianPackage", because debhelper is a dependency of that

  patchPhase = ''
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

  propagatedBuildInputs = [
    autoconf
    automake
    gettext
    libtool
  ];

  postInstall =
    ''
      for i in $out/bin/*; do
        if head -n 1 $i | grep -q perl; then
          wrapProgram $i --prefix PERL5LIB : $out/${perl.libPrefix}
        fi
      done

      # mkdir -p $out/etc/dpkg
      # cp -r scripts/t/origins $out/etc/dpkg
    '';

  meta = with stdenv.lib; {
    description = "helper programs for debian/rules";
    homepage = "https://tracker.debian.org/pkg/debhelper";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
