HADOOP_HOME=/usr/local/hadoop
ZK_HOME=/home/hduser/zookeeper

# start zookeeper
ssh node2 "bash -s " < /home/hduser/script/node2/zkStart.sh $ZK_HOME

# start journal
ssh node2 "$HADOOP_HOME/sbin/hadoop-daemon.sh start journalnode"

# format data
$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/bin/hdfs zkfc -formatZK

# start primary namenode
$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode

# start backup namenode
ssh node2 "$HADOOP_HOME/bin/hdfs namenode -bootstrapStandby"
ssh node2 "$HADOOP_HOME/sbin/hadoop-daemon.sh start namenode"

# start auto-recovery
$HADOOP_HOME/sbin/hadoop-daemon.sh start zkfc
ssh node2 "$HADOOP_HOME/sbin/hadoop-daemon.sh start zkfc"

# start datanode
ssh node3 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node4 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node5 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node6 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node7 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node8 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node9 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node10 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"
ssh node11 "$HADOOP_HOME/sbin/hadoop-daemon.sh start datanode"

# start resource manager
$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager
ssh node2 "$HADOOP_HOME/sbin/yarn-daemon.sh start resourcemanager"

# start node manager
ssh node3 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node4 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node5 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node6 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node7 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node8 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node9 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node10 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"
ssh node11 "$HADOOP_HOME/sbin/yarn-daemon.sh start nodemanager"

# start history server

$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver
ssh node2 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node3 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node4 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node5 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node6 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node7 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node8 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node9 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node10 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
ssh node11 "$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver"
