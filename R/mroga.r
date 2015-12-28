Sys.setenv(HADOOP_CMD="/opt/cloudera/parcels/CDH/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/opt/cloudera/parcels/CDH/jars/hadoop-streaming-2.6.0-cdh5.4.8.jar")
Sys.setenv(JAVA_HOME="/usr/")

library(rmr2)
library(rhdfs)
hdfs.init()
hdfs.root <- '/user/impala'
hdfs.data <- file.path(hdfs.root, 'index_value')
hdfs.out <- file.path('/user/root/oga_output')

#Y_data = read.csv("input.csv.small", header=FALSE)
#Y=as.matrix(Y_data)
#Y_orgin=Y

mroga <- function (input, output=NULL) {
  
  inputfile = make.input.format("csv", sep = "\t", fill=TRUE)
  #inputfile = make.input.format("text")     
  mapreduce(input=input, output=output, input.format = inputfile,
            
            map=function(k, lines) {

              # lines will be 1\t1,2,3,4 
              # data parsing

              number = as.integer(lines[[1]])
	      data = lines[[2]]

              keyval(number, data)
              
            },
            
            reduce=function(indexs, data) {
	      
	      data = as.character(data)
              data = strsplit(data, split=",", fixed="T")
              data = unlist(data[1])
              data = as.double(data)

              corr<-abs(cor(data,Y,method="spearman"))
              keyval(indexs,corr)
              
           },

	  backend.parameters = list (
		hadoop = list( D = "mapreduce.job.reduces=4"))
	  )
  
}

# out <- mroga(hdfs.data, hdfs.out)
