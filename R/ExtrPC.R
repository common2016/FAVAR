ExtrPC <- function(X_st, K){
  # covar matrix
  xx <- t(X_st) %*% X_st
  evalue <- eigen(xx)$values
  evec <- eigen(xx)$vectors

  # loading and score
  lam <- sqrt(ncol(X_st)) * evec[,1:K]
  fac <- X_st %*% lam/ncol(X_st)
  return(list(F0 = fac, Lf = lam))
}
