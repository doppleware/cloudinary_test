#!/bin/bash
cd /opt/bitnami/apps/magento/htdocs
if [ "$Stage" = "GetInfo" ] 
then
  cat /var/log/syslog | grep -oP "(?<=password to ').*(?=')" | awk '{print "<span style=\"background-color: #FFFF00; color:black;\">Magento Password:"$1"</span>"}'
fi
if [ "$Stage" = "Install" ] 
then 
  sudo sed "s/<public-key>/$PUBLIC_KEY/g" -i auth.json.sample
  sudo sed "s/<private-key>/$PRIVATE_KEY/g" -i auth.json.sample
  sudo cp auth.json.sample auth.json  
  sudo composer require cloudinary/cloudinary:$PLUGIN_VERSION
  echo Installed cloudinary/cloudinary:"$PLUGIN_VERSION" 
fi
if [ "$Stage" = "Enable" ]
then 
  sudo ./bin/magento-cli module:enable Cloudinary_Cloudinary --clear-static-content
  echo Enabled plugin 
fi
if [ "$Stage" = "Refresh" ]
then 
  sudo ./bin/magento-cli setup:upgrade
  sudo ./bin/magento-cli setup:di:compile
  sudo ./bin/magento-cli setup:static-content:deploy
  sudo ./bin/magento-cli cache:clean
  sudo ./bin/magento-cli cache:flush	
  echo Refreshed, Compiled and cleaned Cache
fi

