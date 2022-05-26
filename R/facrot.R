#'
#'

# OLS
olssvd <- function(F0,ly){
  ans <- svd(ly)
  d <- 1/ans$d
  b <- (ans$v * repmat(d,length(d),1)) %*% t(ans$u) %*% F0
  return(b)
}

facrot <- function(F0, Ffast, Fslow0){
  # b <- olssvd(F0, cbind(ones(matlab::size(Ffast,1),1),Ffast,Fslow0))
  b <- olssvd(F0, cbind(ones(dim(Ffast)[1],1),Ffast,Fslow0))
  Fr <-  F0 - Ffast %*% b[2:(ncol(Ffast)+1),]
}
