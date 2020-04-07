{ stdenv
, fetchurl
, autoreconfHook
, gettext
, pkgconfig
, perl
, dpkg
, check
, srcUrl
}:

stdenv.mkDerivation rec {
  pname = "libdebian-installer";
  version = "0.120";

  src = fetchurl {
    url = srcUrl pname version;
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
