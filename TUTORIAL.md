# Domino on Vagrant tutorial

Here is a step by step guide to run the [Domino on Vagrant](https://github.com/beeman/domino-on-vagrant) project.

## Requirements

It is assumed that you have [VirtualBox]() and [Vagrant]() running on a Mac or Linux machine. The procedure will be more or less the same for Windows and a specific tutorial might be provided in the future.

Next to that you need to download the Domino server software you want to install. I got the **IBM Domino Enterprise Server V9.0.1 Social Edition Multiplatform English Trial eAssembly Version  9.0.1**. If you don't have the software you can [request a trial version here](http://www.ibm.com/developerworks/downloads/ls/lsds/index.html)

The file that I downloaded is called *DOMI_SRV_901_LIN_XS64_EN_-TRIAL.tar*  and located in my *~/Downloads* directory. I will use this location in the examples below, please replace this to your specific location and name.

## Installation

The following steps are needed to get up and running with Domino on Vagrant.

### Install a Vagrant plugin (first time only!)

This plugin takes care of automagically updating the VirtualBox Guest Additions. The CentOS 6 image needs this to run correctly.

    $ vagrant plugin install vagrant-vbguest

### Create and enter the working directory

    $ mkdir dov-demo
    $ cd dov-demo

### Download the Domino on Vagrant project files

    $ git clone https://github.com/beeman/domino-on-vagrant.git

### Unpack the downloaded Domino installation files

    $ cd domino-on-vagrant
    $ cd data
    $ tar xvf ~/Downloads/DOMI_SRV_901_LIN_XS64_EN_-TRIAL.tar
    $ cd ..

### Run the virtual machine

After running this command the system will be installed and configured.

    $ vagrant up

Vagrant downloads a base image based on 64bit CentOS 6. The download will be stored on your system so it will only do this one time.

After downloading this it will start the virtual machine and run some scripts. The plugin that we installed in the first step will be invoked to update the *VirtualBox Guest Additions*.

When the base installation is finished the Domino server will be installed and configured. The output of all this should be visible in the terminal where you ran the above command.


## Default settings

When the machine is installed you should be able to connect to Domino using a Notes Client, Domino Designer/Administrator or by using a browser. We will mention some of the default settings here. See the Configuration section below to change these defaults.

### Network configuration

    IP address : 10.2.2.2
    hostname   : dov
    domain     : domino.dev

### Credentials

#### Operation System

The user in the linux guest has the following credentials. This is main user of the guest and it is running the Domino server too.

    username   : vagrant
    group      : vagrant

#### Domino

To login on the Domino environment you need to use the following credentials

    username   : admin/dominodev
    password   : dominodev
    id file    : notesdata/admin.id

    
## Usage


### Starting / Stopping the guest

    $ cd dov-demo/domino-on-vagrant
    $ vagrant up    # this starts your guest
    $ vagrant halt  # this stops your guest

For more commands run ```vagrant --help```

### Login to this virtual machine using vagrant (easiest way)

    $ cd dov-demo/domino-on-vagrant
    $ vagrant ssh

### Login to this virtual machine using SSH

    $ ssh vagrant@10.2.2.2   # default password: vagrant

### Sharing files

The directory ```domino-on-vagrant``` is shared inside the guest OS. You can find it mounted to ```/vagrant```.

Next to that the data there is a folder called ```notesdata``` on your host that is mounted at ```/local/notesdata```

### WebAdmin

A lot of admin functionality is available through webadmin.nsf. The tool can be found on one of the following links, depending on the DNS configuration (see section on hostnames below)

* http://dov.domino.dev/webadmin.nsf
* http://10.2.2.2/webadmin.nsf
* http://dov/webadmin.nsf

I use the webadmin to get the ID file of the admin user, because I don't know a quicker way :)

### Hostnames

You can easily access the guest by entering it to your hosts file

    10.2.2.2 dov dov.domino.dev

Another option is to install a tool like dnsmasq that can locally point the domain domino.dev to the IP address of the server. Check [this page](http://passingcuriosity.com/2013/dnsmasq-dev-osx/) to get you started.


### Domino

You can start / stop the Domino server from inside the guest.

    sudo /etc/init.d/rc_domino start # / stop

You can even enter an interactive console monitor!

    sudo /etc/init.d/rc_domino monitor

## Configuration

### Network

The hostname, domain and IP address are defined in the ```Vagrantfile```

### GUI

By default the VirtualBox console to this server is hidden. Most of the time this is perfectly fine because you interact with the server by other means, for instance ```vagrant ssh```


## TL;DR Installation

Because sometimes you're in a hurry...

    vagrant plugin install vagrant-vbguest
    mkdir dov-demo
    cd dov-demo
    git clone https://github.com/beeman/domino-on-vagrant.git
    cd domino-on-vagrant
    cd data
    tar xvf ~/Downloads/DOMI_SRV_901_LIN_XS64_EN_-TRIAL.tar
    cd ..
    vagrant up
