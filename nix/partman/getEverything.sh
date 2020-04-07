#!/bin/bash

set -euo pipefail

get_all_repos() {
  (
    curl -s "https://salsa.debian.org/groups/installer-team/-/children.json?filter=partman&page=1" | jq ".[]" &&
    curl -s "https://salsa.debian.org/groups/installer-team/-/children.json?filter=partman&page=2" | jq ".[]"
  ) | jq -s
}

fetch_all_repos() {
  J=$(get_all_repos)

  for repo in $(echo "$J" | jq ".[] | .name" -r | grep "^partman"); do
    ID=$(echo "$J" | jq ".[] | select(.name == \"$repo\")")
    LATEST=$(git ls-remote --tags --sort v:refname https://salsa.debian.org/installer-team/$repo | grep -v "\\^" | sed "s|^.*\t||g" | tail -n 1 | sed "s|refs/tags/||g")
    nix-prefetch-git "https://salsa.debian.org/installer-team/$repo" --rev "$LATEST" | jq ".ver = \"$LATEST\"" > "src/$repo.json"
  done
}

fetch_all_repos
