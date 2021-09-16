#!/bin/bash

wrkDir=$1
tmpDir=$(mktemp -d)

touch "$tmpDir"/ip_addresses.txt

cat "$wrkDir"/*/failed_login_data.txt | awk 'match($0, /[a-zA-z]+ [0-9]+ [0-9]+ [a-zA-Z0-9]+ ([0-9\.]+)/, groups) {print groups[1]}' >> "$tmpDir"/ip_addresses.txt

touch "$tmpDir"/countCountries.txt

sort "$tmpDir"/ip_addresses.txt | join | uniq -c -f 7 | awk 'match($0, /([0-9]+) [0-9\.]+ ([a-zA-Z]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);"}' >> "$tmpDir"/countCountries.txt

bin/wrap_contents.sh "$tmpDir"/countCountries.txt html_components/country_dist "$wrkDir"/country_dist.html
