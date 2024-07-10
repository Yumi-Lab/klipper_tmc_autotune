#!/bin/bash

# Définir l'URL du dépôt Git
REPO_URL="https://github.com/andrewmcgr/klipper_tmc_autotune.git"

# Cloner le dépôt
cd /home/pi/
git clone "$REPO_URL"

# Extraire le nom du répertoire à partir de l'URL du dépôt
REPO_DIR=$(basename "$REPO_URL" .git)

# Changer de répertoire pour celui du dépôt cloné
cd "$REPO_DIR" || { echo "Échec du changement de répertoire"; exit 1; }

# Rendre le script install.sh exécutable
chmod +x install.sh

# Exécuter le script install.sh
./install.sh

# Définir le chemin du fichier de configuration
CONFIG_DIR="/home/pi/printer_data/config"
CONFIG_FILE="$CONFIG_DIR/update_tmc_autotune.cfg"

# Créer le répertoire de configuration s'il n'existe pas
mkdir -p "$CONFIG_DIR"

# Écrire le contenu dans le fichier de configuration
cat <<EOL > "$CONFIG_FILE"
[update_manager klipper_tmc_autotune]
type: git_repo
channel: dev
path: ~/klipper_tmc_autotune
origin: https://github.com/andrewmcgr/klipper_tmc_autotune.git
managed_services: klipper
primary_branch: main
install_script: install.sh
EOL

echo "Fichier de configuration créé avec succès à $CONFIG_FILE"

# Définir le chemin du fichier moonraker.conf
MOONRAKER_CONF="$CONFIG_DIR/moonraker.conf"

# Ajouter la ligne [include tmc_autotune.cfg] au début de moonraker.conf
if ! grep -Fxq "[include update_tmc_autotune.cfg]" "$MOONRAKER_CONF"; then
    (echo "[include update_tmc_autotune.cfg]"; cat "$MOONRAKER_CONF") > temp.conf && mv temp.conf "$MOONRAKER_CONF"
    echo "Ligne '[include update_tmc_autotune.cfg]' ajoutée au début de $MOONRAKER_CONF"
else
    echo "La ligne '[include update_tmc_autotune.cfg]' est déjà présente dans $MOONRAKER_CONF"
fi

# Créer répertoire tmc autotune
#mkdir -p /home/pi/klipper_tmc_autotune
