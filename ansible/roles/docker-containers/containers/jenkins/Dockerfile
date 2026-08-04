FROM jenkins/jenkins:latest-jdk21

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

USER jenkins

RUN jenkins-plugin-cli --plugins \
    ant:latest \
    antisamy-markup-formatter:latest \
    blueocean:latest \
    build-timeout:latest \
    cloudbees-folder:latest \
    configuration-as-code:latest \
    credentials-binding:latest \
    docker-commons:latest \
    docker-plugin:latest \
    docker-workflow:latest \
    email-ext:latest \
    git:latest \
    github:latest \
    github-branch-source:latest \
    gradle:latest \
    ldap:latest \
    locale:latest \
    mailer:latest \
    maven-plugin:latest \
    matrix-auth:latest \
    pam-auth:latest \
    pipeline-github-lib:latest \
    pipeline-groovy-lib:latest \
    pipeline-stage-view:latest \
    ssh-slaves:latest \
    timestamper:latest \
    workflow-aggregator:latest \
    ws-cleanup:latest
