{ stdenv
, fetchurl
, libdebian-installer
}:

stdenv.mkDerivation rec {
  pname = "debian-installer-utils";
  version = "1.133";

  src = fetchurl {
    url = "https://deb.debian.org/debian/pool/main/d/debian-installer-utils/debian-installer-utils_${version}.tar.xz";
    sha256 = "160wzjk8dmm7k790ly4z7hz6p43l7qh23yp0c49mhap7rysy3m6m";
  };

  buildInputs = [
    libdebian-installer
  ];

  installPhase = ''
    mkdir -p $out/{bin,lib}
    install anna-install $out/bin
    install apt-install $out/bin
    install block-attr $out/bin
    install debconf-disconnect $out/bin
    install debconf-get $out/bin
    install debconf-set $out/bin
    install fetch-url $out/bin
    install in-target $out/bin
    install log-output $out/bin
    install register-module $out/bin
    install search-path $out/bin
    install start-shell $out/bin
    install update-dev $out/bin
    install user-params $out/bin
    install chroot-setup.sh $out/lib
  '';
}
