# Firewall Settings

## Allow ports for all

Allow following ports for global access.

```

# Allow following port for global access

-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 19999 -j ACCEPT

# Allow following port for selected access

-A INPUT -s 117.247.87.156/24 -j ACCEPT
-A INPUT -s 78.129.239.99/24 -j ACCEPT
-A INPUT -s 137.59.230.241/24 -j ACCEPT
-A INPUT -s 110.39.187.46/24 -j ACCEPT
  
```

## Restart and check 

```
sudo service iptable restart
sudo iptables -S
```