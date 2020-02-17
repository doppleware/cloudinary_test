#!/bin/bash -x
set -e
cat /var/log/syslog | grep -oP "(?<=password to ').*(?=')"
cd /opt/bitnami/apps/magento/htdocs
sudo sed 's/<public-key>/$PUBLIC_KEY/g' -i auth.json.sample
sudo sed 's/<private-key>/$PRIVATE_KEY/g' -i auth.json.sample
sudo cp auth.json.sample auth.json
sudo composer require cloudinary/cloudinary:$PLUGIN_VERSION
sudo ./bin/magento-cli module:enable Cloudinary_Cloudinary --clear-static-content
sudo ./bin/magento-cli setup:upgrade
sudo ./bin/magento-cli setup:di:compile
sudo ./bin/magento-cli cache:clean
