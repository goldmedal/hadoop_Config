Y_data = read.csv("/home/hduser/git/hadoop_Config/R/input.csv", header=FALSE)
input_start_time <- proc.time()
#X_data=read.csv("/home/hduser/git/hadoop_Config/R/inputx.csv",header=FALSE)
#input_end_time <- proc.time() - input_start_time
Y=as.matrix(Y_data)
Y_orgin=Y

iteration_time=1
corr_max=0
temp_corr=0
corr=0
num=0

start_time <- proc.time()
#X=as.matrix(X_data)
#size = dim(X)
#write(t(X), file="/home/hduser/data.csv", ncolumns=size[1], sep=",")
end_time2 <- proc.time() - start_time


Sys.setenv(HADOOP_CMD="/usr/local/hadoop/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64")
library(rmr2)
library(rhdfs)
hdfs.init()
hdfs.mkdir("/hduser/R/OGA/inputx")
#hdfs.put("/home/hduser/data.csv", "/hduser/R/OGA/inputx")
hdfs.root <- '/hduser/R/OGA'
hdfs.data <- file.path(hdfs.root, 'inputx')
hdfs.out <- file.path(hdfs.root, 'output')

wordcount <- function (input, output=NULL) {

    inputfile = make.input.format("csv", sep = ",", fill=TRUE)
 # inputfile = make.input.format("text")  
  used_column = array(0, dim=c(1, 100))
#    mapreduce(input=to.dfs(X), output=output,
   mapreduce(input=input, output=output, input.format = inputfile,
              
              map=function(k, lines) {     
                mp_time <- proc.time()
                x = t(as.matrix(lines))
                ys = dim(Y)
                xs = dim(x)
                #if(ys[1] == xs[1]) {
                  rmr.str(dim(x))
                  corr=abs(cor(x,Y,method="spearman"))
                  
               # }
               # mp_end_time <- proc.time() - mp_time
               # rmr.str(mp_end_time[3])
               keyval(1, corr)

              },
              reduce=function(k, vv) {

                re_time <- proc.time()
                maxIndex = which(vv == max(vv), arr.ind = TRUE)
                re_end_time <- proc.time() - re_time
                rmr.str(re_end_time[3])
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
