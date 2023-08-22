#!/bin/bash
docker-compose exec ansible-control bash -c "cp /root/.ssh/id_rsa.pub /usr/share/cp-ansible-sandbox/id_rsa.pub"
docker-compose exec ubuntu1 bash -c "cat /usr/share/cp-ansible-sandbox/id_rsa.pub >> /root/.ssh/authorized_keys"
