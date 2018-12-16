# Vagrant

## Installation
1. [Virtual Box](https://www.virtualbox.org/wiki/Download_Old_Builds_5_1)
1. [Vagrant](https://www.vagrantup.com/downloads.html)

## Init
1. Init virtual machine
    ```bash
    vagrant init ubuntu/trusty64
    ```

1. Run virtual machine

    ```bash
    vagrant up
    ```

## VM management
1. **`vagrant status`** - get current status of the virtual machine
1. **`vagrant suspend`** - This command suspends your virtual machine. All of your work is saved and the machine is put into a “sleep mode” of sorts. The machines state is saved and it’s very quick to stop and start your work. You should use this command if you plan to just take a short break from your work but don’t want to leave the virtual machine running.
1. **`vagrant up`** - gets your virtual machine up and running again
1. **`vagrant ssh`** - ssh to virtual machine
1. **`vagrant halt`** - this command halts your virtual machine. All of your work is saved and the machine is turned off - think of this as “turning the power off”. It’s much slower to stop and start your virtual machine using this command, but it does free up all of your RAM once the machine has been stopped. You should use this command if you plan to take an extended break from your work, like when you are done for the day. The command vagrant up will turn your machine back on and you can continue your work.
1. **`vagrant destroy`** - this command destroys your virtual machine. Your work is not saved, the machine is turned off and forgotten about for the most part. Think of this as formatting the hard drive of a computer. You can always use vagrant up to relaunch the machine but you’ll be left with the baseline Linux installation.
