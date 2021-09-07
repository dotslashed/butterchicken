#!/bin/bash

while getopts :w:p: fname; do

        case $fname in
                w) WAYBACK=$OPTARG;;
                p) PARAMS=$OPTARG;;
                *) echo "Invalid Operation $OPTARG";;
        esac
done

cat $WAYBACK | deduplicate -hide-useless -sort | unfurl format %s://%d%p | grep -P -i '[a-zA-Z]+\.[a-zA-Z]+$' | grep -v "\.jpg$\|\.jpeg$\|\.gif$\|\.css$\|\.tif$\|\.tiff$\|\.png$\|\.ttf$\|\.woff$\|\.woff2$\|\.ico$\|\.pdf$\|\.svg$\|\.txt$\|\.js$\|\.eot$\|\.otf$\|\.exe$)" | sort -u >> hosts.txt

echo "Gathered the hosts"

cat $PARAMS | sed 's/^/?/g' | sed 's/$/=/g' >> paths.txt

echo "Gathered the paths and ready for the attack"

urls="$(<./hosts.txt)"
while IFS= read  -r pays; do
    echo "$urls" |
        while IFS= read  -r payload; do
            echo "$payload$pays"
        done
done < ./paths.txt | tee results.txt

echo "Task Completed!"
sleep 2
echo "You can find 3 files!"
echo "Results saved in results.txt file"
