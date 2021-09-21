#!/bin/bash

# Make and store the path to a temporary directory
tmpDir=$(mktemp -d)

# For each file, given as an argument...
for file in "$@"; do
	# Strip just the basename of the file (This corresponds to the name of the computer the file was taken from)
	base=$(basename "$file" _secure.tgz)

	# Make a directory named after the basename within our temporary directory
	mkdir "$tmpDir"/"$base"

	# Decompress the file into the directory we just created
	tar -xzf "$file" -C "$tmpDir"/"$base"

	# Run process_client_logs.sh on the decompressed directory
	bin/process_client_logs.sh  "$tmpDir"/"$base"	
done

# Run create_username_dist.sh on the temporary directory
bin/create_username_dist.sh "$tmpDir"

# Run create_hours_dist.sh on the temporary directory
bin/create_hours_dist.sh "$tmpDir"

# Run create_country_dist.sh on the temporary directory
bin/create_country_dist.sh "$tmpDir"

# Run assemble_report.sh on the temporary directory
bin/assemble_report.sh "$tmpDir"

# Copy the generated report into a non-temporary directory(The current working directory)
cp "$tmpDir"/failed_login_summary.html ./failed_login_summary.html

