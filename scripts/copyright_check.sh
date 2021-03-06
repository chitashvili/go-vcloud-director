#!/bin/bash
# This script will find code files that don't have a copyright notice

# This check will find files with a copyright but not for the current year
vmware_any_copyright='Copyright \d\d\d\d VMware'

# This check will find files with a copyright for the current year
vmware_latest_copyright="Copyright $(date +%Y) VMware"
exit_code=0
for F in $(find . -name '*.go' | grep -v '/vendor/' )
do
    copyright_found=""
    for line_num in 1 2 3
    do
        # Looks for copyright in the Nth line of the file
        has_any_copyright=$(head -n $line_num $F | tail -n 1 | grep "$vmware_any_copyright" )
        has_latest_copyright=$(head -n $line_num $F | tail -n 1 | grep "$vmware_latest_copyright" )

        if [ -n "$has_latest_copyright" ]
        then
            if [ "$1" == "-v" -o "$1" == "--verbose" ]
            then
                echo "$F: latest copyright found in line $line_num"
            fi
            copyright_found=$line_num
        elif [ -n "$has_any_copyright" ]
        then
            echo "$F: older copyright found in line $line_num"
            echo "$has_any_copyright"
            copyright_found=$line_num
        fi
    done
    if [ -z "$copyright_found" ]
    then
        echo "File $F has no valid copyright"
        exit_code=1
    fi
done
exit $exit_code
