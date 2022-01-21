#' Separate \eqn{R} From \eqn{X}
#'
#' \eqn{X} may include some information corralted with \eqn{R}. The function
#' extract factors from \code{X} which is not corralated with \code{R} by iteration
#' based on Boivin et al. (2009).
#'
#' @param X a large matrix from which principle components are extrated.
#' @param R a numerica vector which we are interesting in, for example interest rates.
#' @param K the number of extracted princple components.
#' @param tolerance the difference between factors when iterating.
#' @param nmax the max iterations, see details.
#' @details
#' The algorithm is as follows:
#' \enumerate{
#'  \item Extract the first K principal components noted \eqn{F_t^{(0)}} from \code{X}.
#'  \item Regress \code{X} on \eqn{F_t^{(0)}} and \eqn{R_t}, and get regression
#'  coefficients \eqn{\beta_R^{(0)}} of \eqn{R_t}.
#'  \item compute \eqn{X_0^{(0)} = X_t- R_t \beta_R}.
#'  \item Extract the first K principal components noted \eqn{F_t^{(1)}} from
#'  \code{X_t^{(0)}}.
#'  \item repeat step 2 - step 4 until precision you want.
#' }
#'
#' @references
#' Boivin, J., M.P. Giannoni and I. Mihov, Sticky Prices and Monetary Policy: Evidence
#'  from Disaggregated US Data. American Economic Review, 2009. 99(1): p. 350-384.
#' @return the first K principa components, i.e. \eqn{F_t^{(n)}}, not containing the information \code{R}.
#' @examples
#' data('regdata')
#' BGM(X = regdata[,1:115],R = regdata[,ncol(regdata)], K = 2)
#' @export
BGM <- function(X,R, K = 2,tolerance = 0.001, nmax = 100){

  tol <- i <- 1
  while (any(tol > tolerance)) {
    pc <- ExtrPC(X,K)$F0
    if (i != 1){
      tol <- pc - ans
    }
    ans <- pc

    xdata <- cbind(pc,R)
    b <- solve(t(xdata) %*% xdata) %*% t(xdata) %*% X
    X <- X - matrix(R,ncol = 1) %*% b[nrow(b),]
    i <- i + 1

    # max iterations
    if (i > nmax) {
      message("reach max iterations when extracting factors, PCs don't converge")
      break()
    }
  }
  return(pc)
}
