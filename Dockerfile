# Using Ubuntu as the base image
FROM ubuntu:20.04

# To prevent some messages from APT from causing issues
ARG DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
        sudo \
        python3 \
        python3-pip \
        python3-dev \
        openssl \
        ca-certificates \
        sshpass \
        openssh-client \
        rsync \
        git \
        gcc \
        libffi-dev \
        libssl-dev \
        make \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --upgrade pip wheel && \
    pip3 install --upgrade cryptography cffi && \
    pip3 install ansible-core==2.13.9 && \
    pip3 install mitogen jmespath && \
    pip3 install --upgrade pywinrm

# Create Ansible directories
RUN mkdir /etc/ansible /ansible
RUN mkdir ~/.ssh

# Override SSH Hosts Checking
RUN echo "host *" >> ~/.ssh/config && \
    echo "StrictHostKeyChecking no" >> ~/.ssh/config

# Generate SSH key
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -N ''


# Create playbook directory
RUN mkdir -p /ansible/ansible_collections/confluent/platform

# Set working directory

# Set environment variables
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING False
ENV ANSIBLE_RETRY_FILES_ENABLED False
ENV ANSIBLE_COLLECTIONS_PATH /ansible/ansible_collections
ENV ANSIBLE_SSH_PIPELINING True
ENV ANSIBLE_HASH_BEHAVIOUR merge
ENV PATH /ansible/bin:$PATH
ENV PYTHONPATH /ansible/lib
ENV ANSIBLE_INVENTORY /ansible/ansible_collections/confluent/platform/inventories/ansible-inventory.yml

# Install required Ansible modules afer container comes up. Possibly in entrypoint or comamnd
RUN ansible-galaxy collection install ansible.posix community.general community.crypto

# Set entry point
CMD ["sh", "-c", "sleep infinity"]
