#' Print Results of FAVAR
#'
#' @param favar a object from function \code{FAVAR}.
#' @param xvar a numeric vector, which variables in \code{X} was printed. It's a index.
#' If it's \code{NULL}, estimation results for X = F + Y is not printed.
#'
#' @export
summary.favar <- function(favar, xvar = NULL){
  if (!class(favar) %in% 'favar') stop('favar must be from favar funciton')

  # print VAR for FY
  for (i in 1:nrow(favar$varrlt$sumrlt$varcoef)) {
    paste('Estimation VAR results for equation',rownames(favar$varrlt$sumrlt$varcoef)[i]) %>%
      cat('\n')
    cat('-------------\n')
    data.frame(Estimate = favar$varrlt$sumrlt$varcoef[i,],
               se = favar$varrlt$sumrlt$varse[i,],
               q025 = favar$varrlt$sumrlt$q25[i,],
               q975 = favar$varrlt$sumrlt$q975[i,]) %>% round(4) %>% print()
    cat('--------------\n')  }

  # print X = FY
  if (!is.null(xvar)){
      cat('\n===========================================\n')
    for (i in xvar) {
      sprintf('Estimation results for the %dth equation in X = FY',i) %>%
        cat('\n------------\n')
     ans <- coda::mcmc(favar$Lamb[,,i]) %>% summary()
     ans <- data.frame(loading = ans$statistics[,'Mean'],
               loading_se = ans$statistics[,'Naive SE'],
               q025 = ans$quantiles[,'2.5%'],
               q975 = ans$quantiles[,'97.5%'])
     ans <- ans[-1,]
     rownames(ans) <- rownames(favar$varrlt$sumrlt$varcoef)
     print(ans)
     cat('-------------\n')
    }
  }
  NextMethod('summary')
}

