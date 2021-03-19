##BASE IMAGE
FROM ghcr.io/krsuhjunho/centos7-base-systemd

##Utils Install
RUN yum install -y httpd linux.so.2 && \
yum update -y &&\
systemctl enable httpd; yum clean all

#COPY SOURCE FILE && RUN INSTALL
COPY RUN-INSTALL-CYBOZU.sh /usr/local/src/RUN-INSTALL-CYBOZU.sh
RUN /usr/local/src/RUN-INSTALL-CYBOZU.sh && \
    rm -rf /usr/local/src/* 

#WORKDIR SETUP
WORKDIR /var/www


##PORT OPEN
EXPOSE 22
EXPOSE 80

CMD ["/usr/sbin/init"]
