# Nemo įskiepiai

Nemo failų naršyklės įskiepiai

* copy-full-path
  Kopijuoja visą failo kelią nuo šakninio katalogo

* create-appimage-config
  Kuria AppImage konfigūracinį katalogą tame pačiame kataloge, kuriame yra AppImage failas

* create-appimage-launcher
  Kuria bash skirptą AppImage paketui paleisti su --no-sandbox raktu

* create-file-description
  Kuria pasirinkto failo aprašą MD žymėjimo kalba

* make-file-executable
  Suteikia/atima failo vykdymo leidimus

* remove-spaces-from-filename
  Tarpus failo pavadinime pakeičia „_“ simboliu

## Diegimas

Kataloge, kuriame yra šis failas, įvykdyti komandas

```bash
rm -r $HOME/.local/share/nemo/actions
cp -r -t $HOME/.local/share/nemo .local/share/nemo/actions
```

### Klaidų sekimas

```bash
#############################################
#### DEBUGGING:
####
#### Run Nemo in debug mode using with
###  NEMO_DEBUG set to include 'Actions'
####
#### i.e.    $ nemo --quit
####         $ NEMO_DEBUG=Actions nemo --debug
#############################################
```
