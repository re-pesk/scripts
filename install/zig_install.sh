#!/usr/bin/env bash

install="y"

[ -d ${HOME}/.local/zig ] && [ -e "${HOME}/.local/bin/zig" ] && zig version > /dev/null 2>&1  && 
read -e -p "Found working Zig installation. Do you want overwrite it? 'y' or exit [Enter]: " install

[ "$install" = "y" ] || exit 0

url="$(curl -Ls -o /dev/null -w %{url_effective} https://github.com/ziglang/zig/releases/latest)"
version="$(basename -- $url)"

[[ "$(zig version)" == "$version" ]] && echo "Version ${version} of Zig is already installed!" && exit 0

[ -d ${HOME}/.local/zig ] && rm -r ${HOME}/.local/zig

curl -sSLo- https://ziglang.org/download/${version}/zig-linux-x86_64-${version}.tar.xz \
| tar --transform 'flags=r;s/^zig[^\/]+/zig/x' --show-transformed-names -xJC "${HOME}/.local"

[ ! -d ${HOME}/.local/zig ] && echo "Directory ${HOME}/.local/zig is not created!" && exit 1

ln -fs ${HOME}/.local/zig/zig ${HOME}/.local/bin/zig

[ ! -e "${HOME}/.local/bin/zig" ] && echo "The symlink is not created or is broken." && exit 1

echo

zig version > /dev/null 2>&1
[ $? -ne 0 ] && echo "Error! Zig compiler is not working as expected!" && exit 1

printf "zig version\n=> %s\n" $(zig version)
echo "Zig compiler is succesfully installed"
