# Homelab 24.04 - Quickstart

A minimal step-by-step guide to bring the stack up on Ubuntu 24.04.

## 1) Prerequisites

- Ubuntu 24.04 host
- Sudo access
- Python 3 and Ansible

Install Ansible (one option):

```bash
sudo apt update
sudo apt install -y ansible python3-pip
```

## 2) Clone and enter the repo

```bash
git clone https://github.com/jemmalmohamed/homelab-24.04.git
cd homelab-24.04
```

## 3) Install required Ansible collections

```bash
ansible-galaxy collection install -r ansible/requirements.yml
```

## 4) Run the playbooks

Run from the repo root or the `ansible/` folder.

```bash
cd ansible
# System packages and user
ansible-playbook system-install.playbook.yml
# Docker engine + shared network (proxy)
ansible-playbook docker-install.playbook.yml
# Core containers (Traefik, Homepage, Portainer, Prometheus/Grafana, Jenkins)
ansible-playbook docker-containers.playbook.yml
```

## 5) Prepare Jenkins environment (once)

```bash
cd roles/docker-containers/containers/jenkins
cp .env.example .env
# Edit .env to set JENKINS_IP_ADDRESS within 172.20.0.0/16 and credentials
```

Then re-run the containers step if needed:

```bash
cd ../../../../..
ansible-playbook docker-containers.playbook.yml
```

## 6) Access services

- Traefik:  http://traefik.localhost
- Homepage: http://lab.localhost
- Portainer: http://portainer.localhost
- Prometheus: http://prometheus.localhost
- Grafana:   http://grafana.localhost
- Jenkins:   http://jenkins.localhost

If DNS for *.localhost is not resolving in your browser, add entries to `/etc/hosts` or use a browser that resolves `*.localhost` to 127.0.0.1.

## Troubleshooting

- Missing Docker collection
  - Run: `ansible-galaxy collection install -r ansible/requirements.yml`
- Proxy network missing
  - Ensure `docker-install` playbook completed; or create the `proxy` network manually.
- Docker TCP 4243 exposure
  - The daemon is configured to listen on `0.0.0.0:4243`. For local-only use, firewall or disable the TCP listener (ask me to harden it via systemd drop-in).
- Jenkins can’t talk to Docker
  - Controller image lacks docker CLI by default. Prefer dedicated build agents with Docker installed, or extend the image to include `docker` and group alignment.
