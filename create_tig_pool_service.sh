#!/bin/bash

# Demander à l'utilisateur le nom de son utilisateur et de son groupe
read -p "Entrez le nom de l'utilisateur : " user_name
read -p "Entrez le nom du groupe : " group_name

# Demander à l'utilisateur le nom du fichier de lancement
read -p "Entrez le nom du fichier de lancement (ex: pool_tig_launch_774_7950x.sh) : " launch_file

# Créer le fichier de service
service_file="/etc/systemd/system/tig_pool.service"

echo "Création du fichier de service à $service_file ..."

sudo bash -c "cat > $service_file" <<EOL
[Unit]
Description=Service pour exécuter $launch_file
After=network.target

[Service]
ExecStart=/home/$user_name/tig_pool_xnico_v7/$(basename $launch_file)
WorkingDirectory=/home/$user_name/tig_pool_xnico_v7/
Restart=always
User=$user_name
Group=$group_name

[Install]
WantedBy=multi-user.target
EOL

echo "Fichier de service créé avec succès."

# Recharger systemd
echo "Rechargement de systemd..."
sudo systemctl daemon-reload

# Redémarrer le service
echo "Activation du service tig_pool.service au démarrage..."
sudo systemctl enable tig_pool.service

# Redémarrer le service
echo "Redémarrage du service tig_pool.service..."
sudo systemctl restart tig_pool.service

# Suivre les logs en temps réel
echo "Affichage des journaux du service en temps réel..."
sudo journalctl -u tig_pool.service -f
