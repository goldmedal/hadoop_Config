# 釋放 pagecache:捨棄一般沒使用的 cache
echo 1 > /proc/sys/vm/drop_caches
#釋放 dentries and inodes
echo 2 > /proc/sys/vm/drop_caches
#釋放 pagecache, dentries and inodes
echo 3 > /proc/sys/vm/drop_caches
