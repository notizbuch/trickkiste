#### create user with all access

```
CREATE USER 'user1'@'%' IDENTIFIED BY 'password1';
GRANT ALL PRIVILEGES ON *.* TO 'user1'@'%' WITH GRANT OPTION;
```

#### create user with some access
```
CREATE USER 'user2'@'%' IDENTIFIED BY 'password2’;
GRANT INDEX, CREATE, SELECT, INSERT, UPDATE, DELETE, ALTER, LOCK TABLES ON *.* TO 'user2'@'%' IDENTIFIED BY 'password2';
```
