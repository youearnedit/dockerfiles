#!/bin/bash

# Convert the ERB templates into real files
for file in /usr/src/nginx/{,**/}*.erb; do
  if [ -f "$file" ]; then
    # don't overwrite an existing destination file
    if [ ! -e "${file%.*}" ]; then
      erb -T- "$file" > "${file%.*}"
      echo "${file%.*}: generated."
    else
      >&2 echo "${file%.*}: SKIPPED! refusing to overwrite existing file."
    fi
  fi
done

# Now run nginx
exec /usr/sbin/nginx -c /usr/src/nginx/nginx.conf
