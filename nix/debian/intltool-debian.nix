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
, srcUrl
}:

buildDebianPackage rec {
  sub = true;
  pname = "intltool-debian";
  version = "0.35.0+20060710.5";

  src = fetchurl {
    url = srcUrl pname version;
    sha256 = "03waklyzjnwbs3jpkh069gb6h7i5bzi8xzcrycd25z2cn445pwn4";
  };
  
  meta = with stdenv.lib; {
    description = "helper programs for debian/rules";
    homepage = "https://tracker.debian.org/pkg/debhelper";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
