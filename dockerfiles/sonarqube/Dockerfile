FROM openjdk:11-jdk-slim-buster

# Adaptado de https://github.com/SonarSource/docker-sonarqube/blob/master/7/community/Dockerfile

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install -y --no-install-recommends \
	curl \
	gnupg \
	unzip \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*

ENV SONAR_VERSION=7.9.5 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=""

# pub   2048R/D26468DE 2015-05-25
#       Key fingerprint = F118 2E81 C792 9289 21DB  CAB4 CFCA 4A29 D264 68DE
# uid                  sonarsource_deployer (Sonarsource Deployer) <infra@sonarsource.com>
# sub   2048R/06855C1D 2015-05-25
RUN for server in $(shuf -e ha.pool.sks-keyservers.net \
		hkp://p80.pool.sks-keyservers.net:80 \
		keyserver.ubuntu.com \
		hkp://keyserver.ubuntu.com:80 \
		pgp.mit.edu) ; do \
		gpg --batch --keyserver "$server" --recv-keys F1182E81C792928921DBCAB4CFCA4A29D26468DE && break || : ; \
	done

RUN groupadd -r sonarqube \
	&& useradd -r -g sonarqube -d $SONARQUBE_HOME sonarqube \
	&& set -x \
	&& cd /opt \
	&& curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
	&& curl -o sonarqube.zip.asc -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip.asc \
	&& gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
	&& unzip -q sonarqube.zip \
	&& mv sonarqube-$SONAR_VERSION sonarqube \
	&& chown -R sonarqube:sonarqube sonarqube \
	&& rm sonarqube.zip* \
	&& rm -rf $SONARQUBE_HOME/bin/*

EXPOSE 9000
VOLUME "$SONARQUBE_HOME/data"
WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
COPY sonar.properties $SONARQUBE_HOME/conf/
USER sonarqube

ENTRYPOINT ["./bin/run.sh"]
