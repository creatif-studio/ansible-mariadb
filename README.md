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

<!-- 
# Requirements
- Ansible: automation for server configuration and installation of mariadb
- Vagrant: create local vm with ubuntu server 20.04
- MariaDB: setup mariadb cluster with ansible (master-master)

# This tasks should be finish in 24 hours
# You should present the result -->

```
project-name/
├── ansible/
│   ├── files/
│   │   ├── [file1]              # any files needed to be copied to the remote host
│   │   └── [file2]
│   ├── group_vars/
│   │   ├── [group1]             # group-specific variables
│   │   └── [group2]
│   ├── templates/
│   │   ├── [template1]          # Jinja2 templates
│   │   └── [template2]
│   ├── tasks/
│   │   ├── [task1]              # Ansible tasks
│   │   └── [task2]
│   ├── roles/
│   │   ├── single/
│   │   │   ├── tasks/
│   │   │   │   ├── [task1]       # tasks related to single MySQL installation
│   │   │   │   └── [task2]
│   │   │   ├── vars/
│   │   │   │   ├── [var1]         # vars related to single MySQL installation
│   │   │   │   └── [var2]
│   │   │   ├── templates/
│   │   │   │   ├── [template1]    # templates related to single MySQL installation
│   │   │   │   └── [template2]
│   │   │   └── files/
│   │   │       ├── [file1]        # files related to single MySQL installation
│   │   │       └── [file2]
│   │   └── cluster/
│   │       ├── tasks/
│   │       │   ├── [task1]       # tasks related to cluster MySQL installation
│   │       │   └── [task2]
│   │       ├── vars/
│   │       │   ├── [var1]         # vars related to cluster MySQL installation
│   │       │   └── [var2]
│   │       ├── templates/
│   │       │   ├── [template1]    # templates related to cluster MySQL installation
│   │       │   └── [template2]
│   │       └── files/
│   │           ├── [file1]        # files related to cluster MySQL installation
│   │           └── [file2]
├── terraform/
│   ├── environments/
│   │   ├── [environment1]       # environment-specific variables
│   │   └── [environment2]
│   ├── modules/
│   │   ├── [module1]            # Terraform modules
│   │   └── [module2]
│   ├── providers/
│   │   ├── [provider1]          # provider-specific configuration
│   │   └── [provider2]
│   ├── scripts/
│   │   ├── [script1]            # any scripts used in Terraform
│   │   └── [script
│   ├── main.tf                  # Terraform main configuration file
│   └── aws/
│       ├── [config1]             # Terraform AWS-specific configuration
│       └── [config2]
├── vagrant/
│   ├── boxes/
│   │   ├── [box1]               # Vagrant boxes
│   │   └── [box2]
│   ├── scripts/
│   │   ├── [script1]            # any scripts used in Vagrant
│   │   └── [script2]
│   ├── Vagrantfile              # Vagrant main configuration file
│   └── virtualbox/
│       ├── [config1]             # Vagrant VirtualBox-specific configuration
│       └── [config2]
├── bash/
│   ├── development/
│   │   ├── [script1]            # development-related bash scripts
│   │   └── [script2]
│   └── production/
│       ├── [script1]             # production-related bash scripts
│       └── [script2]
├── mysql/
│   ├── [package1]                # MySQL install package
│   ├── [config1]                 # MySQL config files
│   └── [relatedfile1]           # other related MySQL files
├── logs/
│   ├── [log1]                    # logs generated during installation process
│   └── [log2]
└── doc/
    ├── [doc1]                     # documentation of installation process and setup
    └── [doc2]
```
