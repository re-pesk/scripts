#!/usr/bin/env -S ysh

install="y"
[ -d "${HOME}/.opt/zig" ] && [ -e "${HOME}/.opt/zig/zig" ] && zig version > /dev/null 2>&1 &&\
  read -p "Found working Zig installation. Do you want overwrite it? 'y' or exit [Enter]: " install
[ "$install" == "y" ] || exit 0
unset install

VERSION="$(
  curl -Lso - https://ziglang.org/download/index.json |\
    jq -r 'keys - ["master"] | sort_by(split(".") | map(tonumber)) | last'
)"

[[ "$(zig version)" == "${VERSION}" ]] && echo "Zig v${VERSION} is already installed!" && exit 0

[ -d "${HOME}/.opt/zig" ] && rm -r "${HOME}/.opt/zig"

curl -sSLo- "https://ziglang.org/download/${VERSION}/zig-x86_64-linux-${VERSION}.tar.xz" \
| tar --transform 'flags=r;s/^zig[^\/]+/zig/x' --show-transformed-names -xJC "${HOME}/.opt"
unset VERSION

[ ! -d "${HOME}/.opt/zig" ] && echo "Directory ${HOME}/.opt/zig is not created!" && exit 1

ln -fs "${HOME}/.opt/zig/zig" "${HOME}/.local/bin/zig"

[ ! -e "${HOME}/.local/bin/zig" ] && echo "The symlink is not created or is broken." && exit 1

echo

zig version > /dev/null 2>&1
[ $? -ne 0 ] && echo "Error! Zig compiler is not working as expected!" && exit 1

printf "zig version => %s\n" $(zig version)
echo "Zig compiler is succesfully installed"
