#!/bin/bash

# This argument takes in a directory for creating the username distribution in.
wrkDir=$1

# This variable storing a temporary directory that will be used for the function to do most of its work in.
tmpDir=$(mktemp -d)

# A text file for storing the usernames is created in the temporary directory.
touch "$tmpDir"/usernames.txt

# From failed_login_data.txt, the usernames are grabbed with regex and then placed into usernames.txt.
cat "$wrkDir"/*/failed_login_data.txt | awk 'match($0, /[a-zA-z]+ [0-9]+ [0-9]+ ([\-\_a-zA-Z0-9]+)/, groups) {print groups[1]}' >> "$tmpDir"/usernames.txt

# In the temporary directory, countNames.txt is created for placing the name counts in.
touch "$tmpDir"/countNames.txt

# Here, we count the usernames and save the number of instances of each username in countNames.txt.
sort "$tmpDir"/usernames.txt | uniq -c | awk 'match($0, /([0-9]+) ([\-\_a-zA-Z0-9]+)/, groups) {print "data.addRow([\x27" groups[2] "\x27, " groups[1] "]);"}' >> "$tmpDir"/countNames.txt

# If username_dist.html does not exist in the working directory, it will be created here.
touch "$wrkDir"/username_dist.html

# The contents of countNames.txt is placed between the header and footer of username_dist, before then being combined and placed into username_dist.html.
# The distribution is stored there.
bin/wrap_contents.sh "$tmpDir"/countNames.txt html_components/username_dist "$wrkDir"/username_dist.html
