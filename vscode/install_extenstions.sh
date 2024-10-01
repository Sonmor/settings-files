#!/bin/sh

while read p;
do
  code --install-extension $p
done < $1 
