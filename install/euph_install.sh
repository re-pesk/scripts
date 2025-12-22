#!/usr/bin/env -S bash

echo -e "Checking required packages\n"

[ $(apt list build-essential 2> /dev/null | wc -l) > 1 ] || sudo apt install build-essential
[ $(apt list git 2> /dev/null | wc -l) > 1 ] || sudo apt install git

echo -e "\nInstalling Euphoria\n"

INIT_DIR="$(dirname "$0")"

"${INIT_DIR}/euph_install-4.1.sh"
"${INIT_DIR}/euph_install-4.2.sh"
"${INIT_DIR}/euph_install-addon.sh" eudoc creole

unset INIT_DIR
echo -e "Installation is completed!\n"
