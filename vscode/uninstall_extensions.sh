#!/bin/sh

while read p;
do
  code --uninstall-extension $p
done < $1
