#!/bin/bash
#Program:
#    Free resources of nodes in cluster
#    it will read hosts fill to send cmd


filename='hosts'
exec < $filename

while read -r line
do

    name=$line
    # Free Memeory and Cache
    # 釋放 pagecache:捨棄一般沒使用的 cache
    ssh -n $name "echo 1 > /proc/sys/vm/drop_caches"
    #釋放 dentries and inodes
    ssh -n $name "echo 2 > /proc/sys/vm/drop_caches"
    #釋放 pagecache, dentries and inodes
     ssh -n $name "echo 3 > /proc/sys/vm/drop_caches"

    #Clear Swap
    ssh -n $name "swapoff -a"
    ssh -n $name "swapon -a"
    echo $line "clear!"

done < $filename
