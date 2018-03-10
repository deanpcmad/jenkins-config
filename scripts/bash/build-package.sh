#!/bin/bash -ex

sudo pacman -Syu --noconfirm --noprogressbar

makepkg --nosign --syncdeps --rmdeps --noconfirm

cp *.pkg.tar.xz ~/packages/new

cd ~/packages/new

for PKG in *.pkg.tar.xz
do
  if [[ -e "../${PKG}" ]]; then
    mv "${PKG}" "../${PKG}"
    # Forcefully update and override existing version
    ( cd .. && repo-add -R deanpcmad.db.tar.gz "${PKG}" )
  else
    mv "${PKG}" "../${PKG}"
    # Upgrade current version
    ( cd .. && repo-add -n -R deanpcmad.db.tar.gz "${PKG}" )
  fi
done

rsync -aux --progress ~/packages/ www@web.deanpcmad.com:~/sites/arch.deanpcmad.com/private/
