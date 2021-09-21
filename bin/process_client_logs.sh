#!/bin/bash

# Take the working directory as an argument
wrkDir=$1

# cd into the working directory
cd "$wrkDir" || exit

# If failed_login_data.txt does not already exist, create it
touch failed_login_data.txt

# Extract the relevant information from all the log files and save it into failed_login_data.txt
# The regex works as follows:
# First group of parentheses reads and saves the month into groups[1]
# After that we check for one or two spaces (since there will be two spaces when the day of the month is a single digit)
# Second group of parentheses reads and saves the day of the month and the hour into groups[2]
# We then ignore any other characters until the string " Failed password for "
# An optional "invalid user " string might also be present afterwards. This is saved to groups[3], but we don't ever use it
# The next set of parentheses saves the username into groups[4]
# We then expect the string " from " before reading the IP address which is saved to groups[5]
# Finally, the data that was saved into groups is printed into failed_login_data.txt
cat var/log/* | awk 'match($0, /([a-zA-z]+)[[:space:]]{1,2}([0-9]+[[:space:]][0-9]+).* Failed password for (invalid user )?([\-\_a-zA-Z0-9]+) from ([0-9\.]+)/, groups) {print groups[1] " " groups[2] " " groups[4] " " groups[5] }' >> failed_login_data.txt
