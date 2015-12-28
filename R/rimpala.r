library(RImpala)
rimpala.init(libs="/local/workspace/jdbc")
rimpala.connect(IP="node2")
rimpala.invalidate()

getValueByIndex <- function( index ) {
  
  query = "select index_value.value from index_value where index_value.index ="
  query = paste(query, index)
  
  X_iteration = rimpala.query(Q=query)
  X_iteration = strsplit(X_iteration[[1]], split=",", fixed="T")
  X_iteration = unlist(X_iteration)
  X_iteration = as.double(X_iteration)
  X_iteration = as.matrix(X_iteration)
  
  return(X_iteration);

}

