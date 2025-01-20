[Atgal](./readme.md)

# Io [&#x2B67;](https://iolanguage.org/)

## Diegimas

```bash
git clone --recursive https://github.com/IoLanguage/io.git
cd io/           # To get into the cloned folder
mkdir build      # To contain the CMake data
cd build/
cmake ..         # This populates the build folder with a Makefile and all of the related things necessary to begin building
make
sudo make install
io --version
```

## Paleistis

```bash
io io_sys-upgrade.io
```

### Shebang

```shebang
#!/usr/bin/env io
```