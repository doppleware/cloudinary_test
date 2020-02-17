 cd /opt/bitnami/apps/magento/htdocs
 sudo sed 's/<public-key>/$PUBLIC_KEY/g' -i auth.json.sample
 sudo sed 's/<private-key>/$PRIVATE_KEY/g' -i auth.json.sample
 sudo cp auth.json.sample auth.json
 sudo composer require cloudinary/cloudinary:$PLUGIN_VERSION
 cat /var/log/syslog | grep -oP "(?<=password to ').*(?=')"
