-- script for creating the STAMPIT database users --
FLUSH PRIVILEGES;
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'test';
GRANT SELECT, INSERT, UPDATE, DELETE ON STAMPIT.* TO 'app_user'@'localhost';
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'test';
GRANT ALL ON STAMPIT.* TO 'admin_user'@'localhost';