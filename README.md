# Homelab Dev Local Ubuntu 24.04

Stack homelab locale pour Ubuntu 24.04, installée avec Ansible et Docker.

Le projet installe Docker, prépare un utilisateur Linux, puis démarre ces services :

- Homepage
- Traefik
- Portainer
- Prometheus
- Grafana
- Jenkins

## Accès aux services

- Homepage : `http://lab.localhost`
- Traefik : `http://traefik.localhost`
- Portainer : `http://portainer.localhost`
- Prometheus : `http://prometheus.localhost`
- Grafana : `http://grafana.localhost`
- Jenkins : `http://jenkins.localhost`

## Prérequis

- Ubuntu 24.04
- accès `sudo`
- Python 3
- Ansible

Installation possible d'Ansible :

```bash
sudo apt update
sudo apt install -y ansible python3-pip
```

## Installation

### Option WSL avec distro dédiée

1. Créer une distro dédiée `Ubuntu-24.04-dev` limitée à `30GB` :

```powershell
wsl --install Ubuntu-24.04 --name Ubuntu-24.04-dev --location D:\WSL\Ubuntu-24.04-dev --no-launch
wsl --manage Ubuntu-24.04-dev --resize 30GB
wsl -d Ubuntu-24.04-dev
```

2. Dans cette distro, installer les prérequis :

```bash
sudo apt update
sudo apt install -y ansible python3-pip git
```

3. Installer ensuite la stack :

```bash
git clone https://github.com/your-username/homelab-24.04.git
cd homelab-24.04/ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i inventory/hosts all.playbook.yml -e "username=myuser"
newgrp docker
docker ps
```

Résultat attendu : `docker ps` doit afficher les conteneurs démarrés.

Remplace `myuser` par ton utilisateur Linux.

## Jenkins

Identifiants initiaux après une installation propre :

- utilisateur : `admin`
- mot de passe : la valeur de `jenkins_admin_password`

Le dépôt utilise désormais un placeholder (`change-me-before-first-run`). Remplace cette valeur avant le premier démarrage.

Si Jenkins refuse ces identifiants, il réutilise probablement un volume déjà existant.

## Dépannage rapide

- Sous WSL avec un dépôt dans `/mnt/d/...`, utilise toujours `-i inventory/hosts` dans les commandes Ansible.
- Si `docker ps` renvoie `permission denied`, ouvre une nouvelle session ou exécute `newgrp docker`.
- Si `*.localhost` ne répond pas, teste d'abord avec `curl -H "Host: traefik.localhost" http://127.0.0.1/`.
- Si le navigateur ne résout pas `*.localhost`, ajoute les entrées nécessaires dans le fichier hosts de l'OS hôte.

## Notes

- Le réseau Docker partagé s'appelle `proxy`.
- Traefik découvre les services dynamiquement via les labels Docker.
- Pour ajouter un nouveau service derrière Traefik, il doit rejoindre le réseau `proxy` et définir ses labels `traefik.*`.
