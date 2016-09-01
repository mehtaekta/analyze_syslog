#!/usr/local/bin/bash 
# | sed 's/\"//g' 
gunzip -c data/syslog.gz | grep 'cm-accept tracking' | sed 's/^[^{]*{\([^{}]*\)}.*/\1/' | awk -F'[:,]' '{print $4 "|" $2}' | {
  declare -A cpidArr
  declare -A cpidUAArr
  
  while read line
  do
    # echo $line
    IFS='|' read -r cpid action <<< "$line"
    # echo $cpid
    # echo $action
    cpid="$(sed s/\"//g <<<$cpid)"
    
    re='^[0-9]+$'
    if [[ $cpid =~ $re ]] ; then
      
      # action does not contain UAString
      if [[ ${action} != *"UAString"* ]] ; then
        cpidArr[$cpid]=$action
      fi

      # action contain UAString
      if [[ ${action} == *"UAString"* ]] ; then
        cpidUAArr[$cpid]=$action
      fi
    fi

  done

  echo 'cpidArr length',${#cpidArr[@]}
  echo 'cpidUAArr length',${#cpidUAArr[@]}
  
  for i in "${!cpidArr[@]}"
  do
    echo $i, ${cpidArr[$i]}, ${cpidUAArr[$i]}  >> 'output/vi_syslog.txt'
  done
} 