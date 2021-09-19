#!/bin/bash

wrkDir=$1
tmpDir=$(mktemp -d)

touch "$tmpDir"/hours.txt

cat "$wrkDir"/*/failed_login_data.txt | awk 'match($0, /[a-zA-z]+ [0-9]+ ([0-9]+) /, groups) {print groups[1]}' >> "$tmpDir"/hours.txt

touch "$tmpDir"/countHours.txt

sort "$tmpDir"/hours.txt | uniq -c | awk 'match($0, /([0-9]+) ([0-9]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);"}' >> "$tmpDir"/countHours.txt

touch "$wrkDir"/hours_dist.html

bin/wrap_contents.sh "$tmpDir"/countHours.txt html_components/hours_dist "$wrkDir"/hours_dist.html
