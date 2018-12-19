IFS='
'
cat film.txt| while read line; do touch "/root/FILM/$line";done
