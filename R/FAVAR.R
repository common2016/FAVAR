#' FAVAR
#'
#' Estimate a FAVAR model by Bernanke et al. (2005).
#'
#' @param Y a matrix. Observable economic variables assumed to drive the dynamics of the economy.
#' @param X a matrix. A large macro data set. The meanings of \code{X} and \code{Y} is same as ones of Bernanke et al. (2005).
#' @param fctmethod \code{'BBE'} or \code{'BGM'}. \code{'BBE'}(default) means the fators extracted method by Bernanke et al. (2005),
#' and \code{'BGM'} means the fators extracted method by Boivin et al. (2009).
#' @param slowcode a logical vector that Identifies which columns of X are slow
#' moving. Only when \code{fctmethod} is set as \code{'BBE'}, \code{slowcode} is valid.
#' @param K the number of factors extraced from \code{X}.
#' @param plag the lag order in the VAR equation.
#' @param factorprior A list whose elements is named sets the prior for the factor equation.
#'  \code{b0} is the prior of mean of regression coeffients \eqn{\beta},and \code{vb0} is the prior of the variance
#'  of \eqn{\beta}, and \code{c0/2} and \code{d0/2} are prior pamameters of the variance of the error
#'  \eqn{\sigma^{-2}}, and they are
#'   the shape and scale parameters of Gamma distribution, respectively.
#' @param varprior A list whose elements is named sets the prior of VAR equations.
#'  \code{b0} is the prior of mean of VAR coeffients \eqn{\beta}, and \code{vb0} is the prior
#'  of the variance of \eqn{\beta}, it's a scalor that means priors of variance is same, or a
#'  vector whoes length equals the length of \eqn{\beta}. \code{nu0} is the degree of freedom
#' of Wishart distribution for \eqn{\Sigma^{-1}}, i.e., a shape parameter, and \code{s0} is a inverse
#' scale parameter for the Wishart distribution, and it's a matrix with
#' \code{ncol(s0)=nrow(s0)=}the number of endogenous variables in VAR. If it's a scalor, it means
#' the entry of the matrix is same. \code{mn} sets the Minesota prior. If
#' \code{varprior$mn$kappa0} is not \code{NULL}, \code{b0,vb0} is neglected.
#' \code{mn}'s element \code{kappa0} controls the
#' tightness of the prior variance for self-variables lag coefficients, the prior variance
#' is \eqn{\kappa_0/lag^2}, another element \code{kappa1} controls the cross-variables lag
#' coefficients spread, the prior variance is
#' \eqn{\frac{\kappa_0\kappa_1}{lag^2}\frac{\sigma_m^2}{\sigma_n^2}, m\ne n}. See details.
#' @param nburn the number of the first random draws discarded in MCMC.
#' @param nrep the number of the saved draws in MCMC.
#' @param standardize Wheather standardize? We suggest it does, because in the function
#' VAR equation and factor equaion both don't include intercept.
#' @param ncores the number of CPU cores in parallel computations.
#'
#' @details Here we simply state the prior distribution setting of VAR. VAR could be writen by (koop and Korobilis, 2010),
#' \deqn{y_t= Z_t\beta + \varepsilon_t, \varepsilon_t\sim N(0,\Sigma)}
#' You can write down it according to data matrix,
#' \deqn{Y= Z\beta + \varepsilon, \varepsilon\sim N(0,I\otimes \Sigma)}
#' where \eqn{Y = (y_1,y_2,\cdots, y_T)',Z=(Z_,Z_2,\cdots,Z_T)',\varepsilon=(\varepsilon_1,\varepsilon_2,\cdots,\varepsilon_T)}. We assume that prior distribution of \eqn{\beta} and \eqn{\Sigma^{-1}} is,
#' \deqn{\beta\sim N(b0,V_{b0}), \Sigma^{-1}\sim W(S_0^{-1},\nu_0)}
#' Or you can set the Minesota prior for variance of \eqn{\beta}, for example,
#' for the mth equaion in \eqn{y_t= Z_t\beta + \varepsilon_t},
#' \itemize{
#' \item \eqn{\frac{\kappa_0}{l^2},l} is lag order, for won lags of endogenous variables
#' \item \eqn{\frac{\kappa_0\kappa_1}{l^2}\frac{\sigma_m^2}{\sigma_n^2}, m\ne n},for lags of other endogenous variables in the mth equation,
#' where \eqn{\sigma_m} is the standard error for residuals of the mth equaion.
#' }
#' Based on the priors, you could get corresponding post distribution for the paramters
#'  by Markov Chain Monte Carlo (MCMC) algorithm.  More details, see koop and Korobilis (2010).
#'
#' @return a class \code{favar}.
#' \describe{
#' \item{varrlt}{A list. The estimation results of VAR including estimated coefficients
#'  \code{A}, their variance-covariance matrix \code{sigma}, and other statistical summary for \code{A}.}
#' \item{Lamb}{A array with 3 dimension. and \code{Lamb[i,,]} is factor loading matrix
#' for factor equations in the ith sample of MCMC.}
#' \item{factorx}{Extracted factors from \code{X}}
#' \item{model_info}{Model information containing \code{nburn,nrep,X,Y} and \code{p}, the number of endogenous variables
#' in the VAR.}
#' }
#'
#'
#'
#' @references
#' 1. Bernanke, B.S., J. Boivin and P. Eliasz, Measuring the Eeefects of Monetary Policy:
#' A Factor-Augmented Vector Autoregressive (FAVAR) Approach. Quarterly Journal of Economics, 2005. 120(1): p. 387-422.
#'
#' 2. Boivin, J., M.P. Giannoni and I. Mihov, Sticky Prices and Monetary Policy: Evidence
#'  from Disaggregated US Data. American Economic Review, 2009. 99(1): p. 350-384.
#'
#' 3.	Koop, G. and D. Korobilis, Bayesian Multivariate Time Series Methods for Empirical Macroeconomics. 2010: Now Publishers.
#'
#' @export
#' @examples
#' data('regdata')
#' fit <- FAVAR(Y = regdata[,c("Inflation","Unemployment","Fed_funds")],
#'              X = regdata[,1:115], slowcode = slowcode,fctmethod = 'BBE',
#'              factorprior = list(b0 = 0, vb0 = NULL, c0 = 0.01, d0 = 0.01),
#'              varprior = list(b0 = 0,vb0 = 10, nu0 = 0, s0 = 0),
#'              nrep = 500, nburn = 100, K = 2, plag = 2)
#' # print FAVAR estimation results
#' summary(fit,xvar = c(3,5))
#' # or extract coefficients
#' coef(fit)
#' # plot impulse response figure
#' library(patchwork)
#' dt_irf <- irf(fit,resvar = c(2,9,10))
FAVAR <- function(Y, X, fctmethod = 'BBE', slowcode,K = 2, plag = 2,
                  factorprior = list(b0 = 0, vb0 = NULL, c0 = 0.01, d0 = 0.01),
                  varprior = list(b0 = 0,vb0 = 0, nu0 = 0, s0 = 0,
                                  mn = list(kappa0 = NULL, kappa1 = NULL)),
                  nburn = 5000, nrep = 15000,
                  standardize = TRUE, ncores = 1){
  # standardize
  if (standardize){
    X <- scale(X)
    Y <- scale(Y)
  }
  p <- K + ncol(Y)

  # extract PC
  F0 <- ExtrPC(X,K)$F0

  # extract factors
  if (fctmethod %in% 'BBE'){
    xslow <- X[,slowcode]
    Fslow0 <- ExtrPC(xslow,K)$F0
    Fr0 <- facrot(F0, matrix(Y[,ncol(Y)],ncol = 1),Fslow0)
  }else if (fctmethod %in% 'BGM'){
    Fr0 <- BGM(X, Y[,ncol(Y)], K = K)
  }

  # For 2 equations
  XY <-  cbind(X,Y)
  FY <- cbind(Fr0, Y)
  L <- t(olssvd(XY, FY))

  # estimate factor equations
  # prior on Li ~ N(o,I)
  ifelse (is.null(factorprior$B0),
          Li_prvar <- 4 * matlab::eye(p),
          Li_prvar <- factorprior$B0)

  # regress per coloum of X on FY
  factor_reg <- function(n, Xmatrix, FY, K, nburn, nrep, b0, B0, c0, d0){
    meddata <- cbind(data.frame(dep = Xmatrix[,n]), as.data.frame(FY))
    if (n > K){
      ans <- MCMCpack::MCMCregress(dep ~ .-1, data = meddata, burnin = nburn, mcmc = nrep,
                                   B0 = B0, c0 = c0, d0 = d0, b0 = b0)
      Lamb <- ans[,1:(K + ncol(Y))]
    } else Lamb <- matlab::repmat(L[n,],c(nrep,1))
    return(Lamb)
  }
  # parallel
  cl <- parallel::makeCluster(ncores)
  parallel::clusterEvalQ(cl,{
    library(MCMCpack)
    library(matlab)
  }) %>% invisible()
  ans <- parallel::parLapply(cl, 1:ncol(X), factor_reg, Xmatrix = X, FY = FY, K = K, nburn = nburn,
                      nrep = nrep, b0 = factorprior$b0, B0 = Li_prvar,
                      c0 = factorprior$c0, d0 = factorprior$d0)
  parallel::stopCluster(cl)
  Lamb <- vapply(1:length(ans), function(i,x) x[[i]], FUN.VALUE = matrix(0,nrep,p), x = ans)

  # estimate VAR equations
  z <- stats::ts(FY,1,nrow(FY))
  ifelse (is.null(colnames(Y)),
          colnames(z) <- c(paste('factor',as.character(1:K),sep = ''),paste('Y',as.character(1:ncol(Y)),sep = '')),
          colnames(z) <- c(paste('factor',as.character(1:K),sep = ''),colnames(Y)))
  varrlt <- BVAR(z, plag, iter = nrep+nburn, burnin = nburn, prior = varprior, ncores = ncores)

  rlt <- list(varrlt = varrlt, Lamb = Lamb, factorx = Fr0,
              model_info = list(nburn = nburn, nrep = nrep, X = X, Y = Y, p = p))
  class(rlt) <- 'favar'
  return(rlt)
}
