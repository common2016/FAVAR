#' Compute Impulse Response for Every Sample of MCMC
#'
#'
#' @param i the \eqn{i}th sample in MCMC
#' @param varrlt estimation results for VAR equations, and it's got by \code{BayesVAR}.
#' @param Lamb a array with 3 dimension. and \code{Lamb[i,,]} is factor loading matrix for factor equations.
#' @param Ynum the \code{ncol(Y)}.
#' @param type \code{'orth'} is orthogonal IRF, and \code{'gen'} is generalized
#' IRF.
#' @param impvar a numeric scalar which is position of variables in VAR equation.
#' If it's \code{NULL} that is default, its position is the last.
#' @param nhor IRF horizon, default is \code{NULL}
#'
#' @return IRF matrix, the dimension is \code{ncol(Xmatrix) + ncol(Y)}x\code{nhor}.
#'


irf_single <- function(i,varrlt, Lamb, Ynum, type = 'orth',impvar = 1, nhor){
  # get information
  p <- sqrt(nrow(varrlt$sigma)) # the number of endogenous variables in VAR
  plag <- nrow(varrlt$A)/(p^2) # the lag order of VAR
  PHI_mat <- matrix(varrlt$A[,i],nrow = p, byrow = FALSE)
  a_sigma <- matrix(varrlt$sigma[,i], nrow = p)
  Lamb <- t(Lamb[i,,])
  Xnum <- nrow(Lamb) # the number of coloumn in X

  # AR to MA
  macoef <- ar2ma(PHI_mat, p = plag, n = nhor, CharValue = FALSE)

  if (type %in% 'orth'){
    shock <- matrix(varrlt$sigma[,i],nrow = p, byrow = FALSE) %>% chol() %>% t()
    d <- diag(diag(shock))
    shock <- solve(d) %*% shock

    impresp <- zeros(p,p*nhor)
    impresp[1:p,1:p] <- shock
    for (j in 1:(nhor-1)){
      impresp[,(j*p+1):((j+1)*p)] <- macoef[[j]]  %*% shock
    }

    # select the jj+p coloumn in every period
    imp_m <- zeros(p,nhor)
    jj <- impvar - p
    for (ij in 1:nhor){
      jj <- jj + p
      imp_m[,ij] <- impresp[,jj]
    }
  }else if (type %in% 'gen'){
    imp_m <- (GI(macoef,a_sigma, imp_var = impvar, unit = 'one') %>%
      as.matrix())[,-length(macoef)]
  }



  irf <- zeros(Xnum + Ynum,nhor)
  irf[1:Xnum,] <- Lamb[1:Xnum,] %*% imp_m
  irf[(nrow(irf)-Ynum+1):nrow(irf),] <- imp_m[(nrow(imp_m)-Ynum+1):nrow(imp_m),]
  return(irf)
}
