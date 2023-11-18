# Homelab

This project is my personal IT homelab initiative for self-hosting and
exploring Free and Open Source Software (FOSS) infrastructure. As a technology
enthusiast and professional, this project is primarily a practical tool for
hosting services. It serves as a playground for engaging with systems
technology in functional, intriguing, and gratifying ways. Self-hosting
empowers individuals to govern their digital space, ensuring that their online
environments reflect personal ethics rather than centralized entities' opaque
policies.

Built on Debian Stable, this project utilizes Ansible and Vagrant, providing
relatively easy-to-use reproducible ephemeral environments to test
infrastructure automation before pushing to live systems.

## Quick Start

To configure a local virtual machine for testing, follow these simple steps.

### Installation

1. Clone this repository
   ```
   git clone https://git.krislamo.org/kris/homelab
   ```
   Optionally clone from the GitHub mirror instead:
   ```
   git clone https://github.com/krislamo/homelab
   ```
2. Set the `PLAYBOOK` environmental variable to a development playbook name in the `dev/` directory

   To list available options in the `dev/` directory and choose a suitable PLAYBOOK, run:
   ```
   ls dev/*.yml | xargs -n 1 basename -s .yml
   ```
   Export the `PLAYBOOK` variable
   ```
   export PLAYBOOK=dockerbox
   ```
3. Clean up any previous provision and build the VM
   ```
   make clean && make
   ```

## Vagrant Settings
The Vagrantfile configures the environment based on settings from `.vagrant.yml`,
with default values including:

- PLAYBOOK: `default`
   - Runs a `default` playbook that does nothing.
   - You can set this by an environmental variable with the same name.
- VAGRANT_BOX: `debian/bookworm64`
   - Current Debian Stable codename
- VAGRANT_CPUS: `2`
   - Threads or cores per node, depending on CPU architecture
- VAGRANT_MEM: `2048`
   - Specifies the amount of memory (in MB) allocated
- SSH_FORWARD: `false`
   - Enable this if you need to forward SSH agents to the Vagrant machine


## Copyright and License
Copyright (C) 2019-2023  Kris Lamoureux

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program. If not, see <https://www.gnu.org/licenses/>.
