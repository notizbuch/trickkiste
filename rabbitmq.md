#### basic rabbitmq commands
```
rabbitmqctl status
rabbitmqctl list_queues
```

#### make it easier to administrate through web ui
```
rabbitmq-plugins enable rabbitmq_management
http://192.168.1.1:15672/
```

#### add admin user "test" with password: password1
```
rabbitmqctl add_user test password1
rabbitmqctl set_user_tags test administrator
rabbitmqctl set_permissions -p / test ".*" ".*" ".*"
```

notes:
```
default config file location: /etc/rabbitmq/rabbitmq.conf (may not exist after installation)
listeners.tcp.other_ip   = 192.168.1.1:5672
loopback_users.guest = false
(makes it accessible from everywhere)

example producer/consumer script: https://en.wikipedia.org/wiki/RabbitMQ 

port 5672
settings stored in :
/var/lib/rabbitmq/mnesia
```
