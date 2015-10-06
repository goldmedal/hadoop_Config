scp $1 node2:/home/hduser/$1
scp $1 node3:/home/hduser/$1
scp $1 node4:/home/hduser/$1
scp $1 node5:/home/hduser/$1
scp $1 node6:/home/hduser/$1
scp $1 node7:/home/hduser/$1
scp $1 node8:/home/hduser/$1
scp $1 node9:/home/hduser/$1
scp $1 node10:/home/hduser/$1
#scp $1 node11:/home/hduser/$1

ssh node2 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node3 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node4 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node5 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node6 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node7 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node8 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node9 "mv *.xml $HADOOP_HOME/etc/hadoop"
ssh node10 "mv *.xml $HADOOP_HOME/etc/hadoop"
#ssh node11 "mv *.xml $HADOOP_HOME/etc/hadoop"
