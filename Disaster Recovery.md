# Disaster Recovery Manual

In an event/disaster where Master Database Server can't be accessed, down, or deleted we need to promote a Slave Server into a Master Server to minimize down time

In this step by step case, we have 3 Database Server. 1 Master(Server A) and 2 Slave(Server B and Server C). Server A is currently down and we want to promote Server B from Slave Server into Master Server

![image](https://user-images.githubusercontent.com/67664879/212128421-aba57700-a20d-4a48-bfad-f518fbe1eeaf.png)


## Step 1
SSH into Server B 
```
ssh ubuntu@server-b-ip
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
If want other slave server to still run replication, you can point them to your new master server
In your new Master Server(Server B), run this

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

SSH into your other Slave Server(Server C)
```
ssh ubuntu@server-c-ip
```

## Step 7
Login into MySQL
```
sudo mysql -u root
```

If you configure root with password, enter this instead
```
sudo mysql -u root -p
```

## Step 8
Stop and reset slave replication
```
stop slave;
reset slave;
```

## Step 9
Run this query, change the variable into what you note before
```
CHANGE MASTER TO MASTER_HOST = '<your new master server ip>', MASTER_USER = '<replication user>', MASTER_PASSWORD = '<replication password>', MASTER_LOG_FILE = '<your master log file>', MASTER_LOG_POS = <your master log position>;
```

## Step 10
Run replication with this query
```
start slave;
```

Repeat step 6 - 10 for each of your slave server
