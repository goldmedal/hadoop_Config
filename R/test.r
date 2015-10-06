Y_data = read.csv("/home/hduser/git/hadoop_Config/R/input.csv.32g", header=FALSE)
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
#hdfs.put("/home/hduser/data.csv.ten", "/hduser/R/OGA/inputx")
hdfs.root <- '/hduser/R/OGA'
hdfs.data <- file.path('/output_32')
hdfs.out <- file.path(hdfs.root, 'output_32')

mroga <- function (input, output=NULL) {
  
  #inputfile = make.input.format("csv", sep = ",", fill=TRUE)
  inputfile = make.input.format("text")  
  used_column = array(0, dim=c(1, 100))
  #    mapreduce(input=to.dfs(X), output=output,
  mapreduce(input=input, output=output, input.format = inputfile,
            
            map=function(k, lines) {
              # mp_time <- proc.time()
              
              index = strsplit(lines, split="\t", fixed="T")
              index = unlist(index[1])
              number = as.integer(index[1])
              data = strsplit(index[2], split=",", fixed="T")
              data = unlist(data[1])
              data = as.double(data)
              
              mx = as.matrix(data)
             # x = t(mx)
              ys = dim(Y)
             # xs = dim(x)
              rmr.str(ys)
              rmr.str(mx)
              rmr.str(dim(mx))
            #  rmr.str(x)
            #  rmr.str(dim(x))
              
              corr=abs(cor(mx,Y,method="spearman"))
              
              maxIndex = which(corr == max(corr), arr.ind = TRUE)
              keyval(as.integer(number%%5), maxIndex[1])
              # keyval(maxIndex[1],1)
              
            },
            
            reduce=function(k, vv) {
              rmr.str(k)
              rmr.str(vv)
              # maxIndex = which(vv == max(vv), arr.ind = TRUE )
              maxIndex = which(k == max(k), arr.ind = TRUE )
              keyval(k,maxIndex[1])
              
            })
  
}

start_time <- proc.time() 
out <- mroga(hdfs.data, hdfs.out)
end_time <- proc.time() - start_time

#modelfile <- hdfs.file("/hduser/R/lab/input/inputx.csv.old", "r")
#m <- hdfs.read(modelfile)
#model <- unserialize(m)

result <- from.dfs(out)
hdfs.delete(hdfs.out)
