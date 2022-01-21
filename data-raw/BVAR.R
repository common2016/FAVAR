#' Bayesian Estimation of VAR
#'
#' Estimate a VAR base on bayesian method
#'
#' @param data a matrix which include all endogenous variables in VAR
#' @param plag a lag order in VAR
#' @param iter iterations of the MCMC
#' @param burnin
#' @param prior \code{'none'} or \code{'mn'}. The \code{'none'} means no information
#' prior, and the \code{mn} means Minnesota prior.
#' @param type \code{'none','drift'} or \code{'trend'}
#'
#' @return a list:
#' @import bvartools
#' @export
BVAR <- function(data, plag =2, iter = 10000, burnin = 5000, prior = 'none', type = 'none',
                     ncores = 1){

  data <- bvartools::gen_var(data, p = plag, deterministic = type)
  y <- data$data$Y
  x <- data$data$Z

  # OLS
  A <- solve(t(x) %*% x) %*% t(x) %*% y
  u <- y - x %*% A  # residuls
  u_sigma <- cov(u) # sigma

  tnum <- nrow(y) # Number of observations
  k <- ncol(y) # Number of endogenous variables
  m <- k * ncol(x) # Number of estimated coefficients

  if (prior %in% 'none'){
    # get post parameters
    a_mu_post <- matrix(t(A), ncol = 1)
    a_v_post <- u_sigma %x% solve(t(x) %*% x)
    u_sigma_scale <- solve(u_sigma)
    u_sigma_df <- tnum - k - m

    draws_a <- SimDesign::rmvnorm(iter - burnin, a_mu_post, a_v_post)
    draws_sigma <- stats::rWishart(iter - burnin, df = u_sigma_df, Sigma = u_sigma_scale)[,,1] %>% solve()
  } else if (prior %in% 'mn'){

  } else if (prior %in% 'ntconj'){

  }

  browser()


  # summarize results
  ans <- coda::mcmc(t(draws_a)) %>% summary()
  varcoef <- matrix(ans$statistics[,'Mean'], nrow = k)
  varse <- matrix(ans$statistics[,'Naive SE'], nrow = k)
  q25 <- matrix(ans$quantiles[,'2.5%'], nrow = k)
  q975 <- matrix(ans$quantiles[,'97.5%'], nrow = k)
  colnames(q25) <- colnames(q975) <- colnames(varcoef) <- colnames(varse) <- colnames(A_freq)
  rownames(q25) <- rownames(q975) <- rownames(varcoef) <- rownames(varse) <- rownames(A_freq)

  return(list(A = draws_a, sigma = draws_sigma,
              sumrlt = list(varcoef = varcoef, varse = varse,
                            q25 = q25, q975 = q975)))
}
