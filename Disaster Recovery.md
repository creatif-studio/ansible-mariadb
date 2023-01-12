# Disaster Recovery Manual

In an event/disaster where Master Database Server can't be accessed, down, or deleted we need to promote a Slave Server into a Master Server to minimize down time

## Step 1
SSH into one of your Slave Server you want to promote into Master Server 
```
ssh ubuntu@slave-server-ip
```

## Step 2
Login into MySQL
```
sudo mysql -u root
```

If you configure root with password, enter this instead
```
sudo mysql -u root -p
```

## Step 3
Stop and reset slave replication
```
stop slave;
reset slave;
```

## Step 4
By default, slave server still can write. But if you configure read only on slave server, enable write on server by adding/editing this line on `/etc/mysql/my.cnf`
```
[mysqld]
read-only = 0
```

Or run this query on mysql
```
SET read_only false;
```

Your new master server is now ready

## Step 5(and so on is optional)
If you have other slave server, you can point them to your new master server
In your new Master Server, run this

```
SHOW MASTER STATUS;
```

You will get something like this
```
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      786 |              |                  |
+------------------+----------+--------------+------------------+
```
Note down the `File`, `Position`, and your server IP

## Step 6

SSH into your other Slave Server
```
ssh ubuntu@other-slave-server-ip
```

## Step 7
Stop and reset slave replication
```
stop slave;
reset slave;
```

## Step 8
Run this query, change the variable into what you note before
```
CHANGE MASTER TO MASTER_HOST = '<your new master server ip>', MASTER_USER = '<replication user>', MASTER_PASSWORD = '<replication password>', MASTER_LOG_FILE = '<your master log file>', MASTER_LOG_POS = <your master log position>;
```

Repeat step 6 - 8 for each of your slave server