#!/bin/bash

# Demander à l'utilisateur le nom de son user et de son groupe
read -p "Entrez le nom de l'utilisateur : " user_name
read -p "Entrez le nom du groupe : " group_name

# Demander à l'utilisateur le nom du fichier de lancement
read -p "Entrez le chemin absolu du fichier de lancement (ex: /chemin/vers/script.sh) : " launch_file

# Créer le fichier de service
service_file="/etc/systemd/system/tig_pool.service"

echo "Création du fichier de service à $service_file ..."

sudo bash -c "cat > $service_file" <<EOL
[Unit]
Description=Service pour exécuter \$launch_file
After=network.target

[Service]
ExecStart=$launch_file
WorkingDirectory=$(dirname $launch_file)
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
echo "Redémarrage du service tig_pool.service..."
sudo systemctl restart tig_pool.service

# Suivre les logs en temps réel
echo "Affichage des journaux du service en temps réel..."
sudo journalctl -u tig_pool.service -f
