export HADOOP_HOME=/home/hduser/hadoop
export HBASE_HOME=/home/hduser/hbase
export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export JRE_HOME=/usr/lib/jvm/java-7-openjdk-amd64/jre
export PATH=$PATH:$HBASE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
export HADOOP_CLASSPATH=$HADOOP_CLASSPATH:`hbase classpath`:/home/hduser/json-20140107.jar

/usr/local/hadoop/bin/hadoop jar /home/hduser/tomcat_workspace/hbaseAPI/dataLogging.jar DCR_Handler aa >> /home/hduser/tomcat_workspace/log/dataLogging_log
