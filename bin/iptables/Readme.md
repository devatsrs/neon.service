# Firewall Settings

## Allow ports for all

Allow following ports for global access.

```

# Allow following port for global access

-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 19999 -j ACCEPT

# Allow all ports for selected ips

-A INPUT -s {IP_ADDRESS_1}/24 -j ACCEPT
-A INPUT -s {IP_ADDRESS_2}/24 -j ACCEPT
-A INPUT -s {IP_ADDRESS_3}/24 -j ACCEPT
-A INPUT -s {IP_ADDRESS_4}/24 -j ACCEPT
  
```

## Restart and check

```
sudo service iptable restart
sudo iptables -S
```