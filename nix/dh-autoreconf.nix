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

# http://deb.debian.org/debian/pool/main/d/debhelper/debhelper_12.10.tar.xz

stdenv.mkDerivation rec {
  dhSub = true;

  pname = "dh-autoreconf";
  version = "19";

  src = fetchurl {
    url = "mirror://debian/pool/main/d/dh-autoreconf/dh-autoreconf_${version}.tar.xz";
    sha256 = "1yqqkqd7n0r147plp8dcm77cymp0rcrpwh1xp5p2lxls7jvzxmyn";
  };

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

  postPatch = ''
    find . -type f -exec sed -i \
      -e s,/usr/share/libtool,${libtool}/share/libtool,g \
      -e s,/usr/share/dpkg,${dpkg}/share/dpkg,g \
      -e s,/usr/share/dh-autoreconf,$out/share/dh-autoreconf,g \
      {} +

    patchShebangs .
  '';

  installPhase = '' # from debian/install
    # Nice: dh depends on dh-autoreconf, so we can't buildDebianPackage this

    pod2man -r "dh-autoreconf v${version}" -c dh-autoreconf --section=1 dh_autoreconf dh_autoreconf.1
    pod2man -r "dh-autoreconf v${version}" -c dh-autoreconf --section=1 dh_autoreconf_clean dh_autoreconf_clean.1
    pod2man -r "dh-autoreconf v${version}" -c dh-autoreconf --section=7 dh-autoreconf.pod dh-autoreconf.7

    install -D dh_autoreconf $out/bin/dh_autoreconf
    install -D dh_autoreconf_clean $out/bin/dh_autoreconf_clean
    install -D autoreconf.pm $out/${perl.libPrefix}/Debian/Debhelper/Sequence/autoreconf.pm
    install -D autoreconf.mk $out/share/cdbs/1/rules/autoreconf.mk
    install -D ltmain-as-needed.diff $out/share/dh-autoreconf
  '';

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
    description = "debhelper add-on to call autoreconf and clean up after the build";
    homepage = "https://tracker.debian.org/pkg/dh-autoreconf";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
