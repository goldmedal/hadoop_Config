Y_data = read.csv("/home/hduser/workspace/R/input.csv.old", header=FALSE)
#X_data=read.csv("/home/hduser/workspace/R/inputx.csv.old",header=FALSE)
#X=as.matrix(X_data)
Y=as.matrix(Y_data)
Y_orgin=Y

iteration_time=1
corr_max=0
temp_corr=0
corr=0
num=0

Sys.setenv(HADOOP_CMD="/usr/local/hadoop/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64")
library(rmr2)
library(rhdfs)
hdfs.init()
hdfs.mkdir("/hduser/R/lab/input")
hdfs.put("/home/hduser/workspace/R/inputx.csv.old", "/hduser/R/lab/input")
hdfs.root <- '/hduser/R/lab'
hdfs.data <- file.path(hdfs.root, 'input')
hdfs.out <- file.path(hdfs.root, 'output')

wordcount <- function (input, output=NULL) {

    inputfile = make.input.format("csv", sep = ",")
    used_column = array(0, dim=c(1, 100))

    mapreduce(input=input, output=output, input.format=inputfile,
              map=function(k, lines) {

                  corr = abs(cor(lines, Y, method="spearman"))
                  rmr.str("aa", corr)
                  keyval(1, corr)

              },
              reduce=function(k, vv) {

                maxIndex = which(vv == max(vv), arr.ind = TRUE)
                keyval(k,maxIndex[1])

              })

}
start_time <- proc.time() 
out <- wordcount(hdfs.data, hdfs.out)
end_time <- proc.time() - start_time
#modelfile <- hdfs.file("/hduser/R/lab/input/inputx.csv.old", "r")
#m <- hdfs.read(modelfile)
#model <- unserialize(m)
result <- from.dfs(out)
hdfs.delete(hdfs.out)
