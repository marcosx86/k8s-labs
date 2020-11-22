FROM openjdk:8-jdk-slim-buster

ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt update && apt upgrade -y
RUN apt install -y --no-install-recommends \
	ca-certificates \
	curl \
	netbase \
	wget \
	gnupg \
	dirmngr \
	bzr \
	git \
	git-lfs \
	mercurial \
	openssh-client \
	subversion \
	procps \
	bzip2 \
	unzip \
	xz-utils \
	&& apt clean

ENV LANG=C.UTF-8
ENV JAVA_HOME=/usr/local/openjdk-8
ENV PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ARG JKUSER=jenkins
ARG JKGROUP=jenkins
ARG JKUID=10000
ARG JKGID=10000
ARG JKHOME=/home/jenkins
RUN groupadd -g $JKGID $JKGROUP \
	&& useradd -c "Jenkins user" -d $JKHOME -u $JKUID -g $JKGID -m $JKUSER

ARG VERSION=4.6
ARG AGENT_WORKDIR=$JKHOME/agent
RUN mkdir -pv ${AGENT_WORKDIR}
RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

RUN ln -svT /usr/local/openjdk-8 /docker-java-home \
	&& /docker-java-home/bin/java -version

# Ansible
RUN apt install -y --no-install-recommends \
	sudo \	
	libltdl-dev \
	apt-transport-https \
	#ca-certificates \
	#tar \	
	zip \
	#unzip \
	#wget \
	#curl \	
	#git \
	software-properties-common \
	sshpass \
	ansible \
	host \
	&& apt clean

# Docker 18.09.0
ARG DOCKER_VERSION=18.09.0
RUN curl -fsSL https://download.docker.com/linux/static/stable/`uname -m`/docker-$DOCKER_VERSION.tgz | tar --strip-components=1 -xz -C /usr/local/bin docker/docker

# kubectl
RUN curl https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
	&& chmod +x /usr/local/bin/kubectl

## Maven
#ARG MAVEN_VERSION=3.6.3
#ENV MAVEN_HOME=/usr/share/maven
#RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
#	&& mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
#	&& chmod 777 /usr/share/maven \
#	&& ln -svT /usr/share/maven/bin/mvn /usr/local/bin/mvn

# NodeJS
ARG NODEJS_FLAVOR=10.x
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_FLAVOR} | bash - \
	&& apt install -y --no-install-recommends nodejs \
	&& apt clean

# NPM & Global Workbench
COPY npmrc /root/.npmrc
COPY npmrc ${JKHOME}/.npmrc
RUN npm -g i npm @angular/cli gulp-cli yarn \
	&& rm -rf /root/.npm \ 
	&& rm -fv /root/.npmrc

## Yarn
#RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#	&& echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#	&& apt update \
#	&& apt install -y --no-install-recommends yarn \
#	&& apt clean

COPY ./jenkins-agent.sh /usr/local/bin/jenkins-agent
RUN chmod +x /usr/local/bin/jenkins-agent \
	&& ln -s /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-slave \
	&& mkdir -pv ${JKHOME}/.jenkins ${AGENT_WORKDIR} \
	&& chown -R ${JKUSER}:${JKGROUP} ${JKHOME}

USER ${JKUSER}
WORKDIR ${JKHOME}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}

VOLUME [${JKHOME}/.jenkins]
VOLUME [${AGENT_WORKDIR}]

# Necessário para rodar os comandos docker
USER root

ENTRYPOINT ["jenkins-agent"]
