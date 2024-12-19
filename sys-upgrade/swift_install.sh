#!/usr/bin/env bash

version="6.0.3"
soft=Swift
installdir="$HOME/.swift"

install="y"

[ -d $installdir ] && swift --version > /dev/null 2>&1  && 
read -e -p "Found working $soft installation. Do you want overwrite it? 'y' or exit [Enter]: " install

[ "$install" = "y" ] || exit 0

[ -d $installdir ] && rm -r $installdir

url="https://download.swift.org/swift-$version-release/ubuntu2404/swift-$version-RELEASE/swift-$version-RELEASE-ubuntu24.04.tar.gz"
curl -sSLo- $url | tar -xz --transform 'flags=r;s/^swift[^\/]+/.swift/x' --show-transformed-names -C "$HOME"

[ ! -d $installdir ] && echo "Directory $installdir is not created!" && exit -1

exportedstring="export PATH=$installdir/usr/bin:\"\${PATH}\""

grep -q "$exportedstring" "$HOME/.bashrc" || echo -e "\n$exportedstring\n" >> $HOME/.bashrc

grep -q "$exportedstring" "$HOME/.bashrc" && source $HOME/.bashrc && $xportedstring

[[ $PATH == *"$HOME/.swift/usr/bin"* ]] || eval $exportedstring

echo 

swift --version > /dev/null 2>&1
[ $? -ne 0 ] && echo "Error! Swift compiler is not working as expected!" && exit -1

echo -e "swift --version"; echo -e "$(swift --version)\n"
echo "Swift compiler is succesfully installed"
