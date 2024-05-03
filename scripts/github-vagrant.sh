#!/bin/bash

# Defaults
TIMEOUT=600
ELAPSED=0
INITIAL_SLEEP=60
SLEEP_DURATION=30
SSH_AVAILABLE=0
DEBUG_ID="[homelab-ci]"

# Run Vagrant Up in the background
PLAYBOOK=dockerbox vagrant up &
VAGRANT_UP_PID=$!

# Initial delay
echo "$DEBUG_ID Waiting for VM to start..."
sleep $INITIAL_SLEEP

# Loop until timeout or breaks
while [[ $ELAPSED -lt $TIMEOUT ]]; do
	VAGRANT_SSH_CONFIG=$(mktemp)
	vagrant ssh-config > "$VAGRANT_SSH_CONFIG"
	echo "$DEBUG_ID SSH config at $VAGRANT_SSH_CONFIG"
	cat "$VAGRANT_SSH_CONFIG"
	echo "$DEBUG_ID Vagrant status"
	vagrant status

	# SSH attempt
	set -x
	ssh -vvv -F "$VAGRANT_SSH_CONFIG" default 'cat /etc/os-release' && set +x; break \
	|| echo "$DEBUG_ID SSH connection failed, retrying in $SLEEP_DURATION seconds..."
	set +x

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
