# legitDNS bash script update service 

Automatically update your [legitDNS.com](https://www.legitdns.com) domain with this short script.

## Installation

```shell

# Use git to download this script 
git clone https://github.com/legitdns/domain_updater.git

# enter the directory
cd domain_updater

# Edit the script to include your domain and account token
nano -w legitdns_update.sh

# After reviewing the code, mark the script as executable
chmod +x legitdns_update.sh

# Identify the full path of this file
realpath legitdns_update.sh
# (output would be something like  "/home/user/domain_updater/legitdns_update.sh")

# Edit your crontab file, which contains programs that automatically run at certain times
crontab -e

# Add a new line to your crontab to include the legitdns_update.sh file:
# This line will check for updates every 10 minutes
*/10 * * * * /home/user/domain_updater/legitdns_update.sh

# Save your crontab file, and exit the editor. Wait about 10 minutes and ping your domain to see if the update was successful.
ping -c5 YOUR_DOMAIN.pishell.net
