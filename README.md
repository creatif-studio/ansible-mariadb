# MariaDB with Ansible

## Ansible
Script included in this repository :
- MariaDB Single Server
- MariaDB Master-Slave Replication
- MariaDB Multi-Master Replication

### BEFORE RUNNING SCRIPT
Before running this playbook, make sure you edit `inventory.ini` according to your server IP Address
```
[master] 
10.10.10.1

[slave]
10.10.10.2

[all:vars]
ansible_connection='ssh'
ansible_ssh_port='22'
ansible_user='vagrant'
ansible_ssh_private_key_file=/home/yuuzukatsu/.ssh/yzk
```
Put your wanna be Master Server ip address in \[master\] group and Slave Server in \[slave\] group
Also edit `ansible_user` into USER WITH SUDO ACCESS and `ansible_ssh_private_key_file` with your SSH Key. Or if you prefer authentication with password, replace `ansible_ssh_private_key_file` into `ansible_password = yoursecurepassword`

In each you will find 4 variable :
- root_password: yoursecurerootpassword
- db_username: newuser
- db_password: yoursecureuserpassword
- database: newdb

you can change those value into any you want

### How to Run Script
After editing `inventory.ini` you can run script with command `ansible-playbook -i inventory.ini playbook.yml` for example
```
ansible-playbook -i inventory.ini mariadb-multi-master.yml
```

If you haven't configured passwordless sudo for your user, you can add `-K` at the end of the command for example 
```
ansible-playbook -i inventory.ini mariadb-multi-master.yml -K
```

### Current Script Limitation
- Multi Master Script(mariadb-multi-master.yml) for now its recommended to start only 2 Master Server. If you add more than 2, the first server in \[master\] group will be the main point for all replication since every other master server will only point to the first server with this script configuration. You also need to edit `server_id = 2` in `/etc/mysql/my.cnf` into another number(EACH SERVER NEED TO HAVE UNIQUE SERVER_ID) other than 1 and 2.  And then run `start slave` in each of your extra Master Server

- Master Slave Script(mariadb-master-slave.yml) for now only support MAX 1 Master Server and MAX 1 Slave Server. If you add more than 1 server, only the first one in \[slave\] will run replication. You can run start the other slave by editting `server_id = 2` in `/etc/mysql/my.cnf` into another number(EACH SERVER NEED TO HAVE UNIQUE SERVER_ID) other than 1 and 2. And then run `start slave` in each of your extra Slave Server

- Script doesnt support IPv6 for replication

## Vagrant
The Vagrantfile included in this repository will create 2 `Ubuntu 20` instance named `ubuntu` and `ubuntu2` with SSH Key authentication.

To spawn instance, run `vagrant up`

You can ssh into instance with command `vagrant ssh <instance name>` for example
```
vagrant ssh ubuntu2
```

If you prefer to SSH via other app like OpenSSH, PuTTY, etc. you need to edit `Vagrantfile` on this line
```
config.vm.provision "shell", inline: <<-SHELL
    echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO+JyAQHdjnMLd6Hg5Pblet6L83Eetfu/ZeDoNlgPrr9 eddsa-key-20221230" >> /home/vagrant/.ssh/authorized_keys
  SHELL

```

edit the echo line with your Public SSH Key

To stop instance, run `vagrant halt <instance name>` for example
```
vagrant halt ubuntu2
```

To delete instance, run `vagrant destroy <instance name>` for example
```
vagrant destroy ubuntu2
```

## Contributing

If you'd like to contribute to this project, please follow these steps:

1.  Fork this repository.
2.  Create a branch for your changes.
3.  Make your changes and commit them to your branch.
4.  Push your branch to your forked repository.
5.  Open a pull request to merge your changes into the main repository.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
