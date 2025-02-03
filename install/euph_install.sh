#!/usr/bin/env -S bash

app_name="euphoria"

echo -e "Checking required packages\n"

[ $(apt list build-essential 2> /dev/null | wc -l) > 1 ] || sudo apt install build-essential
[ $(apt list git 2> /dev/null | wc -l) > 1 ] || sudo apt install git

echo -e "\nInstalling ${app_name^}\n"

dir_name="$(dirname "$0")"

"${dir_name}/euph_install-4.1.sh"
"${dir_name}/euph_install-4.2.sh"
"${dir_name}/euph_install-addon.sh" eudoc creole

echo -e "Installation is completed!\n"
