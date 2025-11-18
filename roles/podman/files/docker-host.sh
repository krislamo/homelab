# shellcheck shell=sh
: "${UID:=$(id -u)}"

if [ "$UID" -ne 0 ]; then
	if [ -z "$XDG_RUNTIME_DIR" ] && [ -d "/run/user/$UID" ]; then
		XDG_RUNTIME_DIR="/run/user/$UID"
		export XDG_RUNTIME_DIR
	fi

	PODMAN_SOCKET="$XDG_RUNTIME_DIR/podman/podman.sock"
	if [ -S "$PODMAN_SOCKET" ]; then
		DOCKER_HOST="unix://$PODMAN_SOCKET"
		export DOCKER_HOST
	fi

	if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
		if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
			DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
			export DBUS_SESSION_BUS_ADDRESS
		fi
	fi
fi
