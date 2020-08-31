# edX
Virtual environment for course studies on edx.org .

*[edX](https://www.edx.org/)* is an open online course provider created by Harvard and MIT. It hosts online university-level courses in a wide range of disciplines to a worldwide student body, including some courses at no charge. It also conducts research into learning based on how people use its platform. edX is a nonprofit organization and runs on the free Open edX open-source software platform.

## Instance: edx-laptop
This virtual environment was developed to be used while following:
* [MITx: 6.00.1x - Introduction to Computer Science and Programming Using Python](https://courses.edx.org/courses/course-v1:MITx+6.00.1x+2T2020a/)

Additional changes are planned to accomodate:
* [LFS151x: Introduction to Cloud Infrastructure Technologies](https://courses.edx.org/courses/course-v1:LinuxFoundationX+LFS151.x+2T2020/)
* [LFS158x: Introduction to Kubernetes](https://courses.edx.org/courses/course-v1:LinuxFoundationX+LFS158x+2T2019/)


### Anaconda
Anaconda is a package manager, an environment manager, a Python/R data science distribution, and a collection of over 7,500+ open-source packages. Anaconda is free and easy to install, and it offers free community support.
The `Anaconda Navigator` provides a dashboard to start the main applications.

### Prerequisites
A system with:
* `libvirt`/`qemu-kvm` installed
* `vagrant` installed
* able to serve NFS shares

If you are using a different virtualisation platform you might be able to tweak the `Vagrantfile` for your environment.

### Preparation

### Installation
1. `git clone` this repo
2. `cd edx-laptop; make`
3. `virt-viewer edx-laptop_default`
   - login:  `student`
   - password: `study!`
4. Pause/Resume:
   - If you want to pause the virtual environment: `make pause`
   - To resume run: `make run`

* Make sure you use the `workspace` directory for any work that you want preserved.
  Changes in the `workspace` will be saved on the host system, so should survive a virtual system rebuild (`make clean; make`).


## Data: edx-workspace
This directory serves as persistent storage for the edx-laptop instance.

---

## Instance: openstack
This virtual machine environment is for [LFS151.x (Introduction to Cloud Infrastructure Technologies)](https://courses.edx.org/courses/course-v1:LinuxFoundationX+LFS151.x+2T2020/course/), Course Chapter 2. - Infrastructure as a Service (IaaS) OpenStack Demo: Deploying an Instance with OpenStack.

The installation is based on [DevStack](https://docs.openstack.org/devstack/latest/).

### Installation
1. `git clone` this repo
2. `cd openstack; make`
3. `ssh openstack`
4. Pause/Resume:
   - If you want to pause the virtual environment: `make pause`
   - To resume run: `make run`

### (Web-)UI
* Horizon should be available at `http://<ip>/dashboard`
* Keystone should be serving at `http://<ip>/identity/`
- default users are: `admin` and `demo`
- default password: `secret`

---


