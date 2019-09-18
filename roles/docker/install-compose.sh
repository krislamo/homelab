#!/bin/bash

# Github username and repo name
user="docker"
repo="compose"

# Retrieve the latest version number
addr="https://github.com/$user/$repo/releases/latest"
page=$(curl -s $addr | grep -o releases/tag/*.*\")
version=$(echo $page | awk '{print substr($1, 14, length($1) - 14)}')

# Download prep
url="https://github.com/$user/$repo/releases/download/$version"
file="docker-compose-$(uname -s)-$(uname -m)"

# Download latest Docker Compose if that version hasn't been downloaded
if [ ! -f /tmp/docker_compose_$version ]; then
  curl -L $url/$file -o /tmp/docker-compose_$version
fi

# Is it already installed?
if installed=$(which docker-compose); then

  new_chksum=$(sha256sum /tmp/docker-compose_$version)
  old_chksum=$(sha256sum /usr/local/bin/docker-compose)

  # If checksums are different, delete and install new version
  if [ ! "$new_chksum" = "$old_chksum" ]; then
    rm /usr/local/bin/docker-compose
    mv /tmp/docker-compose_$version /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  fi

else
  # It's not installed, so no need to remove
  mv /tmp/docker-compose_$version /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
fi
