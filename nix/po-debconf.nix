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
, dh-autoreconf
, buildDebianPackage
}:

buildDebianPackage rec {
  sub = true;
  pname = "po-debconf";
  version = "1.0.21";

  src = fetchurl {
    url = "mirror://debian/pool/main/p/po-debconf/po-debconf_${version}.tar.xz";
    sha256 = "0j5p13qy71wnfnycgzfg34zmlvpykqysr5l3vc5z0qc3wzni6df6";
  };

/*  makeFlags = [
    "PERLLIBDIR=$(out)/${perl.libPrefix}/Debian/Debhelper"
    "PREFIX=$(out)"
  ];

  # we can't "buildDebianPackage", because debhelper is a dependency of that

  patchPhase = ''
    find . -type f -exec sed -i \
      -e s,--prefix=/usr,--prefix=''${out},g \
      {} +

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
      # This breaks the binary name. We're setting the lib path already in buildDebianPackage
      #for i in $out/bin/*; do
      #  if head -n 1 $i | grep -q perl; then
      #    wrapProgram $i --prefix PERL5LIB : $out/${perl.libPrefix}:${dh-autoreconf}/${perl.libPrefix}
      #  fi
      #done

      # mkdir -p $out/etc/dpkg
      # cp -r scripts/t/origins $out/etc/dpkg
    '';*/

  meta = with stdenv.lib; {
    description = "helper programs for debian/rules";
    homepage = "https://tracker.debian.org/pkg/debhelper";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
