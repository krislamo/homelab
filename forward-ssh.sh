#!/bin/bash

# Finds the SSH private key under ./.vagrant and connects to
# the Vagrant box, port forwarding localhost ports: 8443, 80, 443

# Clean environment
unset PRIVATE_KEY
unset HOST_IP
unset MATCH_PATTERN
unset PKILL_ANSWER

# Function to create the SSH tunnel
function ssh_connect {
  printf "[INFO]: Starting new vagrant SSH tunnel on PID "
  sudo ssh -fNT -i "$PRIVATE_KEY" \
    -L 8443:localhost:8443 \
    -L 80:localhost:80 \
    -L 443:localhost:443 \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
      vagrant@"$HOST_IP" 2>/dev/null
  sleep 2
  pgrep -f "$MATCH_PATTERN"
}

# Check for valid PRIVATE_KEY location
PRIVATE_KEY="$(find .vagrant -name "private_key" 2>/dev/null)"
if ! ssh-keygen -l -f "$PRIVATE_KEY" &>/dev/null; then
  echo "[ERROR]: The SSH key '$PRIVATE_KEY' is not valid. Is your virtual machine running?"
  exit 1
fi
echo "[CHECK]: Valid key at $PRIVATE_KEY"

# Grab first IP or use whatever HOST_IP_FIELD is set to and check that the guest is up
HOST_IP="$(vagrant ssh -c "hostname -I | cut -d' ' -f${HOST_IP_FIELD:-1}" 2>/dev/null)"
HOST_IP="${HOST_IP::-1}" # trim
if ! ping -c 1 "$HOST_IP" &>/dev/null; then
  echo "[ERROR]: Cannot ping the host IP '$HOST_IP'"
  exit 1
fi
echo "[CHECK]: Host at $HOST_IP is up"

# Pattern for matching processes running
MATCH_PATTERN="ssh -fNT -i ${PRIVATE_KEY}.*vagrant@"

# Check amount of processes that match the pattern
if [ "$(pgrep -afc "$MATCH_PATTERN")" -eq 0 ]; then
  ssh_connect
else
  # Processes found, so prompt to kill remaining ones then start tunnel
  printf "\n[WARNING]: Found processes running:\n"
  pgrep -fa "$MATCH_PATTERN"
  printf '\n'
  read -rp "Would you like to kill these processes? [y/N] " PKILL_ANSWER
  echo
  case "$PKILL_ANSWER" in
    [yY])
      echo "[WARNING]: Killing old vagrant SSH tunnel(s): "
      pgrep -f "$MATCH_PATTERN" | tee >(xargs sudo kill -15)
      echo
      if [ "$(pgrep -afc "$MATCH_PATTERN")" -eq 0 ]; then
        ssh_connect
      else
        echo "[ERROR]: Unable to kill processes:"
        pgrep -f "$MATCH_PATTERN"
        exit 1
      fi
      ;;
    *)
      echo "[INFO]: Declined to kill existing processes"
      exit 0
      ;;
  esac
fi
