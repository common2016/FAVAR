#' Generalized Impulse Response Function (GIRF)
#'
#' Compute GIRF of linear VAR by Koop et al. (1996)
#'
#' @param ma a list, it's MA coefficients from \code{ar2ma}
#' @param sig_u a covariance matrix from VAR models. Note the order of variables in \code{sig_u}
#' is same with one of \code{ma[[i]]}.
#' @param imp_var a numerical scalar which specifies the impulse variable.
#' @param unit \code{'sd'} is one standard deviation shock which is default,
#'  and \code{'one'} is one unit shock.
#' @return a data frame, its row is variables and its column is horizons.
#' @references Koop, G., M.H. Pesaran and S. Potter, Impulse Response Analysis
#' in Nonlinear Multivariate Models. Journal of Econometrics, 1996. 74: p. 119-147.
#' @importFrom  magrittr `%>%`


GI <- function(ma, sig_u, imp_var = 1, unit = 'sd'){

  # the t period IRF
  GI_single <- function(ans, imp_var){
    ell <- zeros(nrow(ans),1)
    ell[imp_var] <- 1
    # GVAR toolbox p140, A.22
    if (unit %in% 'sd'){
      irf_single <- (ans %*% sig_u %*% ell)/(as.numeric(sqrt(t(ell) %*% sig_u %*% ell)))
    } else if (unit %in% 'one'){
      irf_single <- (ans %*% sig_u %*% ell)/(as.numeric(t(ell) %*% sig_u %*% ell))
    }
    return(irf_single)
  }

  irf <- lapply(ma, GI_single, imp_var = imp_var)
  ans <- dplyr::bind_cols(irf) %>% as.data.frame()
  row.names(ans) <- row.names(ma[[2]])
  return(ans)
}
