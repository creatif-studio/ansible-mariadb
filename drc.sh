#!/bin/bash

# Variables
slave1_host="slave1_host"
slave1_username="slave1_username"
slave1_password="slave1_password"
slave2_host="slave2_host"
slave2_username="slave2_username"
slave2_password="slave2_password"

# Stop the replication process on both slaves
mysql -h $slave1_host -u $slave1_username -p$slave1_password -e "STOP SLAVE;"
mysql -h $slave2_host -u $slave2_username -p$slave2_password -e "STOP SLAVE;"

# Reset the master logs on both slaves
mysql -h $slave1_host -u $slave1_username -p$slave1_password -e "RESET MASTER;"
mysql -h $slave2_host -u $slave2_username -p$slave2_password -e "RESET MASTER;"

# Choose one slave to be the new master
mysql -h $slave1_host -u $slave1_username -p$slave1_password -e "CHANGE MASTER TO MASTER_HOST='', MASTER_USER='', MASTER_PASSWORD='';"

# Start the replication process on the new master
mysql -h $slave1_host -u $slave1_username -p$slave1_password -e "START SLAVE;"

# Configure the other slave to replicate from the new master
mysql -h $slave2_host -u $slave2_username -p$slave2_password -e "CHANGE MASTER TO MASTER_HOST='$slave1_host', MASTER_USER='$slave1_username', MASTER_PASSWORD='$slave1_password';"

# Start the replication process on the second slave
mysql -h $slave2_host -u $slave2_username -p$slave2_password -e "START SLAVE;"
