
# prepare the database
mysql -u root -e "CREATE USER 'dashboard' IDENTIFIED BY 'BestPassword';"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS dashboard;"
mysql -u root -e "GRANT ALL PRIVILEGES ON dashboard.* TO 'dashboard';"
mysql -u root < init.sql