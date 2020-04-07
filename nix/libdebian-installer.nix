{ stdenv
, fetchurl
, autoreconfHook
, gettext
, pkgconfig
, perl
, dpkg
, check
}:

stdenv.mkDerivation rec {
  pname = "libdebian-installer";
  version = "0.120";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/libd/libdebian-installer/libdebian-installer_${version}.tar.xz";
    sha256 = "1d4kfyw40i05fp118m8p657k7zj2xfncwj2vhb20g85wz1728sj2";
  };

  nativeBuildInputs = [
    autoreconfHook
    gettext
    pkgconfig
    perl
    dpkg
    check
  ];
}
