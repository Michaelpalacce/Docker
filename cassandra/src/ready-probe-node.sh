#!/bin/bash

while :
do
  seedUp=0
  while IFS= read -r ip; do
    string=$(nc -z -w2 -v $ip 9042 > /dev/stdout 2>&1)
    if [[ $string == *"succeeded"* ]]; then
      seedUp=1
      break
    fi
  done < <(echo $CASSANDRA_SEEDS | tr ',' '\n')

  if [[ $seedUp == 1 ]]; then
    break
  fi
  sleep 2
done

if [[ $(nodetool status | grep $POD_IP) == *"UN"* ]]; then
  exit 0;
else
  exit 1;
fi
