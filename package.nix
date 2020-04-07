{ stdenv
, fetchurl
, gtk3
, gobject-introspection
, wrapGAppsHook
, python3
}:

python3.pkgs.buildPythonApplication rec {
  name = "zim-${version}";
  version = "0.72.1";

  src = ./.;

  buildInputs = [
    gtk3
    gobject-introspection
    wrapGAppsHook
    gnome3.adwaita-icon-theme
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
