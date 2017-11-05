#
#  Dockerfile for a KDC-KADMIN
#

FROM centos:6.7

EXPOSE 749 88

RUN echo root:pivotal | chpasswd \
    && yum install -y wget which passwd  sudo \
    && yum install -y krb5-libs krb5-server  \
    && yum install -y vim openssh-client \
    && yum clean all

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
RUN echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale

# default root password
RUN echo "root:pivotal" | chpasswd

ENV REALM ${REALM:-EXAMPLE.COM}
ENV SUPPORTED_ENCRYPTION_TYPES ${SUPPORTED_ENCRYPTION_TYPES:-aes256-cts-hmac-sha1-96:normal}
ENV KADMIN_PRINCIPAL ${KADMIN_PRINCIPAL:-kadmin/admin}
ENV KADMIN_PASSWORD ${KADMIN_PASSWORD:-MITiys4K5}
ENV GPADMIN_ADMIN_PRINCIPAL ${GPADMIN_PRINCIPAL:-gpadmin/admin}
ENV GPADMIN_ADMIN_PASSWORD ${GPADMIN_PASSWORD:-pivotal}
ENV GPADMIN_PRINCIPAL ${GPADMIN_PRINCIPAL:-gpadmin/kdc-kadmin}
ENV GPADMIN_PASSWORD ${GPADMIN_PASSWORD:-pivotal}
ENV POSTGRES_PRINCIPAL ${POSTGRES_PRINCIPAL:-postgres/gpdbsne.example.com}
ENV POSTGRES_PASSWORD ${POSTGRES_PASSWORD:-pivotal}

COPY init-script.sh /tmp/
CMD /tmp/init-script.sh
