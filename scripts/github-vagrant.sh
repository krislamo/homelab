#!/bin/bash

# Defaults
TIMEOUT=600
ELAPSED=0
INITIAL_SLEEP=60
SLEEP_DURATION=30
SSH_AVAILABLE=0
DEBUG_ID="[homelab-ci]"

# Run Vagrant Up in the background
PLAYBOOK=dockerbox vagrant up --debug &
VAGRANT_UP_PID=$!

# Initial delay
echo "$DEBUG_ID Waiting for VM to start..."
sleep $INITIAL_SLEEP

# Loop until timeout or breaks
while [[ $ELAPSED -lt $TIMEOUT ]]; do
	vagrant status
	PRIVATE_KEY="$(vagrant ssh-config | grep -vE 'IdentityFile.*\.rsa$' | awk '{print $2}')"
	HOST_IP="$(vagrant ssh-config | grep HostName | awk '{print $2}')"

	echo "$DEBUG_ID Checking SSH connection availability..."
	echo "$DEBUG_ID Private Key: $PRIVATE_KEY"
	echo "$DEBUG_ID Host IP: $HOST_IP"
	echo "$DEBUG_ID Running nmap to check open ports..."

	# Check if SSH is open
	nmap -p 22 "$HOST_IP" | grep "22/tcp open" && SSH_AVAILABLE=1 || SSH_AVAILABLE=0
	if [[ $SSH_AVAILABLE -eq 1 ]]; then
		echo "$DEBUG_ID SSH port is open, attempting connection..."
		set -x
		ssh -vvv -i "$PRIVATE_KEY" \
			-o UserKnownHostsFile=/dev/null \
			-o StrictHostKeyChecking=no \
			-o IdentitiesOnly=yes \
			-o PreferredAuthentications=publickey \
			-o PubkeyAuthentication=yes \
			-o PasswordAuthentication=no \
			-o KbdInteractiveAuthentication=no \
			vagrant@"$HOST_IP" cat /etc/os-release && break || echo "$DEBUG_ID SSH connection failed, retrying..."
		set +x
	else
		echo "$DEBUG_ID SSH port not open, retrying in $SLEEP_DURATION seconds..."
	fi

	# Sleep and start again
	sleep $SLEEP_DURATION
	((ELAPSED+=SLEEP_DURATION))
done

# Success?
if [[ $SSH_AVAILABLE -ne 1 ]]; then
	echo "$DEBUG_ID Timeout reached without successful SSH connection."
fi

# Ensure the Vagrant up process completes
wait $VAGRANT_UP_PID
