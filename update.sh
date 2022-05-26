#!/bin/bash

# configuration section
basepath="/opt/blocklistaggregator"
target="/var/www/html"
targetfile="block.list"
# end configuration section

# make target dir for online lists
echo "Creating TEMP folder..."
rm -rf $basepath/raw-inet
mkdir $basepath/raw-inet

# download online lists
echo "Downloading blocklists..."
wget -i $basepath/inet-urls.list -P $basepath/raw-inet -q

# copy online lists into one list
echo "Merging downloaded blocklists..."
cat $basepath/raw-inet/* > $basepath/raw-inet.list

# copy local lists into one list
echo "Merging local blocklists..."
cat $basepath/raw-local/*.list > $basepath/raw-local.list

# remove whitelisted domains
echo "Removing whitelisted domains from aggregated blocklist..."
grep -Fvxf $basepath/white.list $basepath/raw-local.list > $basepath/block.list
grep -Fvxf $basepath/white.list $basepath/raw-inet.list >> $basepath/block.list

# remove comments
echo "Removing comments..."
sed -i -e 's/#.*$//g' $basepath/block.list

# remove empty lines
echo "Removing empty lines..."
sed -i '/^$/d' $basepath/block.list

# remove training spaces
echo "Removing trailing spaces..."
sed -i -e 's/[ \t]*$//g' $basepath/block.list

# remove null IP
echo "Removing NULL IPs..."
sed -i -e 's/^0\.0\.0\.0 //g' $basepath/block.list
sed -i -e 's/^0\.0\.0\.0//g' $basepath/block.list
sed -i -e 's/^127\.0\.0\.1 //g' $basepath/block.list

# sort blocklist
echo "Sorting output list..."
sort $basepath/block.list > $basepath/blocklist
mv $basepath/blocklist $basepath/block.list

# remove duplicate lines
echo "Removing duplicate lines..."
uniq $basepath/block.list > $basepath/blocklist
mv $basepath/blocklist $basepath/block.list

# remove temporary files
echo "Remove TEMP folder and files..."
rm $basepath/raw-inet.list
rm $basepath/raw-local.list
rm -rf $basepath/raw-inet

# move blocklist to www
echo "Updating repository..."
mv $basepath/block.list $target/$targetfile
chown www-data:www-data $target/$targetfile
