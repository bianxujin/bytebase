#!/bin/bash
FILE_DIR='/ssd2/dump/20240529'

for file in `ls $FILE_DIR/*schema.sql`;
do
    if [ -f "$file" ]; then
        echo "$file"
        sed -i '$s/;[[:space:]]*$/ \/\*T![auto_id_cache] AUTO_ID_CACHE=1 \*\/;/' $file
    fi
done
~        
