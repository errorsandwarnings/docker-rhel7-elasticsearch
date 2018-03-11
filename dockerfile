FROM registry.access.redhat.com/rhel7
MAINTAINER Anuj Aggarwal
ENV user layer6
# Update the image and clear cache
# Can not be done due to subscription issues
#RUN yum -y update; yum clean all


# Copy all artifacts from local
COPY ./artifacts/* /tmp/
# Install JDK
RUN rpm --install /tmp/jdk*.rpm

# Adding user and group
RUN groupadd  ${user}
RUN useradd -ms /bin/bash -g ${user} ${user}

# Add a location for elasticsearch symlinks
RUN mkdir /user
RUN chown ${user}:${user} /user

#Switch to the user
USER ${user}:${user}
WORKDIR /home/${user}/

# Install elasticsearch
RUN tar -xzf /tmp/elasticsearch*.tar.gz -C /user/
RUN mv /user/elasticsearch* /user/elasticsearch
RUN ls -ltrha /user


EXPOSE 9200 9300
ENTRYPOINT ["/user/elasticsearch/bin/elasticsearch","-Ecluster.name=cortex","-Enode.name=docker-node-1","-Enetwork.host=0.0.0.0"]