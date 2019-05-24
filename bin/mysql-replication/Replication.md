# Mysql replication

Its Master - Master mysql replication done with 2 different mysql server.

When 1st server is doing insert/update/delete operation, 2nd server will work as slave and vice versa.

Both server will interconnect to each other so any change on one server will replicate to another server.
  
in case of one server down 2nd server can be used, and once 1st server up it will try to be in-sync with 2nd server coping 

all the changes which has been done during server down time.

Note: Its a mysql replication, its not a load balancer.

## Implemtation

For implemtation use following link.

<https://github.com/devatsrs/mysql-master-master-replication>
