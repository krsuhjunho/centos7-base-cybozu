##BASE IMAGE
FROM ghcr.io/krsuhjunho/centos7-base-systemd

##Utils Install
RUN yum install -y httpd ld-linux.so.2 && \
yum update -y &&\
systemctl enable httpd; yum clean all

#COPY SOURCE FILE && RUN INSTALL
COPY cbof-10.8.5-linux.bin /var/www/cbof-10.8.5-linux.bin

#WORKDIR SETUP
WORKDIR /var/www


##PORT OPEN
EXPOSE 22
EXPOSE 80

CMD ["/usr/sbin/init"]
