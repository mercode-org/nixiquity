{ stdenv
, fetchurl
, gtk3
, gobject-introspection
, wrapGAppsHook
, python3
}:

python3.pkgs.buildPythonApplication rec {
  name = "nixiquity-${version}";
  version = "0.0.1";

  src = ./.;

  buildInputs = [
    gtk3
    gobject-introspection
    wrapGAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
  ];

  meta = with stdenv.lib; {
    description = "merOS nixOS installer";
    homepage = https://os.mercode.org;
    license = licenses.gpl2;
    maintainers = with maintainers; [ mkg20001 ];
  };
}
