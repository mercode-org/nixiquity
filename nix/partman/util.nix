{ callPackage
, buildDebianPackage
, fetchgit
, debian
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
        debian.dh-di
      ];

      src = fetchgit {
        url = src.url;
        rev = src.ver;
        sha256 = src.sha256;
      };
    };
}
