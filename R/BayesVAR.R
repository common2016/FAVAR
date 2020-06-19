#' Bayesian Estimation of VAR
#'
#' Estimate a VAR base on bayesian method
#'
#' @param data a matrix which include all endogenous variables in VAR
#' @param plag a lag order in VAR
#' @param iter iterations of the MCMC
#' @param burnin
#' @param prior prior setting for VAR
#' @param type \code{'none','drift'} or \code{'trend'}
#' @import bvartools
#' @export
BayesVAR <- function(data, plag =2, iter = 10000, burnin = 5000, prior = 'none', type = 'none',
                     ncores = 1){
  data <- gen_var(data, p = plag, deterministic = type)
  y <- data$Y
  x <- data$Z
  # OLS
  A_freq <- tcrossprod(y, x) %*% solve(tcrossprod(x)) # A estimation
  u_freq <- y - A_freq %*% x  # # sigma
  u_sigma_freq <- tcrossprod(u_freq) / (ncol(y) - nrow(x))
  store <- iter - burnin

  tnum <- ncol(y) # Number of observations
  k <- nrow(y) # Number of endogenous variables
  m <- k * nrow(x) # Number of estimated coefficients

  # Set priors
  if (prior %in% 'none'){
    a_mu_prior <- matrix(0, m) # Vector of prior parameter means
    a_v_i_prior <- diag(0, m) # Inverse of the prior covariance matrix
  }else if (prior %in% 'mn'){
    ans <- minnesota_prior(data,0.7,1)
    a_mu_prior <- ans$mu
    a_v_i_prior <- ans$v_i
  }
  u_sigma_df_prior <- 0 # Prior degrees of freedom
  u_sigma_scale_prior <- diag(0, k) # Prior covariance matrix
  u_sigma_df_post <- tnum + u_sigma_df_prior # Posterior degrees of freedom

  # Initial values
  u_sigma_i <- diag(.00001, k)
  u_sigma <- solve(u_sigma_i)

  # Start Gibbs sampler
  cl <- parallel::makeCluster(ncores)
  doParallel::registerDoParallel(cl)
  draw_a_sigma <- foreach (draw = 1:iter,.packages = c('bvartools')) %dopar% {
    # Draw conditional mean parameters
    a <- post_normal(y, x, u_sigma_i, a_mu_prior, a_v_i_prior)

    # Draw variance-covariance matrix
    u <- y - matrix(a, k) %*% x # Obtain residuals
    u_sigma_scale_post <- solve(u_sigma_scale_prior + tcrossprod(u))
    u_sigma_i <- matrix(stats::rWishart(1, u_sigma_df_post, u_sigma_scale_post)[,, 1], k)
    u_sigma <- solve(u_sigma_i) # Invert Sigma_i to obtain Sigma

    # Store draws
    if (draw > burnin) {
      ans <- list(a = a,u_sigma = u_sigma)
    }
  }
  parallel::stopCluster(cl)

  # list as matrix
  draws_a <- matrix(NA, m, store)
  draws_sigma <- matrix(NA, k^2, store)
  for (draw in 1:iter) {
    if (draw > burnin) {
      draws_a[, draw - burnin] <- draw_a_sigma[[draw]]$a
      draws_sigma[, draw - burnin] <- draw_a_sigma[[draw]]$u_sigma
    }
  }

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
