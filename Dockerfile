FROM amazonlinux:2
RUN yum update -y \
  && yum install -y jq awscli \
  && yum clean all
COPY bootstrap.sh scripts/*.sh /
WORKDIR /
ENTRYPOINT ["./bootstrap.sh"]
