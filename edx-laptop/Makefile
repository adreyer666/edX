#!/usr/bin/env make

  BUILD = default
VERSION := $(shell cat .version)

    DIR := $(shell pwd)
   NAME := $(shell basename $(DIR))
  IMAGE = $(NAME)_$(BUILD)

build:
	vagrant up --provider=libvirt
	mkdir -p ~/.ssh/config.d
	vagrant ssh-config --host $(NAME) >> ~/.ssh/config.d/$(NAME).conf
	ssh -X $(NAME)

run:
	virsh start $(IMAGE)
	#ssh -X $(NAME)

pause:
	virsh managedsave $(IMAGE)

clean:
	-rm ~/.ssh/config.d/$(NAME).conf
	-virsh destroy $(IMAGE)
	-vagrant destroy -f
	-virsh undefine $(IMAGE)

