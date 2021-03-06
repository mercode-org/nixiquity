{ stdenv
, dpkg
, fakeroot
, debhelper
, lib
, dh-autoreconf
, perl
, autoconf
, automake
, gettext
, libtool
, pkgconfig
, perlPackages
, strip-nondeterminism
, po-debconf
, writeShellScriptBin
}:

/*
  I think I've clearly lost my mind...
  Am I even reading this right?

  *dpkg on nix*

  Ideally this would install things directly into $out
  and integrate with existing things (autoreconfHook for ex)

  That way everything that's already on debian but not on
  nixpkgs could be ported en-mass
*/

let
  outdirs = "$TMPDIR/_dpkg_outfolders";
  dh-strip-nondeterminism = strip-nondeterminism.overrideAttrs(attr: attr // { perlPostHook = "true"; });
  dpkg-deb-stub = writeShellScriptBin "dpkg-deb" ''

# add the folder to the list of folders to copy
for f in "$@"; do
  if [ -d "$f" ] &&  [[ "$f" == "debian/"* ]]; then
    echo "$f" >> ${outdirs}
  fi
done

exec ${dpkg}/bin/dpkg-deb "$@"
'';
  dpkg-genbuildinfo-stub = writeShellScriptBin "dpkg-genbuildinfo" ""; # tries to access the /var/lib/dpkg/status db, also we don't really need it
in

with lib;

{ nativeBuildInputs ? []
, buildFlags ? []
, sub ? false
, ...
} @ args:
stdenv.mkDerivation (args // {

  nativeBuildInputs = [
    dpkg
    debhelper
    dh-autoreconf
    fakeroot
    dh-strip-nondeterminism

    autoconf
    automake
    gettext
    libtool
    pkgconfig

    perl
    perlPackages.Po4a
    gettext

  ] ++ (optionals (!sub) [ po-debconf ]) ++ nativeBuildInputs;

  buildPhase = ''
    # patchShebangs debian # mainly because of debian/rules, though there are all sorts of things in there
    patchShebangs .
    find debian -type f -exec sed -i \
      -e s,/usr/share/dpkg,${dpkg}/share/dpkg,g \
      {} +

    # we need the list of all folders, so we can copy them to src. inhject our hook for that
    # also stub dpkg-genbuildinfo
    export PATH=${dpkg-deb-stub}/bin:${dpkg-genbuildinfo-stub}/bin:$PATH

    export PERL5LIB="$PERL5LIB:${lib.makeSearchPath perl.libPrefix ([ debhelper dh-autoreconf dh-strip-nondeterminism ] ++ nativeBuildInputs)}"

    # -d: ignore dependencies
    # -b: ignore source
    dpkg-buildpackage -d --no-sign -b ${lib.escapeShellArgs buildFlags}
  '';

  installPhase = ''
    mkdir -p "$out"

    for folder in $(cat ${outdirs}); do
      rm -rf "$folder/DEBIAN"
      if stat -t $folder/usr/* >/dev/null 2>&1; then
        cp -vrp "$folder/usr/"* $out
        rm -rf "$folder/usr"
      fi
      if stat -t $folder/* >/dev/null 2>&1; then
        test -e "$folder/"* && cp -vrp "$folder/"* $out
        rm -rf "$folder"
      fi
    done
  '';

})
