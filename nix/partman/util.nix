{ callPackage
, buildDebianPackage
, fetchgit
, dh-di
}:

{
  mkPartman = {
    name
    , ...
  } @ args:
  let
    src = builtins.fromJSON (builtins.readFile "${./src}/${name}.json");
  in
    buildDebianPackage {
      pname = name;
      version = src.ver;

      nativeBuildInputs = [
        dh-di
      ];

      src = fetchgit {
        url = src.url;
        rev = src.ver;
        sha256 = src.sha256;
      };
    };
}
