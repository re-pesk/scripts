#! /usr/bin/env -S bash

# Pagal https://askubuntu.com/questions/1532966/vivaldi-wont-load-on-xubuntu-noble-24-04

wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub \
| sudo gpg --dearmor -o /etc/apt/keyrings/vivaldi-browser.gpg

echo "deb [signed-by=/etc/apt/keyrings/vivaldi-browser.gpg arch=amd64] https://repo.vivaldi.com/archive/deb/ stable main" \
| sudo tee /etc/apt/sources.list.d/vivaldi-browser.list

sudo apt update

sudo apt install vivaldi-stable
