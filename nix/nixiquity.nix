{ stdenv
, fetchurl
, python3
, gtk3
, glib
, gobject-introspection
, wrapGAppsHook
, callPackage
, debian
}:

python3.pkgs.buildPythonApplication rec {
  name = "nixiquity-${version}";
  version = "0.0.1";

  src = ./..;

  buildInputs = [
    gtk3
    glib
    gobject-introspection
    wrapGAppsHook

    debian.libdebian-installer
    debian.debian-installer-utils
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "merOS nixOS installer";
    homepage = https://os.mercode.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
