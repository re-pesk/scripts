[&#x2BA2;](./install_readme.md "Atgal")

# PowerShell [<sup>&#x2B67;</sup>](https://learn.microsoft.com/en-us/powershell/)

* Pasiausias leidimas: 7.5.4
* Išleista: 2025-01-23

## Diegimas

```bash
NAMES=(wget apt-transport-https software-properties-common)
sudo apt-get update
readarray -t NOT_PKGNAMES < <( printf "%s\n" "${NAMES[@]}" | grep -Fvxf <(apt-cache pkgnames | sort -u ))
(( ${#NOT_PKGNAMES[@]} > 0 )) && printf '\n%s: %s\n\n' "Klaidingi paketų pavadinimai" "${NOT_PKGNAMES[*]}" 1>&2
readarray -t NOT_INSTALLED < <( printf "%s\n" "${NAMES[@]}" "${NOT_PKGNAMES[@]}" | sort | uniq -u | 
  grep -Fvxf <( dpkg-query -f '${Package}\n' -W 2> /dev/null | sort -u ))
(( ${#NOT_INSTALLED[@]} > 0 )) && sudo apt-get install -y "${NOT_INSTALLED[@]}"

dpkg -s packages-microsoft-prod &> /dev/null || (
  source /etc/os-release
  wget -q "https://packages.microsoft.com/config/${NAME,,}/${VERSION_ID}/packages-microsoft-prod.deb"
  sudo dpkg -i packages-microsoft-prod.deb
  sudo apt-get update
  sudo apt-get install -f
  rm -f packages-microsoft-prod.deb
)

sudo apt-get update
dpkg -s powershell &> /dev/null || sudo apt-get install -y powershell

pwsh -Version

unset NAMES NOT_PKGNAMES NOT_INSTALLED
```

## Paleistis

```bash
pwsh pwsh_sys-upgrade.ps1
```

### Vykdymo instrukcija (shebang)

```bash
#!/usr/bin/env -S pwsh
```
