# partman for nixOS

Partman seems like a good tool. It supports most filesystems, etc.

Only catch: It's debian only.

Porting it manually is way too much work. That's why there's `buildDebianPackage` now.

It uses dpkg-buildpackage to build the base tree and later applies the nix magic on it

# Getting the sources

To get everything run `bash getEverything.sh`
