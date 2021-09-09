#!/bin/bash

header="$2_header.html"
footer="$2_footer.html"

cat "$header" "$1" "$footer" > "./$3"
