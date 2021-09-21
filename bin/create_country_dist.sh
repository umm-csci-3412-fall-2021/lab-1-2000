#!/bin/bash

# This argument takes in a directory specified by the user, which will be used for creating the country distribution.
wrkDir=$1

# This variable stores a temporary directory for completing most of the work in.
tmpDir=$(mktemp -d)

# A text document that will store the IP addresses of the user logs will be created in the temporary directory.
touch "$tmpDir"/ip_addresses.txt

# Here, the IP addresses are read from failed_login_data.txt and placed into ip_addresses.txt. 
cat "$wrkDir"/*/failed_login_data.txt | awk 'match($0, /[a-zA-z]+ [0-9]+ [0-9]+ [\-\_a-zA-Z0-9]+ ([0-9\.]+)/, groups) {print groups[1]}' >> "$tmpDir"/ip_addresses.txt

# A text document is created for storing the country data.
touch "$tmpDir"/countCountries.txt

# Here, ip_addresses.txt and country_IP_map.txt are merged together. Then, the countries are grabbed and counted for each unique instance, before the data is then added to countCountries.txt.
join <(sort "$tmpDir"/ip_addresses.txt) <(sort ./etc/country_IP_map.txt) | awk '{print $2;}' | sort | uniq -c | awk 'match($0, /([0-9]+) ([a-zA-Z]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);"}' >> "$tmpDir"/countCountries.txt

# If country_dist.html (the file for storing the country distribution), has not been created yet, it will be created here.
touch "$wrkDir"/country_dist.html

# The contents of countCountries.txt are wrapped with the header and footers of country_dist, before then being put into country_dist.html to display the distribution.
bin/wrap_contents.sh "$tmpDir"/countCountries.txt html_components/country_dist "$wrkDir"/country_dist.html
