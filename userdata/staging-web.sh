#!/bin/bash


environment = {
  DOMAIN_NAME = jsondecode(data.aws_secretsmanager_secret_version.domain_name.secret_string)["domain_name"]
  DEMO_USERNAME = jsondecode(data.aws_secretsmanager_secret_version.demo_username.secret_string)["demo_username"]
  DEMO_PASSWORD = jsondecode(data.aws_secretsmanager_secret_version.demo_password.secret_string)["demo_password"]
  DEMO_EMAIL = jsondecode(data.aws_secretsmanager_secret_version.demo_email.secret_string)["demo_email"]
  db_name = jsondecode(data.aws_secretsmanager_secret_version.db_name.secret_string)["db_name"]
  db_username = jsondecode(data.aws_secretsmanager_secret_version.db_username.secret_string)["db_username"]
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_password.secret_string)["db_password"]
}

mkdir -p /var/www/html/
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_id}.efs.${region}.amazonaws.com:/ /var/www/html/
yum install -y amazon-efs-utils
echo '${efs_id}.efs.${region}.amazonaws.com:/ /var/www/html/ efs defaults,_netdev 0 0' >> /etc/fstab

yum install -y httpd
systemctl start httpd
systemctl enable httpd
yum clean metadata
yum install -y php php-cli php-pdo php-fpm php-json php-mysqlnd php-dom

if [ ! -f /var/www/html/wp-config.php ]; then
# Si es la primera máquina, instala y configura wordpress, sino ya esta hecho
wget -O wordpress.tar.gz https://wordpress.org/wordpress-6.2.2.tar.gz
tar -xzf wordpress.tar.gz
cd wordpress
cp wp-config-sample.php wp-config.php
sed -i "s/database_name_here/${db_name}/g" wp-config.php
sed -i "s/username_here/${db_username}/g" wp-config.php
sed -i "s/password_here/${db_password}/g" wp-config.php
sed -i "s/localhost/${db_host}/g" wp-config.php
SALT=$(curl -L https://api.wordpress.org/secret-key/1.1/salt/)
STRING='soyuncopodenieveunico'
printf '%s\n' "g/$STRING/d" a "$SALT" . w | ed -s wp-config.php
cd ..
cp -r wordpress/* /var/www/html/
# WP CLI Install
wget -O wp-cli.phar https://github.com/wp-cli/wp-cli/releases/download/v2.8.1/wp-cli-2.8.1.phar
php wp-cli.phar --info
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
# Setup WordPress
wp --path=/var/www/html core install --allow-root \
  --url="https://${DOMAIN_NAME}" \
  --title="Terraform en AWS" \
  --admin_user="${DEMO_USERNAME}" \
  --admin_password="${DEMO_PASSWORD}" \
  --admin_email="${DEMO_EMAIL}"

fi

chown -R apache:apache /var/www/
systemctl restart httpd

