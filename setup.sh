#!/bin/bash

clear
echo "Welcome to MariaDB installation script with Ansible"
echo "Before starting, please check the associated inventory-*.ini to make sure you have entered your server ip address accordingly"
echo "Please select installation mode"
echo ""
echo "1.Single Master Server Configuration"
echo "2.Single Master Multiple Slave Configuration"
echo "3.Multiple Master Configuration"
echo "4.Exit"
echo ""
echo -n "Enter your selection > " 
read -r choice

if [[ $choice == 1 ]]; then
    echo "1"
    ansible-playbook -i inventory.ini mariadb-single.yml
elif [[ $choice == 2 ]]; then
    echo "2"
    ansible-playbook -i inventory.ini mariadb-master-slave.yml
elif [[ $choice == 3 ]]; then
    echo "3"
    ansible-playbook -i inventory.ini mariadb-multimaster.yml
fi