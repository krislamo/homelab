# Homelab
This repository contains Ansible to automate Debian GNU/Linux servers, deploying
server technologies that are either useful in a personal capacity or provide
educational value on automating enterprise infrastructure.

Development is accomplished using Vagrant to allow easy reproducibility in an
isolated virtual environment that be ran on your local machine.

## Quick Start
These steps assume a basic understanding of GNU/Linux, Hypervisors, Vagrant, and Ansible.

### Prerequisites
- [Vagrant](https://developer.hashicorp.com/vagrant/docs/installation)
- [Supported hypervisor](https://developer.hashicorp.com/vagrant/docs/providers)
- Ansible

### Installation

1. Clone this repository
   ```
   git clone https://git.krislamo.org/kris/homelab
   ```
   OR download from the mirror on GitHub:
   ```
   git clone https://github.com/krislamo/homelab
   ```

2. Find available playbooks for development
   ```
   cd homelab
   ```
   ```
   find dev -maxdepth 1 -name "*.yml" -exec basename {} .yml \;
   ```

3. Set the `PLAYBOOK` environmental variable to a value listed in the last step, e.g.,
   ```
   export PLAYBOOK=dockerbox
   ```
3. Bring the Vagrant box up
   ```
   vagrant up
   ```

#### Copyright and License
Copyright (C) 2020-2022  Kris Lamoureux

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
