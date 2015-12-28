#!/bin/bash
#Program:
#    Free resources of nodes in cluster
#    it will read hosts fill to send cmd


filename='hosts'
exec < $filename

while read line
do
    # Free Memeory and Cache
    # 釋放 pagecache:捨棄一般沒使用的 cache
    ssh $line "echo 1 > /proc/sys/vm/drop_caches"
    #釋放 dentries and inodes
    ssh $line "echo 2 > /proc/sys/vm/drop_caches"
    #釋放 pagecache, dentries and inodes
    ssh $line "echo 3 > /proc/sys/vm/drop_caches"

    #Clear Swap
    ssh $line "swapoff -a"
    ssh $line "swapon -a"
done
