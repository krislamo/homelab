.PHONY: clean install

all: install

install:
	vagrant up --no-destroy-on-error
	sudo ./forward-ssh.sh

clean:
	vagrant destroy -f && rm -rf .vagrant
