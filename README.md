# PiHole Blocklist Aggregator

This script aggregates multiple blocklists for PiHole from internet and local sources into a single file.

## Requirements
This script needs to run on a Linux machine with a webserver. It also requires internet access to download blocklists from external webservers.
The following commands must be available on your server: wget, grep, sed, sort, uniq

## Files

### update.sh
This file contains the logic which creates the aggregated blocklist file and copies it into your webserver's directory.
You may need to change the configuration section to reflect your environment.

Those variables need to be set correctly:
 - basepath: the full path to the folder where this script is located
 - target: the target folder within your webserver
 - targetfile: the filename of the aggregated blocklist file

### inet-urls.list
This file contains the blocklists which should be downloaded from the internet. One URL per line. You can find example blocklists already in it.

### white.list
This file contains domains which should never be in the aggregated blocklist. One domain per line. You can find a few domains which normally should not be blocked already in it.

### Folder: raw-local
This folder contains multiple _.list_ files which contain domains which should be in the aggregated blocklist. One domain per line. You can find two example blocklists already in it.

## Installation

 1. Install a webserver (e.g. lighttpd, Apache httpd or NGINX) on your Linux server (e.g. your PiHole machine).
 2. Clone this repository into a folder of your choice (default: _/opt/blocklistaggregator_).
 3. Configure the script in the files listed above.
 4. Add execution rights to update.sh (_chmod +x update.sh_).
 5. Add the output file to your PiHole blocklists (e.g. http://127.0.0.1/block.list)
 6. Run _update.sh_ and _pihole -g_ regularily (e.g. via Cronjob) to ensure you're always up-to-date.
