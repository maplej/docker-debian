FROM debian:jessie

MAINTAINER Jiawei Chen <jiawei.chen@honestwalker.com>

#ENV DEBIAN_FRONTEND noninteractive
#ENV LC_ALL C
ENV NOTVISIBLE "in users profile"

RUN apt-get update && \
    apt-get install -yq --no-install-recommends sudo curl openssh-server supervisor

# sshd
RUN mkdir /var/run/sshd && \
    echo 'root:123123' | chpasswd && \
    sed -i 's/PermitRootLogin without-password/#PermitRootLogin without-password/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

# supervisord
RUN mkdir -p /var/log/supervisor && \
    mkdir -p etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY supervisor-conf.d/* /etc/supervisor/conf.d/

EXPOSE 22
CMD ["/usr/bin/supervisord"]
