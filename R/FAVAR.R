#' FAVAR
#'
#' Estimate a FAVAR by Bernanke et al. (2005).
#'
#' @param slowcode a logical vector
#' @param standerze logical value, wheather standarze X and Y
#' @param fctmethod \code{'BBE'} or \code{'BGM'}. \code{'BBE'}(default) means the fators extracted method by Bernanke et al. (2005),
#' and \code{'BGM'} means the fators extracted method by Boivin et al. (2009).
#' @param K number of factors.
#' @param plag lag order in the VAR equation
#' @param nhor IRF horizon, default is \code{NULL}
#'
#' @references
#' [1] Bernanke, B.S., J. Boivin and P. Eliasz, Measuring the Eeefects of Monetary Policy:
#' A Factor-Augmented Vector Autoregressive (FAVAR) Approach. Quarterly Journal of Economics, 2005. 120(1): p. 387-422.
#'
#' [2] Boivin, J., M.P. Giannoni and I. Mihov, Sticky Prices and Monetary Policy: Evidence
#'  from Disaggregated US Data. American Economic Review, 2009. 99(1): p. 350-384.
#'
#' @export
FAVAR <- function(Y, X, slowcode,standerze = TRUE, fctmethod = 'BBE', nrep = 15000, nburn = 5000, K = 2, plag = 2, nhor = NULL, delta = 2.73){

  #
  p <- K + ncol(Y)
  if (standerze){
    X <- scale(X)
    Y <- scale(Y)
  }

  # standardize X

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

  # For 2 equation
  XY <-  cbind(X,Y)
  FY <- cbind(Fr0, Y)

  L <- t(olssvd(XY, FY))
  SIGMA <- (t(XY - FY %*% t(L)) %*% (XY - FY %*% t(L)))/nrow(Y)
  SIGMA <- diag(diag(SIGMA))

  Li_prvar <- 4 * matlab::eye(p) # prior on Li ~ N(o,I)
  a <- b <- 0.01 # prior on SIGMA ~ iG(a,b)
  # browser()

  # X = F + Y: sampling
  Lamb <- array(0,dim = c(nrep,p+1,ncol(X)))
  for (i in 1:ncol(X)) {
    meddata <- data.frame(dep = X[,i]) %>% cbind(as.data.frame(FY))
    ans <- MCMCpack::MCMCregress(dep ~ .-1, data = meddata, burnin = nburn, mcmc = nrep,
                                 B0 = Li_prvar, sigma.mu = SIGMA[i,i], c0 = a, d0 = b,
                                 b0 = matrix(0, 5))
    Lamb[,,i] <- ans
  }

  # VAR: sampling
  z <- ts(FY,1,nrow(FY))
  varrlt <- BayesVAR(z, plag, iter = nrep+nburn, burnin = nburn, prior = 'none', type = 'none')

  # compute IRF?
  imp <- NULL
  if (!is.null(nhor)){
    # Chol dev
    shock_init <- diag(c(zeros(1,p-1), 1/delta)) # in terms of standard deviation, identification is recursive
    # initialize
    imp <- zeros(nrep,ncol(Y) + ncol(X),nhor)
    for (i in 1:ncol(varrlt$A)) {
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

      imp[i,1:ncol(X),] <- t(Lamb[i,1:p,]) %*% imp_m
      imp[i,(dim(imp)[2]-2):dim(imp)[2],] <- imp_m[(nrow(imp_m)-2):nrow(imp_m),]
    }
    imp <- imp[,,-1]
  }
  rlt <- list(Lamb = Lamb, varrlt = varrlt, imp = imp)
  class(rlt) <- 'favar'
  return(rlt)
}
