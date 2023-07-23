#!/bin/bash

# Find private key file
PRIVATE_KEY="$(find .vagrant -name "private_key")"

# Does the private_key file exist?
if [ ! -f "$PRIVATE_KEY" ]; then
  echo "[ERROR] File not found at \"$PRIVATE_KEY\""
  exit 1
fi

# Is the private_key a valid SSH key?
echo "Checking validity of private key at $(pwd)/$PRIVATE_KEY"
if ! ssh-keygen -l -f "$PRIVATE_KEY"; then
  echo "[Error] The private key at \"$PRIVATE_KEY\" is invalid (CODE: $?)"
  exit 1
fi

# Find an IP on the VM for the SSH tunnel
HOST_IP="$(vagrant ssh -c "hostname -I | cut -d' ' -f${HOSTNAME_FIELD:-1}" 2>/dev/null | sed 's/.$//')"

# SSH command to match in processes table
CMD="ssh -fNT -i $PRIVATE_KEY -L 8443:localhost:8443 -L 80:localhost:80 -L 443:localhost:443.*vagrant@$HOST_IP"

# Not just after PIDs
# shellcheck disable=SC2009
PS_TUNNELS="$(ps aux | grep -e "$CMD" | grep -v grep)"
PS_COUNTER="$(echo "$PS_TUNNELS" | wc -l)"

if [ "$PS_COUNTER" -gt 0 ]; then
  echo "[ERROR] Tunnel(s) already seems to exist (counted $PS_COUNTER)"
  echo \""$PS_TUNNELS"\"
  exit 1
fi

# Create an SSH tunnel
echo "Starting background SSH connection for localhost port forwarding"
set -x
ssh -fNT -i "$PRIVATE_KEY" \
  -L 8443:localhost:8443 \
  -L 80:localhost:80 \
  -L 443:localhost:443 \
  -o UserKnownHostsFile=/dev/null \
  -o StrictHostKeyChecking=no \
    vagrant@"${HOST_IP}" 2>/dev/null

