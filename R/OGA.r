#OGA in R version1
start_time <- proc.time()
##視覺化讀檔
#scan(file.choose() )
#read.table(file.choose(),header=T)

#X_data=read.csv("C:/Users/user/Desktop/data of Ing X.csv",header=FALSE)
#Y_data=read.csv("C:/Users/user/Desktop/data of Ing Y.csv",header=FALSE)

# Hadoop Setting

source('mroga.r') # include mroga function
source('rimpala.r') # include rimpala function

result = hdfs.cat('hdfs://node1:8020/user/root/dim')
Xdim = strsplit(result, ",")
Y_size = as.integer(Xdim[[1]][1])
X_size = as.integer(Xdim[[1]][2])

# Read Y and parsing
Y = from.dfs('hdfs://node1:8020/user/root/input.csv.small', format = "csv")
Y = as.matrix(Y$val)

Y_origin=Y

#X=as.matrix(X_data)
#Y=as.matrix(Y_data)
#Y_origin=Y

iteration_time=1  #紀錄目前第幾輪
corr_max=0;       #最大相關係數          
temp_corr=0;      #暫存相關係數
corr=0;           #當下相關係數
num=0;            #選取索引 選了第幾個候選變數 


##設定最多迭代次數
iteration_time_limit=5;
##

##設定變異項選模最高迭代次數
##var_iteration_time_limit=10
##

##HDIC懲罰項調整
#待補
##

##變異項選模懲罰項調整
##待補
##

#size=dim(X)
#X_size=size[2]
#Y_size=size[1]

wn =log( Y_size )

X_iteration = array(,dim=c(Y_size,1))     #須歸零 當下選到的重要參數矩陣
X_iteration_cum = array(,dim=c(Y_size,1)) #須歸零 累積的重要參數矩陣

#XX_iteration = array(,dim=c(Y_size,1))
#XX_iteration_cum = array(,dim=c(Y_size,1))

predictor= array(,dim=c(1,iteration_time_limit))
tmp_HDIC_mat=array(,dim=c(1,iteration_time_limit))

beta= array(,dim=c(1,1))

HDIC_min=999999     #最小訊息準則值 先給予極大值
temp_HDIC=0         #暫存訊息準則值 
HDIC=0              #訊息準則(引入變數個數) 
HDIC_num=0          #訊息準則值  選取索引
res=0               #殘差
w=1
##trim
#trim_X=array(,dim=c(Y_size,1))   #tirm使用的X
##

used_column=array(0,dim=c(1,X_size))

while (iteration_time<=iteration_time_limit)  #iteration_time_limit
{
 # for(i in 1:X_size)  #X_size
 # {
 #   if( used_column[1,i]==0 )
 #   {
  #    corr=cor( X[,i],Y,method="spearman")
  #    temp_corr=abs(corr)
      
  #    if(temp_corr>corr_max)
  #    {
 #       corr_max=temp_corr
  #      num=i
  #    }
 #   } 
 # }
  
#  mr_start <- proc.time()
  out <- mroga(hdfs.data, hdfs.out)
#  mr_end <- proc.time() - mr_start
  result <- from.dfs(out)
  val = result$val
  key = result$key
  
  maxIndex = which(val == max(val), arr.ind = TRUE )
  maxIndex = maxIndex[1]
  num = key[maxIndex]
  
  hdfs.delete(hdfs.out)
  
  predictor[1,w]=num
  
  ##累積回歸矩陣
  X_iteration = getValueByIndex(index=num);
  
  print(num) 
  if (iteration_time==1)
  {
    X_iteration_cum =X_iteration;
  }else
  {
    X_iteration_cum = cbind(X_iteration_cum,X_iteration)
  }
  
  
  #求beta值
  XtX=t(X_iteration_cum)%*%X_iteration_cum
  beta=solve(XtX) %*% t(X_iteration_cum) %*% Y_origin
  Y = Y_origin - (X_iteration_cum%*%beta)
 
  #HDIC架構
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
  
  #設立迴圈標籤及歸零
  used_column[1,num]=1
  iteration_time=iteration_time+1
  corr_max=0
  w=w+1
  res=0
  corr=0
}

w=1

#trim 
trim_beta = array(,dim=c(HDIC-1,1))
Residual=array(,dim=c(Y_size,1))
trim_res=0
trim_predictor=array(,dim=c(1,HDIC))

q=1
t=1
trigger=0

for (i in 1:HDIC-1)
{
  trim_X=array(,dim=c(Y_size,1))
  for(j in 1:HDIC)
  {
    if(j!=i)
    {
      if(trigger==0)
      {
        trim_X=X_iteration_cum[,j]
        trigger=1
      }else
      {
        trim_X=cbind(trim_X,X_iteration_cum[,j])
      }
    }
  }
  
  trim_XtX=t(trim_X)%*%trim_X
  trim_beta=solve(trim_XtX) %*% t(trim_X) %*% Y_origin
  
  Residual=Y_origin-(trim_X%*%trim_beta)
  
  for (k in 1:Y_size)
  {
    
    tmp=as.integer (Residual[k,1]^2)
    trim_res=trim_res+tmp
  }
  
  trim_HDIC=( Y_size * ( log( trim_res/Y_size) ) )+( (HDIC-1) * wn *log(X_size) );
  
  if (trim_HDIC > HDIC_min)
  {
    trim_predictor[1,q]=predictor[1,i]
    q=q+1
  }
  
  trigger=0
  trim_X=array(,dim=c(Y_size,1))
  trim_res=0
  t=1
}

trim_predictor[1,q]=predictor[1,HDIC]
print(trim_predictor)
end_time <- proc.time() - start_time
message("Total time: ", end_time[3])
