#!/bin/bash

if [[ $(nodetool status | grep $POD_IP) == *"UN"* ]]; then
  exit 0;
else
  exit 1;
fi
