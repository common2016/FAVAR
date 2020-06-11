#' FAVAR
#'
#' Estimate a FAVAR model by Bernanke et al. (2005).
#'
#' @param Y a matrix. If only one coloumn, don't set as a vector.
#' @param X a matrix. A large data set. see details.
#' @param slowcode a logical vector
#' @param standerze logical value, wheather standarze X and Y
#' @param fctmethod \code{'BBE'} or \code{'BGM'}. \code{'BBE'}(default) means the fators extracted method by Bernanke et al. (2005),
#' and \code{'BGM'} means the fators extracted method by Boivin et al. (2009).
#' @param \code{'none'} or \code{'mn'}, varprior prior setting for VAR. \code{'none'} means noninformative prior, and
#' \code{'mn'} means Minnesota prior.
#' @param K number of factors.
#' @param plag lag order in the VAR equation
#' @param nhor IRF horizon, default is \code{NULL}
#' @param ncores the number of CPU cores in parallel computations.
#'
#' @references
#' [1] Bernanke, B.S., J. Boivin and P. Eliasz, Measuring the Eeefects of Monetary Policy:
#' A Factor-Augmented Vector Autoregressive (FAVAR) Approach. Quarterly Journal of Economics, 2005. 120(1): p. 387-422.
#'
#' [2] Boivin, J., M.P. Giannoni and I. Mihov, Sticky Prices and Monetary Policy: Evidence
#'  from Disaggregated US Data. American Economic Review, 2009. 99(1): p. 350-384.
#'
#' @import foreach
#' @export
FAVAR <- function(Y, X, slowcode,standerze = TRUE, fctmethod = 'BBE',
                  varprior = 'none',nrep = 15000, nburn = 5000, K = 2, plag = 2, nhor = NULL, delta = 2.73,
                  ncores = 1){

  p <- K + ncol(Y)
  # standardize X
  if (standerze){
    X <- scale(X)
    Y <- scale(Y)
  }

  F0 <- ExtrPC(X,K)$F0
  # Lf <- ExtrPC(X_st,K)$Lf

  # extract factors
  xslow <- X[,slowcode]
  Fslow0 <- ExtrPC(xslow,K)$F0
  if (fctmethod %in% 'BBE'){
    Fr0 <- facrot(F0, matrix(Y[,ncol(Y)],ncol = 1),Fslow0)
  }else if (fctmethod %in% 'BGM'){
    Fr0 <- BGM(X, Y[,ncol(Y)], niter = 40)
  }

  Y = scale(Y,center = FALSE)

  # For 2 equations
  XY <-  cbind(X,Y)
  FY <- cbind(Fr0, Y)

  L <- t(olssvd(XY, FY))
  SIGMA <- (t(XY - FY %*% t(L)) %*% (XY - FY %*% t(L)))/nrow(Y)
  SIGMA <- diag(diag(SIGMA))


  Li_prvar <- 4 * matlab::eye(p) # prior on Li ~ N(o,I)
  a <- b <- 0.01 # prior on SIGMA ~ iG(a,b)

  # X = F + Y: sampling
  Lamb <- array(0,dim = c(nrep,p+1,ncol(X)))
  for (i in 1:ncol(X)) {
    meddata <- data.frame(dep = X[,i]) %>% cbind(as.data.frame(FY))
    ans <- MCMCpack::MCMCregress(dep ~ .-1, data = meddata, burnin = nburn, mcmc = nrep,
                                 B0 = Li_prvar, sigma.mu = SIGMA[i,i], c0 = a, d0 = b,
                                 b0 = 0)
    Lamb[,,i] <- ans
  }

  # VAR: sampling
  z <- ts(FY,1,nrow(FY))
  ifelse (is.null(colnames(Y)),
          colnames(z) <- c(paste('factor',as.character(1:K),sep = ''),paste('Y',as.character(1:ncol(Y)),sep = '')),
          colnames(z) <- c(paste('factor',as.character(1:K),sep = ''),colnames(Y)))


  varrlt <- BayesVAR(z, plag, iter = nrep+nburn, burnin = nburn, prior = varprior, type = 'none',ncores = ncores)

  # compute IRF?
  imp <- NULL
  if (!is.null(nhor)){
    # Chol dev
    shock_init <- diag(c(zeros(1,p-1), 1/delta)) # in terms of standard deviation, identification is recursive
    # initialize
    cl <- parallel::makeCluster(ncores)
    doParallel::registerDoParallel(cl)
    ans <- zeros(ncol(Y) + ncol(X),nhor)
    imp <- foreach::foreach (i = 1:ncol(varrlt$A), .packages = c('matlab','MyFun','tidyverse')) %dopar% {
      PHI_mat <- matrix(varrlt$A[,i],nrow = p, byrow = FALSE)
      macoef <- ar2ma(PHI_mat, p = plag, n = nhor, CharValue = FALSE)

      shock <- matrix(varrlt$sigma[,i],nrow = p, byrow = FALSE) %>% chol() %>% t()
      d <- diag(diag(shock))
      shock <- solve(d) %*% shock

      impresp <- zeros(p,p*nhor)
      impresp[1:p,1:p] <- shock
      # bigai <- biga
      for (j in 1:(nhor-1)){
        impresp[,(j*p+1):((j+1)*p)] <- macoef[[j]]  %*% shock
      }

      # select the last coloumn in every period
      imp_m <- zeros(p,nhor)
      jj <- 0
      for (ij in 1:nhor){
        jj <- jj + p
        imp_m[,ij] <- impresp[,jj]
      }

      ans[1:ncol(X),] <- t(Lamb[i,1:p,]) %*% imp_m
      ans[(nrow(ans)-ncol(Y)+1):nrow(ans),] <- imp_m[(nrow(imp_m)-ncol(Y)+1):nrow(imp_m),]
      ans
    }
    parallel::stopCluster(cl)
  }
  rlt <- list(Lamb = Lamb, varrlt = varrlt, imp = imp)
  class(rlt) <- 'favar'
  return(rlt)
}
