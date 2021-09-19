#/!bin/bash

tmpDir=$(mktemp -d)

for file in "$@"; do
	base=$(basename $file _secure.tgz)
	mkdir "$tmpDir"/"$base"
	tar -xzf $file -C "$tmpDir"/"$base"
	bin/process_client_logs.sh  "$tmpDir"/"$base"	
done

bin/create_username_dist.sh "$tmpDir"

bin/create_hours_dist.sh "$tmpDir"

bin/create_country_dist.sh "$tmpDir"

bin/assemble_report.sh "$tmpDir"

cp "$tmpDir"/failed_login_summary.html ./failed_login_summary.html

