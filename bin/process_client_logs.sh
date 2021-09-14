#!/bin/bash

wrkDir=$1 #This is the working directory.

cd "$wrkDir"

touch failed_login_data.txt
cat var/log/* | awk 'match($0, /([a-zA-z]+)[[:space:]]{1,2}([0-9]+[[:space:]][0-9]+).* Failed password for (invalid user )?([a-zA-Z0-9]+) from ([0-9\.]+)/, groups) {print groups[1] " " groups[2] " " groups[4] " " groups[5] }' >> failed_login_data.txt
