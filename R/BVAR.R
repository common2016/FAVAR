#' Bayesian Estimation of VAR
#'
#' Estimate a VAR base on Bayesian method
#'
#' @param data a \code{ts} object which include all endogenous variables in VAR
#' @param plag a lag order in VAR
#' @param iter iterations of the MCMC
#' @param burnin the first random draws discarded in MCMC
#' @param prior a list whose elements is named. \code{b0} is the prior of mean of \eqn{\beta},
#' and \code{vb0} is the prior of the variance of \eqn{\beta}. \code{nu0} is the degree of freedom
#' of Wishart distribution for \eqn{\Sigma^{-1}}, i.e., a shape parameter, and \code{s0^{-1}} is
#' scale parameters for the Wishart distribution. \code{mn} sets the Minnesota prior. If
#' \code{prior$mn$kappa0} is not \code{NULL}, \code{b0,vb0} is neglected.
#' @param ncores the number of CPU cores in parallel computations.
#'
#' @return a list:
#' \itemize{
#' \item \code{A}, the samples drawn for the coefficients of VAR
#' \item \code{sigma}, the samples drawn for the variance-covariance of the coefficients of VAR
#' \item \code{sumrlt}, a list include \code{varcoef, varse, q25, q975} which are
#'  means, standard errors, 0.25 quantiles and 0.975 quantiles of \code{A}.
#' }
#' @importFrom  magrittr `%>%`
#' @importFrom foreach `%dopar%`

BVAR <- function(data, plag =2, iter = 10000, burnin = 5000,
                 prior = list(b0 = 0,vb0 = 0, nu0 = 0, s0 = 0,
                              mn = list(kappa0 = NULL, kappa1 = NULL)),
                 ncores = 1){

  data <- bvartools::gen_var(data, p = plag, deterministic = 'none')
  y <- t(data$data$Y) # transpose is for post_normal
  x <- t(data$data$Z)

  # OLS
  A_freq <- tcrossprod(y, x) %*% solve(tcrossprod(x))
  u_freq <- y - A_freq %*% x  # # sigma
  u_sigma_freq <- tcrossprod(u_freq) / (ncol(y) - nrow(x))
  store <- iter - burnin

  tnum <- ncol(y) # Number of observations
  k <- nrow(y) # Number of endogenous variables
  m <- k * nrow(x) # Number of estimated coefficients

  # Set priors
  if (is.null(prior$mn$kappa0)){
    a_mu_prior <- matrix(prior$b0, m) # Vector of prior parameter means
    a_v_i_prior <- diag(prior$vb0, m) # Inverse of the prior covariance matrix
  } else {
    ans <- bvartools::minnesota_prior(data,kappa0 =  prior$mn$kappa0,
                                      kappa1 = prior$mn$kappa1)
    a_mu_prior <- ans$mu
    a_v_i_prior <- ans$v_i
  }
  u_sigma_df_prior <- prior$nu0 # Prior degrees of freedom
  if (is.null(prior$s0)) stop('you should set the prior of nu0 and s0')
  u_sigma_scale_prior <- matrix(prior$s0, k, k) # Prior covariance matrix
  u_sigma_df_post <- tnum + u_sigma_df_prior # Posterior degrees of freedom

  # Initial values
  u_sigma_i <- diag(.00001, k)
  u_sigma <- solve(u_sigma_i)

  # Start Gibbs sampler
  draw <- NULL
  cl <- parallel::makeCluster(ncores)
  doParallel::registerDoParallel(cl)
  draw_a_sigma <-
    foreach::foreach (draw = 1:iter,.packages = c('bvartools')) %dopar% {
    # Draw conditional mean parameters
    a <- bvartools::post_normal(y, x, u_sigma_i, a_mu_prior, a_v_i_prior)

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


  # delete NULL
  draw_a_sigma <- draw_a_sigma[!as.logical(lapply(draw_a_sigma, is.null))]

  # list as matrix
  draws_a <- lapply(draw_a_sigma, function(x) x[['a']]) %>% dplyr::bind_cols() %>%
    as.matrix() %>% suppressMessages()
  draws_sigma <- lapply(draw_a_sigma, function(x) matrix(x[['u_sigma']],ncol = 1)) %>%
    dplyr::bind_cols() %>% as.matrix() %>% suppressMessages()

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
