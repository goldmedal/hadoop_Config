count = 0

map <- function(k, lines) {

    words.list <- strsplit(lines, '\\s')
    words <- unlist(words.list)
    return ( keyval(words, 1))

}

reduce <- function(word, counts) {

    
    keyval(word, sum(counts))

}


Sys.setenv(HADOOP_CMD="/usr/local/hadoop/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64")
library(rmr2)
library(rhdfs)
hdfs.init()
hdfs.mkdir("/hduser/R/wordcount/input")
hdfs.put("/home/hduser/workspace/R/wc_input.txt", "/hduser/R/wordcount/input")
hdfs.root <- '/hduser/R/wordcount'
hdfs.data <- file.path(hdfs.root, 'input')
hdfs.out <- file.path(hdfs.root, 'output')

wordcount <- function (input, output=NULL) {

    mapreduce(input=input, output=output, input.format="csv", map=map, reduce=reduce)

}

out <- wordcount(hdfs.data, hdfs.out)
