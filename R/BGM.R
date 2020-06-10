#' Separate \code{R} From \code{X}
#'
#' @description
#' @param X a large matrix from which principle components are extrated.
#' @param R a numerica vector which we are interesting in, for example interest rates.
#' @param K the number of extracted princple components.
#' @param niter the iterations, see details.
#' @details
BGM <- function(X,R, K = 2, niter = 10){
  for (i in 1:niter) {
    pc <- ExtrPC(X,K)$F0
    xdata <- cbind(pc,R)
    b <- solve(t(xdata) %*% xdata) %*% t(xdata) %*% X
    X <- X - matrix(R,ncol = 1) %*% b[nrow(b),]
  }
  return(pc)
}
