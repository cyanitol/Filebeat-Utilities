#!/bin/bash

#Description: Provisions a separate filebeat service utilizing tag separation
#Author: Ivan Ninichuck
#Version: 12192019

#Obtain tag to be used
echo "Enter customer_tag, please: "
read customer_tag
echo
echo  "Thank You"

#Create Config Folder
echo -n "Processing New Files"
echo
cp -r filebeat $customer_tag-filebeat
mv $customer_tag-filebeat /etc

#Create Data and Log Folders
cp -r /var/lib/filebeat /var/lib/$customer_tag-filebeat
mkdir /var/log/$customer_tag-filebeat

#Create new Service using Systemd
cp filebeat.service $customer_tag-filebeat.service
sed -i "s/tag/$customer_tag/g" $customer_tag-filebeat.service
mv $customer_tag-filebeat.service /lib/systemd/system

echo -n "Creating Filebeat Keystore"
echo
filebeat --path.config /etc/$customer_tag-filebeat --path.data /var/lib/$customer_tag-filebeat keystore create
filebeat --path.config /etc/$customer_tag-filebeat --path.data /var/lib/$customer_tag-filebeat keystore add customer_tag
filebeat --path.config /etc/$customer_tag-filebeat --path.data /var/lib/$customer_tag-filebeat keystore add es_host
filebeat --path.config /etc/$customer_tag-filebeat --path.data /var/lib/$customer_tag-filebeat keystore add es_user
filebeat --path.config /etc/$customer_tag-filebeat --path.data /var/lib/$customer_tag-filebeat keystore add es_pwd

#Uncomment Variables in filebeat.yml
sed -i "s/#setup.template/setup.template/g" /etc/$customer_tag-filebeat/filebeat.yml
sed -i "s/#es/es/g" /etc/$customer_tag-filebeat/filebeat.yml


echo -n "$customer_tag-filebeat instance is ready for operation"
echo
