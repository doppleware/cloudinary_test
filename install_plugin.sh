cat /var/log/syslog | grep -oP "(?<=password to ').*(?=')"
cd /opt/bitnami/apps/magento/htdocs
echo stage is: $Stage
if [[ "$Stage" == "Setup" ]] 
then 
  echo doing setup
  sudo sed "s/<public-key>/$PUBLIC_KEY/g" -i auth.json.sample
  sudo sed "s/<private-key>/$PRIVATE_KEY/g" -i auth.json.sample
  sudo cp auth.json.sample auth.json
fi
if [[ "$Stage" == "Install" ]]
then 
  echo doing install
  sudo composer require cloudinary/cloudinary:$PLUGIN_VERSION
  sudo ./bin/magento-cli module:enable Cloudinary_Cloudinary --clear-static-content
fi
if [[ "$Stage" == "Refresh" ]]
then 
  echo doing refresh!
  sudo ./bin/magento-cli setup:upgrade
  sudo ./bin/magento-cli setup:di:compile
  sudo ./bin/magento-cli cache:clean
fi

