# Homelab 24.04 - Guide rapide

Guide minimal étape par étape pour démarrer la stack sur Ubuntu 24.04.

## 1) Prérequis

- Hôte Ubuntu 24.04
- Accès `sudo`
- Python 3 et Ansible

Installation d'Ansible (une option possible) :

```bash
sudo apt update
sudo apt install -y ansible python3-pip
```

## 2) Cloner le dépôt et y entrer

```bash
git clone https://github.com/jemmalmohamed/homelab-24.04.git
cd homelab-24.04
```

## 3) Installer les collections Ansible requises

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

## 4) Exécuter les playbooks

Sous WSL, si le dépôt est exécuté depuis `/mnt/d/...` ou un autre disque Windows monté, Ansible peut ignorer `ansible.cfg` parce que le dossier est world-writable. Dans ce cas, utilise toujours `-i inventory/hosts`.

Sur une machine fraîche, suis exactement cette séquence :

```bash
cd ansible
ansible-galaxy collection install -r requirements.yml
ansible-playbook -i inventory/hosts all.playbook.yml -e "username=myuser"
newgrp docker
docker ps
```

Validation : `docker ps` doit afficher les conteneurs démarrés.

Après reconnexion utilisateur, rejouer uniquement :

```bash
cd ansible
newgrp docker
docker ps
```

Les commandes ci-dessous servent uniquement à rejouer une étape précise.

Exécuter depuis la racine du dépôt ou depuis le dossier `ansible/`.

```bash
cd ansible
# Paquets système et utilisateur
ansible-playbook -i inventory/hosts system-install.playbook.yml -e "username=myuser"
# Moteur Docker + réseau partagé (proxy)
ansible-playbook -i inventory/hosts docker-install.playbook.yml -e "username=myuser"
# Conteneurs principaux (Traefik, Homepage, Portainer, Prometheus/Grafana, Jenkins)
ansible-playbook -i inventory/hosts docker-containers.playbook.yml -e "username=myuser"
```

Le `username` est obligatoire pour éviter toute dépendance au nom d'utilisateur de la distribution.

Tu peux aussi fournir un mot de passe explicitement si tu veux qu'Ansible le définisse lors de la création du compte :

```bash
cd ansible
ansible-playbook -i inventory/hosts system-install.playbook.yml -e "username=myuser password=my-password"
```

## 5) Préparer l'environnement Jenkins (optionnel)

Le playbook `docker-containers` crée automatiquement `roles/docker-containers/containers/jenkins/.env` s'il est absent. Le fichier généré utilise des valeurs par défaut adaptées au dev local.

Crée-le manuellement seulement si tu veux surcharger ces valeurs avant le premier lancement :

```bash
cd roles/docker-containers/containers/jenkins
cp .env.example .env
# Modifier .env pour définir JENKINS_IP_ADDRESS dans 172.20.0.0/16 et les identifiants
```

Ensuite, relance l'étape des conteneurs si nécessaire :

```bash
cd ../../../../..
ansible-playbook -i inventory/hosts docker-containers.playbook.yml -e "username=myuser"
```

## 6) Accéder aux services

- Traefik: http://traefik.localhost
- Homepage: http://lab.localhost
- Portainer: http://portainer.localhost
- Prometheus: http://prometheus.localhost
- Grafana: http://grafana.localhost
- Jenkins: http://jenkins.localhost

Checklist minimale avant d'ouvrir le navigateur :

```bash
docker ps
curl -H "Host: traefik.localhost" http://127.0.0.1/
curl -H "Host: lab.localhost" http://127.0.0.1/
```

Résultat attendu : les deux commandes `curl` doivent répondre sans erreur de connexion.

Si les `curl` répondent mais pas le navigateur, le problème vient de la résolution de nom locale, pas de Traefik.

Le routage Traefik est dynamique : un nouveau service devient accessible dès qu'il est connecté au réseau `proxy` et qu'il définit ses labels `traefik.*`.

Sous Ubuntu natif, ajoute si nécessaire les entrées dans `/etc/hosts`.

Sous Windows + WSL, ajoute les entrées dans `C:\Windows\System32\drivers\etc\hosts`, par exemple :

```text
127.0.0.1 traefik.localhost
127.0.0.1 lab.localhost
127.0.0.1 portainer.localhost
127.0.0.1 prometheus.localhost
127.0.0.1 grafana.localhost
127.0.0.1 jenkins.localhost
```

Ensuite teste directement `http://traefik.localhost` puis `http://lab.localhost`.

## Dépannage

- `docker ps` renvoie `permission denied` sur `/var/run/docker.sock`
  - Vérifie que tu as bien exécuté `system-install` et `docker-install` avec le même `username`.
  - Ouvre une nouvelle session, ou exécute `newgrp docker`, car l'ajout au groupe `docker` n'est pas visible dans le shell déjà ouvert.
  - En attendant, `sudo docker ps` doit fonctionner.

- Nouveau conteneur non accessible derrière Traefik
  - Vérifie que le conteneur rejoint le réseau `proxy`.
  - Vérifie la présence des labels `traefik.enable=true`, `traefik.http.routers.*` et `traefik.http.services.*`.
  - Vérifie ensuite avec `docker logs traefik`.

- Collection Docker manquante
  - Exécuter : `ansible-galaxy collection install -r ansible/requirements.yml`
- Réseau `proxy` manquant
  - Vérifie que le playbook `docker-install` est bien terminé, ou crée le réseau `proxy` manuellement.
- Exposition Docker TCP 4243
  - Le daemon écoute sur `127.0.0.1:4243` pour un usage local. Si tu n'as pas besoin du listener TCP, désactive-le dans le rôle `docker-install`.
- Jenkins ne communique pas avec Docker
  - L'image du contrôleur n'inclut pas le CLI Docker par défaut. Préfère des agents de build dédiés avec Docker installé, ou étends l'image pour y ajouter `docker` et l'alignement de groupe.
