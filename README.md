Homelab 24.04
Repo for setting up a local dev homelab on Ubuntu 24.04 using Ansible and Docker. It installs essentials, Docker (with a shared proxy network), and deploys core services via docker-compose: Traefik, Homepage, Portainer, Prometheus/Grafana (with exporters), and Jenkins.

See also: docs/quickstart.md for a minimal step-by-step guide.

Prerequisites
- Ubuntu 24.04 host (tested locally)
- Python 3 and Ansible installed on the host
- Internet access to fetch packages and container images

What's included
- Ansible roles
  - system-install: updates the system, installs common packages, and creates a sudo user
  - docker-install: installs Docker Engine, configures a TCP socket, and creates a shared Docker network (proxy)
  - docker-containers: launches Traefik, Homepage, Portainer, Prometheus/Grafana (+ exporters), and Jenkins
- Docker network
  - Name: proxy
  - Subnet: 172.20.0.0/16 (configurable in role defaults)

Quick start
1) Install the Ansible collection used by the Docker tasks:

	ansible-galaxy collection install -r ansible/requirements.yml

2) Run the plays (from the repo root or the ansible folder):

	cd ansible
	ansible-playbook system-install.playbook.yml
	ansible-playbook docker-install.playbook.yml
	ansible-playbook docker-containers.playbook.yml

Inventory and config
- Inventory: ansible/inventory/hosts (defaults to localhost via ansible.cfg)
- Ansible config: ansible/ansible.cfg (inventory path, warning settings)

Service URLs (via Traefik on the proxy network)
- Traefik dashboard: http://traefik.localhost
- Homepage: http://lab.localhost
- Portainer: http://portainer.localhost
- Prometheus: http://prometheus.localhost
- Grafana: http://grafana.localhost
- Jenkins: http://jenkins.localhost

Jenkins configuration
The Jenkins stack uses Configuration as Code (CASC):
- Compose file: ansible/roles/docker-containers/containers/jenkins/docker-compose.yml
- CASC: ansible/roles/docker-containers/containers/jenkins/config/jenkins.yaml

Prepare environment variables in the Jenkins folder:

	cd ansible/roles/docker-containers/containers/jenkins
	cp .env.example .env
	# Edit .env to set JENKINS_IP_ADDRESS, JENKINS_PORT, credentials, etc.

Notes
- The docker role creates /etc/apt/keyrings before adding the Docker GPG key, which avoids failures on fresh installs.
- The community.docker collection is declared in the docker-containers playbook; install it once with the requirements file.
- The proxy network must exist before starting the containers (the docker-install role creates it). If you run containers independently, ensure the network exists.
