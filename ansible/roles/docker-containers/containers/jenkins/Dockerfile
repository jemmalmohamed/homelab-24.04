# Use the official Jenkins image as a base
FROM jenkins/jenkins:lts-jdk17

# Skip the setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# #install mave
# USER root
# RUN apt-get update && apt-get install -y maven
# RUN apt-get update && apt-get install -y sudo

# # Install Docker
# RUN apt-get update && \
#     apt-get -y install apt-transport-https \
#     ca-certificates \
#     curl \
#     gnupg-agent \
#     software-properties-common && \
#     curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
#     add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
#     apt-get update && \
#     apt-get -y install docker-ce docker-ce-cli containerd.io


# RUN sudo usermod -a -G docker jenkins

# Return to the jenkins user
USER jenkins
# Install Jenkins plugins
# Add plugins as needed
# Install Jenkins plugins using jenkins-plugin-cli
RUN jenkins-plugin-cli --plugins \
    ant:latest \
    antisamy-markup-formatter:latest \
    locale \
    build-timeout:latest \
    cloudbees-folder:latest \
    configuration-as-code:latest \
    credentials-binding:latest \
    email-ext:latest \
    git:latest \
    github-branch-source:latest \
    gradle:latest \
    maven-plugin:latest \
    github \
    github-branch-source \
    ldap:latest \
    blueocean docker-workflow \
    docker-plugin \
    docker-commons \
    mailer:latest \
    matrix-auth:latest \
    pipeline-groovy-lib \
    pam-auth:latest \
    pipeline-github-lib:latest \
    pipeline-stage-view:latest \
    ssh-slaves:latest \
    timestamper:latest \
    workflow-aggregator:latest \
    ws-cleanup:latest



# Add Jenkins user to the Docker group


# Copy configuration files
# Make sure to have a jenkins.yaml file in your project directory
# COPY ./config/jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml

# Set Jenkins Configuration as Code environment variable
# ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc_configs/jenkins.yaml

# Other configurations if needed
