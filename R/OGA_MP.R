#OGA in R version1
start_time <- proc.time()
##??ı??Ū??
#scan(file.choose() )
#read.table(file.choose(),header=T)
input_start_time <- proc.time()
X_data=read.csv("/home/hduser/big_inputx.csv",header=FALSE)
input_end_time <- proc.time() - input_start_time
Y_data=read.csv("/home/hduser/big_input.csv",header=FALSE)

X=as.matrix(X_data)
Y=as.matrix(Y_data)
Y_origin=Y

iteration_time=1  #?????ثe?ĴX??
corr_max=0;       #?̤j?????Y??
temp_corr=0;      #?Ȧs?????Y??
corr=0;           #???U?????Y??
num=0;            #?????��? ???F?ĴX?ӭԿ??ܼ?


##?]?w?̦h???N????
iteration_time_limit=10;
##

##?]?w?ܲ??????ҳ̰????N????
##var_iteration_time_limit=10
##

##HDIC?g?@???վ?
#?ݸ?
##

##?ܲ????????g?@???վ?
##?ݸ?
##

size=dim(X)
X_size=size[2]
Y_size=size[1]

wn =log( Y_size )

X_iteration = array(,dim=c(Y_size,1))     #???k?s ???U???쪺???n?ѼƯx?}
X_iteration_cum = array(,dim=c(Y_size,1)) #???k?s ?ֿn?????n?ѼƯx?}

#XX_iteration = array(,dim=c(Y_size,1))
#XX_iteration_cum = array(,dim=c(Y_size,1))

predictor= array(,dim=c(1,iteration_time_limit))
tmp_HDIC_mat=array(,dim=c(1,iteration_time_limit))

beta= array(,dim=c(1,1))

HDIC_min=999999     #?̤p?T???ǫh?? ?????????j??
temp_HDIC=0         #?Ȧs?T???ǫh??
HDIC=0              #?T???ǫh(?ޤJ?ܼƭӼ?)
HDIC_num=0          #?T???ǫh??  ?????��?
res=0               #?ݮt
w=1
##trim
#trim_X=array(,dim=c(Y_size,1))   #tirm?ϥΪ?X
##

# Set RHadoop
mr_set_start=proc.time()
Sys.setenv(HADOOP_CMD="/usr/local/hadoop/bin/hadoop")
Sys.setenv(HADOOP_STREAMING="/usr/local/hadoop/share/hadoop/tools/lib/hadoop-streaming-2.6.0.jar")
Sys.setenv(JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64")
library(rmr2)
library(rhdfs)
hdfs.init()
hdfs.mkdir("/hduser/R/lab/input")
hdfs.put("/home/hduser/inputx_t.csv", "/hduser/R/lab/input")
hdfs.root <- '/hduser/R/lab'
hdfs.data <- file.path(hdfs.root, 'input')
hdfs.out <- file.path(hdfs.root, 'output')
mr_set_time=proc.time()-mr_set_start
# MapReduce Function

corrMax <- function(input, output=NULL){
  
  inputfile = make.input.format("csv", sep = ",")
  mapreduce(input=input, output=output, input.format=inputfile,
            map = function(k, v){
              
              x = t(as.matrix(v))
              corr = abs(cor(x, Y, method="spearman"))
              keyval(1, corr)
              #  keyval(1,abs(v))
            },
            reduce=function(k, vv) {
             # maxIndex =  which(vv == max(vv), arr.ind = TRUE) # get the max value index
              #keyval(k, maxIndex[1])
              keyval(1,max(vv))
            })
}
used_column=array(0,dim=c(1,X_size))

while (iteration_time<=iteration_time_limit)  #iteration_time_limit
{
  mr_start <- proc.time()

  out <- corrMax(hdfs.data, hdfs.out)
  result <- from.dfs(out)
  num = result$val
  hdfs.delete(hdfs.out)
  mr_end <- proc.time()-mr_start
  
  message("num :", as.character(num));
  message("time :", as.character(mr_end[3]));
  predictor[1,w]=num
  
  ##?ֿn?^?k?x?}
  X_iteration = X[,num];
  
  if (iteration_time==1)
  {
    X_iteration_cum =X_iteration;
  }else
  {
    X_iteration_cum = cbind(X_iteration_cum,X_iteration)
  }
  
  
  #?Dbeta??
  XtX=t(X_iteration_cum)%*%X_iteration_cum
  beta=solve(XtX) %*% t(X_iteration_cum) %*% Y_origin
  Y = Y_origin - (X_iteration_cum%*%beta)
  
  #HDIC?[?c
  for(i in 1:Y_size)
  {
    tmp=as.integer(Y[i,1]^2)
    res=res+tmp
  }
  
  temp_HDIC=( Y_size * ( log( res/Y_size) ) )+( iteration_time * wn *log(X_size) );
  tmp_HDIC_mat[1,w]=temp_HDIC
  
  if (temp_HDIC < HDIC_min)
  {
    HDIC_min=temp_HDIC
    HDIC=iteration_time
  }
  
  #?]?߰j?????Ҥ??k?s
  used_column[1,num]=1
  iteration_time=iteration_time+1
  corr_max=0
  w=w+1
  res=0
  corr=0
}

end_time <- proc.time() - start_time
message("Total time: ", end_time[3])

w=1
#
# trim_beta = array(,dim=c(HDIC-1,1))
# Residual=array(,dim=c(Y_size,1))
# trim_res=0
# trim_predictor=array(,dim=c(1,HDIC))
# trim_X=array(,dim=c(Y_size,HDIC-1))
# q=1
# w=1
#
# for (i in 1:HDIC-1)
# {
#   for(j in 1:HDIC)
#   {
#     if(j!=i)
#     {
#       trim_X[,w] = X_iteration_cum[,j]
#       w=w+1
#     }
#   }
#
#   trim_XtX=t(trim_X)%*%trim_X
#   trim_beta=solve(trim_XtX) %*% t(trim_X) %*% Y_origin
#
#   Residual=Y_origin-(trim_X%*%trim_beta)
#
#   for (k in 1:Y_size)
#   {
#     tmp=as.integer(Residual[i,1]^2)
#     trim_res=trim_res+tmp
#   }
#
#   trim_HDIC=( Y_size * ( log( trim_res/Y_size) ) )+( (HDIC-1) * wn *log(X_size) );
#
#   if (trim_HDIC > HDIC_min)
#   {
#     trim_predictor[1,q]=predictor[1,i]
#     q=q+1
#   }
#
#
#   trim_X=array(,dim=c(Y_size,HDIC-1))
#   trim_res=0
#   w=1
# }
