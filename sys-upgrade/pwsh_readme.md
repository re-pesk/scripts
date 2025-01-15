[Atgal](./readme.md)

# PowerShell [&#x2B67;](https://learn.microsoft.com/en-us/powershell/)

## Diegimas

```bash
sudo apt-get update
# Jeigu pakeista nesuinstaliuoti
sudo apt-get install -y wget apt-transport-https software-properties-common
# Surasti sistemos VERSION_ID 
cat /etc/os-release
wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y powershell
pwsh -Version
```

## Paleistis

```bash
pwsh pwsh_sys-upgrade.ps1
```