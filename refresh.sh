#!/bin/sh
set -e

for package in * ;do
  if [ ! -d "$package" ]; then
    continue
  fi
  echo "Refreshing $package"
  rm -fr "$package"
  (
    git clone --depth 1 "https://gitlab.archlinux.org/archlinux/packaging/packages/$package.git"
    rm -fr "$package/.git"
    sed -i 's|arch=('x86_64')|arch=('x86_64' 'aarch64')|g' "$package/PKGBUILD"
    cd "$package"
    makepkg --printsrcinfo > .SRCINFO
  ) &
done
wait