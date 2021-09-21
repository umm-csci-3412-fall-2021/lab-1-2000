#!/bin/bash

# This argument takes in the working directory that will be used for creating the hours distribution.
wrkDir=$1

# This variable stores a temporary directory, which will be used for this function to do most of its work in.
tmpDir=$(mktemp -d)

# A text document for storing the hour information is created in the temporary directory.
touch "$tmpDir"/hours.txt

# Here, the data relating to the hours of each login is grabbed rom failed_login_data.txt and placed into hours.txt.
cat "$wrkDir"/*/failed_login_data.txt | awk 'match($0, /[a-zA-z]+ [0-9]+ ([0-9]+) /, groups) {print groups[1]}' >> "$tmpDir"/hours.txt

# A text file for counting the hours is created in the temporary directory.
touch "$tmpDir"/countHours.txt

# Here, we count the occurrences of each hour. Then, we place the relevant data into countHours.txt.
sort "$tmpDir"/hours.txt | uniq -c | awk 'match($0, /([0-9]+) ([0-9]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);"}' >> "$tmpDir"/countHours.txt

# If hours_dist.html does not exist in the working directory, it will be created here.
touch "$wrkDir"/hours_dist.html

# The contents of countHours.txt is wrapped into the header and footer of hours_dist, before then being sent into hours_dist.html.
# This will create a distribution for displaying hour information in the working directory.
bin/wrap_contents.sh "$tmpDir"/countHours.txt html_components/hours_dist "$wrkDir"/hours_dist.html
