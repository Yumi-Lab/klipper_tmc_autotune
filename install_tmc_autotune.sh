#!/bin/bash


echo "Cloner le dépôt"
wget -O - https://raw.githubusercontent.com/andrewmcgr/klipper_tmc_autotune/main/install.sh | bash

echo "Écrire le contenu dans le fichier de configuration"
cat <<EOL > /home/pi/printer_data/config/tmc_autotune.cfg
[update_manager klipper_tmc_autotune]
type: git_repo
channel: dev
path: ~/klipper_tmc_autotune
origin: https://github.com/andrewmcgr/klipper_tmc_autotune.git
managed_services: klipper
primary_branch: main
install_script: install.sh
EOL

echo "Fichier de configuration créé avec succès à /home/pi/printer_data/config/tmc_autotune.cfg"

echo "Ajouter la ligne [include tmc_autotune.cfg] au début de moonraker.conf"
if ! grep -Fxq "[include tmc_autotune.cfg]" "/home/pi/printer_data/config/moonraker.conf"; then
    (echo "[include tmc_autotune.cfg]"; cat "/home/pi/printer_data/config/moonraker.conf") > temp.conf && mv temp.conf "/home/pi/printer_data/config/moonraker.conf"
    echo "Ligne '[include tmc_autotune.cfg]' ajoutée au début de /home/pi/printer_data/config/moonraker.conf"
else
    echo "La ligne '[include tmc_autotune.cfg]' est déjà présente dans /home/pi/printer_data/config/moonraker.conf"
fi
