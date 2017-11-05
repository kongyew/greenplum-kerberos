# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# User: gpadmin Password: pivotal
# or root/pivotal
# How to build this image via CLI
# $ docker build -t gpdb-spark -f ./Dockerfile  .


FROM pivotaldata/gpdb-base
LABEL name="gpdb-spark"
LABEL description="Example for Greenplum with Spark - test"
LABEL version=1.1.1
#Use root
USER root
# Install JDK
ENV JAVA_VERSION 8u31
ENV BUILD_VERSION b13

# fix this issue : Rpmdb checksum is invalid: dCDPT(pkg checksums)
RUN rpm --rebuilddb; yum install -y yum-plugin-ovl

# Upgrading system
RUN yum -y upgrade
RUN yum -y install wget
#RUN yum -y install unzip


# Install psql, createDB
RUN yum install -y postgresql


ENV JAVA_VERSION 1.8.0
RUN yum -y update \
     && yum install -y java-"${JAVA_VERSION}"-openjdk   \
    && yum install -y java-"${JAVA_VERSION}"-openjdk-devel \
    && yum clean all
ENV JAVA_HOME /usr/java/latest

## Install Kerberos5 client
RUN	yum install -y -q krb5-libs krb5-workstation


###############################################################################
# Default ports:
# GPDB 5432
# SEGMENT 40000
EXPOSE 9090:9090 5432 5005 5010 9022:22 40000 40001 40002
VOLUME ["/gpdata/"]

COPY gpdb/files         /home/gpadmin/
COPY gpdb/files/*.jar   /usr/local/bin/
COPY gpdb/scripts       /usr/local/bin/


RUN chmod +x /usr/local/bin/configureKerberosClient.sh \
    && chmod +x /usr/local/bin/setupKerberos4PSQL.sh \
    && chmod +x /usr/local/bin/startGPDB.sh \
    && chmod +x /usr/local/bin/stopGPDB.sh \
    && chmod +x /usr/local/bin/testJDBCConnection.sh

USER gpadmin
# JCEPolicy : http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip
RUN cd /home/gpadmin && unzip /home/gpadmin/jce_policy-8.zip

    #  /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/lib/security

USER root
RUN cp /home/gpadmin/UnlimitedJCEPolicyJDK8/*.jar /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/lib/security
RUN chown -R gpadmin: /home/gpadmin
# Define default command.
