#!/bin/bash

#Description Enable Filebeat Module
#Author Ivan Ninichuck
#Version 12292019


#Designate which modules to enable
echo "Please enter which modules you would like to enable. Use a space between modules names."
echo
read modules
echo
echo "Please provide the configuration path."
read config 
echo "Thank You"

#Activate the designated modules
filebeat --path.config $config modules enable $modules
echo
echo "$modules have been activated. Please alter configurations found at $config/modules.d."

