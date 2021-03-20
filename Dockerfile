##BASE IMAGE
FROM ghcr.io/krsuhjunho/centos7-base-systemd

##Utils Install
RUN yum install -y httpd ld-linux.so.2 && \
yum update -y &&\
systemctl enable httpd; yum clean all

#COPY SOURCE FILE && RUN INSTALL
COPY cbof-10.8.5-linux.bin /var/www/cbof-10.8.5-linux.bin

##HEALTHCHECK 
HEALTHCHECK --interval=30s --timeout=30s --start-period=30s --retries=3 CMD curl -f http://127.0.0.1/cgi-bin/cbag/ag.cgi || exit 1

#WORKDIR SETUP
WORKDIR /var/www

##PORT OPEN
EXPOSE 22
EXPOSE 80

CMD ["/usr/sbin/init"]
