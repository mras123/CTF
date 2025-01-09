
# prepare the database
mysql -u root -e "CREATE USER 'secrets' IDENTIFIED BY 'BestPassword';"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS secrets;"
mysql -u root -e "GRANT ALL PRIVILEGES ON secrets.* TO 'secrets';"
mysql -u root < init.sql
