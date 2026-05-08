# Homelab Dev Local Ubuntu 24.04

Infrastructure de dev local pour Ubuntu 24.04, basée sur Ansible et Docker.

Le dépôt installe les paquets système utiles, configure Docker avec un réseau partagé, puis déploie une stack de services via Docker Compose : Traefik, Homepage, Portainer, Prometheus, Grafana et Jenkins.

Le guide rapide en français est disponible dans [docs/quickstart.md](./docs/quickstart.md).

## Objectif

Ce projet vise un usage homelab local pour le développement, pas une plateforme de production.

Les choix actuels privilégient :

- un bootstrap simple via Ansible
- une stack locale accessible en `*.localhost`
- une installation portable d'une distribution à l'autre
- un utilisateur Linux explicite, passé à l'exécution des playbooks

## Stack incluse

### Rôles Ansible

- `system-install` : installe les paquets système, prépare l'utilisateur du homelab et les dépendances de base
- `docker-install` : installe Docker Engine, configure le listener local et crée le réseau `proxy`
- `docker-containers` : déploie Traefik, Homepage, Portainer, Prometheus, Grafana et Jenkins

### Services exposés

- Traefik : `http://traefik.localhost`
- Homepage : `http://lab.localhost`
- Portainer : `http://portainer.localhost`
- Prometheus : `http://prometheus.localhost`
- Grafana : `http://grafana.localhost`
- Jenkins : `http://jenkins.localhost`

## Prérequis

- Ubuntu 24.04
- accès `sudo`
- Python 3
- Ansible
- accès Internet pour les paquets et images Docker

Installation d'Ansible :

```bash
sudo apt update
sudo apt install -y ansible python3-pip
```

## Démarrage rapide

Cloner le dépôt :

```bash
git clone https://github.com/jemmalmohamed/homelab-24.04.git
cd homelab-24.04
```

Installer les collections Ansible requises :

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

Exécuter les playbooks :

```bash
cd ansible
ansible-playbook system-install.playbook.yml -e "username=myuser"
ansible-playbook docker-install.playbook.yml -e "username=myuser"
ansible-playbook docker-containers.playbook.yml -e "username=myuser"
```

Le `username` est obligatoire pour éviter toute dépendance à un utilisateur par défaut propre à la distribution.

Si tu veux aussi définir le mot de passe du compte créé par Ansible :

```bash
ansible-playbook system-install.playbook.yml -e "username=myuser password=my-password"
```

## Jenkins

Jenkins utilise Configuration as Code.

- Compose : `ansible/roles/docker-containers/containers/jenkins/docker-compose.yml`
- CasC : `ansible/roles/docker-containers/containers/jenkins/config/jenkins.yaml`

Le playbook `docker-containers` crée automatiquement `ansible/roles/docker-containers/containers/jenkins/.env` s'il manque, à partir de valeurs adaptées au dev local.

Si tu veux personnaliser Jenkins avant le premier lancement :

```bash
cd ansible/roles/docker-containers/containers/jenkins
cp .env.example .env
```

## Notes de fonctionnement

- Docker écoute sur `127.0.0.1:4243` par défaut pour rester limité à un usage local
- le réseau Docker partagé s'appelle `proxy`
- Jenkins prépare son dossier agent sur l'hôte via Ansible
- les artefacts locaux Jenkins comme `.env` ou `agent.jar` ne sont plus destinés à être versionnés

## Structure utile

- `ansible/` : playbooks, inventaire et rôles
- `docs/quickstart.md` : guide rapide en français
- `ansible/roles/docker-containers/containers/` : stacks Docker Compose par service

## Dépannage rapide

- collection Docker manquante : `ansible-galaxy collection install -r ansible/requirements.yml`
- réseau `proxy` absent : relancer `docker-install.playbook.yml`
- listener Docker TCP inutile : désactiver le listener dans le rôle `docker-install`
- Jenkins sans Docker CLI : utiliser un agent dédié ou étendre l'image Jenkins
