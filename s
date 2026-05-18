oot@ines-VM:/opt/zabbix-docker# ls -a
.  ..  docker-compose.yml  zabbix_db_data
root@ines-VM:/opt/zabbix-docker# cat docker-compose.yml 
version: '3.5'
services:
  # The Database (where Zabbix stores its data)
  zabbix-db:
    image: mysql:8.0
    environment:
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix_password
      - MYSQL_ROOT_PASSWORD=root_password
    volumes:
      - ./zabbix_db_data:/var/lib/mysql

  # The Zabbix Server
  zabbix-server:
    image: zabbix/zabbix-server-mysql:latest
    depends_on:
      - zabbix-db
    environment:
      - DB_SERVER_HOST=zabbix-db
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix_password
      - MYSQL_ROOT_PASSWORD=root_password
    ports:
      - "10051:10051"

  # The Web Interface (what you see in your browser)
  zabbix-web:
    image: zabbix/zabbix-web-nginx-mysql:latest
    depends_on:
      - zabbix-server
    ports:
      - "8080:8080"
    environment:
      - ZBX_SERVER_HOST=zabbix-server
      - DB_SERVER_HOST=zabbix-db
      - MYSQL_DATABASE=zabbix
      - MYSQL_USER=zabbix
      - MYSQL_PASSWORD=zabbix_password
root@ines-VM:/opt/zabbix-docker# 

