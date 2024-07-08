#!/bin/bash


# Cloner le dépôt
git clone https://github.com/andrewmcgr/klipper_tmc_autotune.git

# Changer de répertoire pour celui du dépôt cloné
cd klipper_tmc_autotune || { echo "Échec du changement de répertoire"; exit 1; }

# Rendre le script install.sh exécutable
chmod +x install.sh

# Exécuter le script install.sh
./install.sh

# Écrire le contenu dans le fichier de configuration
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

# Ajouter la ligne [include tmc_autotune.cfg] au début de moonraker.conf
if ! grep -Fxq "[include tmc_autotune.cfg]" "/home/pi/printer_data/config/moonraker.conf"; then
    (echo "[include tmc_autotune.cfg]"; cat "/home/pi/printer_data/config/moonraker.conf") > temp.conf && mv temp.conf "/home/pi/printer_data/config/moonraker.conf"
    echo "Ligne '[include tmc_autotune.cfg]' ajoutée au début de /home/pi/printer_data/config/moonraker.conf"
else
    echo "La ligne '[include tmc_autotune.cfg]' est déjà présente dans /home/pi/printer_data/config/moonraker.conf"
fi

