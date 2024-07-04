#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix-update curl git

package="sleepy-launcher"

# get curent version
getCurrentVersion(){
  pushd "$(git rev-parse --show-toplevel)" > /dev/null
  currentVersion="$(nix eval --impure --raw --expr "
    let
      flake = builtins.getFlake \"path:$(pwd)/.\";
    in flake.packages.x86_64-linux.$package.unwrapped.version
  ")"
  popd > /dev/null
  echo "$currentVersion"
}

getLatestVersion(){
  latestVersion="$(git -c versionsort.suffix=- ls-remote --exit-code --refs --tags --sort=v:refname "https://github.com/an-anime-team/$package" \
    | awk '{print $2}' \
    | sed 's|refs/tags/||g' \
    | tail -n 1)"
  echo "$latestVersion"
}

current="$(getCurrentVersion)"
latest="$(getLatestVersion)"

if [[ "$1" == "--commit-message" ]]; then
  echo "$package: $current -> $latest"
  exit 0
fi

if [ "$current" = "$latest" ]; then
  echo "Up to date"
  exit 0
fi

# Update Cargo.lock
curl "https://raw.githubusercontent.com/an-anime-team/$package/$latest/Cargo.lock" > Cargo.lock

pushd "$(git rev-parse --show-toplevel)" > /dev/null
  nix-update "$package-unwrapped" --flake --version="$latest"
popd > /dev/null
