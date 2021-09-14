#!/bin/bash

wrkDir=$1
tmpDir=$(mktemp -d)

touch "$tmpDir"/usernames.txt

cat "$wrkDir"/*/failed_login_data.txt | awk 'match($0, /[a-zA-z]+ [0-9]+ [0-9]+ ([a-zA-Z0-9]+)/, groups) {print groups[1]}' >> "$tmpDir"/usernames.txt

touch "$tmpDir"/countNames.txt

sort "$tmpDir"/usernames.txt | uniq -c | awk 'match($0, /([0-9]+) ([a-zA-Z0-9]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);"}' >> "$tmpDir"/countNames.txt

bin/wrap_contents.sh "$tmpDir"/countNames.txt html_components/username_dist "$wrkDir"/username_dist.html
