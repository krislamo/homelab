#!/bin/bash

# Finds the SSH private key under ./.vagrant and connects to
# the Vagrant box, port forwarding localhost ports: 8443, 443, 80, 22
#
# Download the latest script:
# https://git.krislamo.org/kris/homelab/raw/branch/main/forward-ssh.sh
#
# Copyright (C) 2023  Kris Lamoureux
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Root check
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR]: Please run this script as root"
  exit 1
fi

# Clean environment
unset PRIVATE_KEY
unset HOST_IP
unset MATCH_PATTERN
unset PKILL_ANSWER

# Function to create the SSH tunnel
function ssh_connect {
  read -rp "Start a new vagrant SSH tunnel? [y/N] " PSTART_ANSWER
  echo
  case "$PSTART_ANSWER" in
    [yY])
      printf "[INFO]: Starting new vagrant SSH tunnel on PID "
      sudo -u "$USER" ssh -fNT -i "$PRIVATE_KEY" \
        -L 22:localhost:22 \
        -L 80:"$HOST_IP":80 \
        -L 443:"$HOST_IP":443 \
        -L 8443:localhost:8443 \
        -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        vagrant@"$HOST_IP" 2>/dev/null
      sleep 2
      pgrep -f "$MATCH_PATTERN"
      ;;
    *)
      echo "[INFO]: Declined to start a new vagrant SSH tunnel"
      exit 0
      ;;
  esac
}

# Check for valid PRIVATE_KEY location
PRIVATE_KEY="$(find .vagrant -name "private_key" 2>/dev/null | sort)"

# Single vagrant machine or multiple
if [ "$(echo "$PRIVATE_KEY" | wc -l)" -gt 1 ]; then
  while IFS= read -r KEYFILE; do
    if ! ssh-keygen -l -f "$KEYFILE" &>/dev/null; then
      echo "[ERROR]: The SSH key '$KEYFILE' is not valid. Are your virtual machines running?"
      exit 1
    fi
    echo "[CHECK]: Valid key at $KEYFILE"
  done < <(echo "$PRIVATE_KEY")
  PRIVATE_KEY="$(echo "$PRIVATE_KEY" | grep -m1 "${1:-default}")"
elif ! ssh-keygen -l -f "$PRIVATE_KEY" &>/dev/null; then
  echo "[ERROR]: The SSH key '$PRIVATE_KEY' is not valid. Is your virtual machine running?"
  exit 1
else
  echo "[CHECK]: Valid key at $PRIVATE_KEY"
fi

# Grab first IP or use whatever HOST_IP_FIELD is set to and check that the guest is up
HOST_IP="$(vagrant ssh -c "hostname -I | cut -d' ' -f${HOST_IP_FIELD:-1}" "${1:-default}" 2>/dev/null)"
if [ -z "$HOST_IP" ]; then
  echo "[ERROR]: Failed to find ${1:-default}'s IP"
  exit 1
fi
HOST_IP="${HOST_IP::-1}" # trim

if ! ping -c 1 "$HOST_IP" &>/dev/null; then
  echo "[ERROR]: Cannot ping the host IP '$HOST_IP'"
  exit 1
fi
echo "[CHECK]: Host at $HOST_IP (${1:-default}) is up"

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
      pgrep -f "$MATCH_PATTERN" | tee >(xargs kill -15)
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
