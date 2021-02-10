# Project Moxie

Project Moxie is a personal IT homelab project written in Ansible and executed by Jenkins. It is a growing collection of infrastructure as code (IaC) I write out of curiosity and for reference purposes, keeping a handful of beneficial projects managed and secured.

## Quick Start

To configure a local virtual machine for testing, follow these simple steps.

### Prerequisites

Vagrant and VirtualBox are used to develop Project Moxie. You will need to install these before continuing.

### Installation

1. Clone this repository
   ```
   git clone https://github.com/krislamo/moxie
   ```
2. Set the `PLAYBOOK` environmental variable to a development playbook name in the `dev/` directory

   The following `PLAYBOOK` names are available: `dockerbox`, `hypervisor`, `minecraft`, `moxie`, `nextcloud`, `nginx`

   ```
   export PLAYBOOK=dockerbox
   ```
3. Bring the Vagrant box up
   ```
   vagrant up
   ```

#### Copyright and License
Copyright (C) 2020-2021  Kris Lamoureux

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.
