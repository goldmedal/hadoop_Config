ZK_HOME="/home/hduser/zookeeper"

# reset data

test -e $ZK_HOME/data &&
    rm -r $ZK_HOME/data &&
    mkdir $ZK_HOME/data &&
    echo "0" >> $ZK_HOME/data/myid

$ZK_HOME/bin/zkServer.sh start
