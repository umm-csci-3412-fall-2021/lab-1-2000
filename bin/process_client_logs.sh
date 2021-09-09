#!/bin/bash

wrkDir=$1 #This is the working directory.

cd "$wrkDir"

touch failed_login_data.txt
cat * | awk 'match($0, /([^\x58]+).* Failed password for (invalid user)? ([a-zA-Z0-9]+) from ([0-9\.]+)/, groups) {print groups[1] " " groups[3] " " groups[4] "\n"}' >> failed_login_data.txt
