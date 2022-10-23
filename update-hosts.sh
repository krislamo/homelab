#!/bin/bash

COMMENT="Project Moxie"
DOMAIN="vm.krislamo.org"
HOST[0]="traefik.${DOMAIN}"
HOST[1]="cloud.${DOMAIN}"
HOST[2]="git.${DOMAIN}"
HOST[3]="jenkins.${DOMAIN}"
HOST[4]="prom.${DOMAIN}"
HOST[5]="grafana.${DOMAIN}"
HOST[6]="nginx.${DOMAIN}"
HOST[7]="vault.${DOMAIN}"
HOST[8]="wordpress.${DOMAIN}"
HOST[9]="site1.wordpress.${DOMAIN}"
HOST[10]="site2.wordpress.${DOMAIN}"
HOST[11]="unifi.${DOMAIN}"
HOST[11]="kutt.${DOMAIN}"

# Get Vagrantbox guest IP
VAGRANT_OUTPUT=$(vagrant ssh -c "hostname -I | cut -d' ' -f2" 2>/dev/null)

# Remove ^M from the end
[ ${#VAGRANT_OUTPUT} -gt 1 ] && IP=${VAGRANT_OUTPUT::-1}

echo "Purging project addresses from /etc/hosts"
sudo sed -i "s/# $COMMENT//g" /etc/hosts
for address in "${HOST[@]}"; do
  sudo sed -i "/$address/d" /etc/hosts
done

# Remove trailing newline
sudo sed -i '${/^$/d}' /etc/hosts

if [ -n "$IP" ]; then
  echo -e "Adding new addresses...\n"
  echo -e "# $COMMENT" | sudo tee -a /etc/hosts
  for address in "${HOST[@]}"; do
    echo -e "$IP\t$address" | sudo tee -a /etc/hosts
  done
else
  echo "Cannot find address. Is the Vagrant box running?"
fi
