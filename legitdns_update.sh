#!/bin/bash

#####################################################
## LegitDNS.com - Free Domains for your projects   ##
#####################################################
## To sign up for free, please go to legitdns.com  ##
## Some free RaspberryPi focused domains include:  ##
## piHPC.com, piShell.com, piBase.net, and others! ##
#####################################################

#####################################################
## Please enter your domain and secret token below ##
#####################################################
legitdns_domain="domain.pishell.net"
legitdns_secret_token="d16e72f6-2d1c-a9f1-8f2d-6664db186063"


#####################################################
############ DO NOT EDIT BELOW THIS LINE ############
#####################################################

legitdns_temp_file="/tmp/.legitdns_lock_file"
legitdns_update_window=600


## Check dependencies:
command -v dig >/dev/null 2>&1 || { echo "LegitDNS updater requires dig, but it's not installed.  Exiting." >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "LegitDNS updater requires curl, but it's not installed.  Exiting." >&2; exit 1; }


if [ -e $legitdns_temp_file ];
then
 time_last_checked=$(stat -c %Y $legitdns_temp_file)
else
 echo "INFO: Lockfile does not exist. Creating at $legitdns_temp_file"
 touch $legitdns_temp_file
 time_last_checked=0
fi

time_right_now=$(date +%s)

time_difference=$(expr $time_right_now - $time_last_checked)

if [ $time_difference -gt $legitdns_update_window ]
then
 current_domain_resolution=$(dig +short $legitdns_domain)
 current_ip_address=$(curl -s https://api.ipify.org)
 
 if [ "$current_domain_resolution" != "$current_ip_address" ];
 then
  echo "INFO: Your domain is being updated to reflect your new IP address, $current_ip_address"   
  legitdns_update_url="http://www.legitdns.com/api/v0/update.php?domain=$legitdns_domain&token=$legitdns_secret_token"
  legitdns_update=$(curl -s $legitdns_update_url)
  if [[ $legitdns_update =~ .*SUCCESS.* ]]
   then
    echo "INFO: Successfully update your domain"
    touch $legitdns_temp_file
   else
    echo "ERROR: Failed to update your domain. Here's the error:"
    echo $legitdns_update
  fi

 else
  touch $legitdns_temp_file
  echo "INFO: No update necessary. Domain still resolves to your IP address."   
 fi

 else
  echo "ERROR: There must be at least $(expr $legitdns_update_window / 60) minutes between requests to update your IP address. This small window reduces abuse and ensures the availability of our services. Most ISPs will not update your IP address greater than once an hour. It is against the LegitDNS Terms of Service to submit an excessive amount of IP address update requests."
  echo ""
  echo ""
  echo "If this is an error, please delete the lock file located at: $legitdns_temp_file" 
fi
