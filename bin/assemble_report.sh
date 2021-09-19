#!/bin/bash

wrkDir=$1

touch "$wrkDir"/contents.html

cat "$wrkDir"/country_dist.html "$wrkDir"/hours_dist.html "$wrkDir"/username_dist.html >> "$wrkDir"/contents.html

touch "$wrkDir"/failed_login_summary.html

bin/wrap_contents.sh "$wrkDir"/contents.html ./html_components/summary_plots "$wrkDir"/failed_login_summary.html
