#!/usr/bin/env make

  BUILD = default
VERSION := $(shell cat .version)

    DIR := $(shell pwd)
   NAME := $(shell basename $(DIR))
  IMAGE = $(NAME)_$(BUILD)

build:
	vagrant up --provider=libvirt
	vagrant reload  ## to ensure updated kernels and packages are loaded
	mkdir -p ~/.ssh/config.d
	vagrant ssh-config --host $(NAME) >> ~/.ssh/config.d/$(NAME).conf
	ssh -X $(NAME)

run:
	virsh start $(IMAGE) || vagrant up
	#ssh -X $(NAME)

stop:
	virsh destroy $(IMAGE) || vagrant halt

pause:
	virsh managedsave $(IMAGE)

clean:
	-rm ~/.ssh/config.d/$(NAME).conf
	-virsh destroy $(IMAGE)
	-vagrant halt
	-vagrant destroy -f
	-virsh undefine $(IMAGE)

