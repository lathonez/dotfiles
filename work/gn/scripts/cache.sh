#!/bin/bash

cd ../logs

for cache in `ls *cache*`;
do 
	export shaz_box=$cache;
	grep Cache $cache | tail -n 9 | grep "small objects used" | sed 's/Cache://g' | awk '{print $1,ENVIRON["shaz_box"]"\t",$10}';
done
