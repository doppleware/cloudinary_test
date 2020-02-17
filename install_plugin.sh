#!/bin/bash -x
set -e
cat /var/log/syslog | grep -oP "(?<=password to ').*(?=')"
cd /opt/bitnami/apps/magento/htdocs
if [ "$PUBLIC_KEY"="init" ]; then echo here; fi
sudo sed "s/<public-key>/$PUBLIC_KEY/g" -i auth.json.sample
sudo sed "s/<private-key>/$PRIVATE_KEY/g" -i auth.json.sample
sudo cp auth.json.sample auth.json
echo Updated keys: $?
sudo composer require cloudinary/cloudinary:$PLUGIN_VERSION
echo Installed module: $?
sudo ./bin/magento-cli module:enable Cloudinary_Cloudinary --clear-static-content
echo Enabled module: $?
sudo ./bin/magento-cli setup:upgrade
echo Setup upgrade: $?
sudo ./bin/magento-cli setup:di:compile
echo Setup compile: $?
sudo ./bin/magento-cli cache:clean
echo Clean cache: $?
