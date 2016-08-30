#!/usr/local/bin/bash 
declare -A cpidArr
# | sed 's/\"//g' 
gunzip -c syslog.gz | grep 'cm-accept tracking' | sed 's/^[^{]*{\([^{}]*\)}.*/\1/' | awk -F'[:,]' '{print $4 "|" $2}' | while read line
do
    # echo $line
    IFS='|' read -r cpid action <<< "$line"
    # echo $cpid
    # echo $action
    cpid="$(sed s/\"//g <<<$cpid)"
    
    re='^[0-9]+$'
    if [[ $cpid =~ $re ]] ; then
    #   echo $cpid
      cpidArr[$cpid]=$action
    fi
    if ! IFS= read ; then
        echo 'cpidArr length',${#cpidArr[@]}
        for i in "${!cpidArr[@]}"
        do
          echo $i, ${cpidArr[$i]}
        done
    fi
done