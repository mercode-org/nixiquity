{ callPackage
, buildDebianPackage
, fetchgit
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

      src = fetchgit {
        url = src.url;
        rev = src.ver;
        sha256 = src.sha256;
      };
    };
}
