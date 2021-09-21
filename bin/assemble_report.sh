#!/bin/bash

# This argument takes in the directory specified by the user to assemble the report in.
wrkDir=$1

# A file for contents.html is created, assuming that it does not already exist.
touch "$wrkDir"/contents.html

# The HTML files for the country, hours, and username distributions will be concatenated together into contents.html. These files are all expected to be found in the working directory.
cat "$wrkDir"/country_dist.html "$wrkDir"/hours_dist.html "$wrkDir"/username_dist.html >> "$wrkDir"/contents.html

# An HTML file for storing the failed login attempts is created, assuming that it already hasn't been made.
touch "$wrkDir"/failed_login_summary.html

# This function call wraps the data of contents.html into the appropriate header and footer (in this case, summary_plots) and then send the output to failed_login_summary.html.
bin/wrap_contents.sh "$wrkDir"/contents.html ./html_components/summary_plots "$wrkDir"/failed_login_summary.html
