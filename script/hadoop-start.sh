HADOOP_HOME=/usr/local/hadoop

# format data
$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/bin/hdfs zkfc -formatZK

# start primary namenode
$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode

# start datanode
ssh node2 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"

# start resource manager
$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager

# start node manager
ssh node2 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"

# start history server

$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
ssh node2 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
