#' Impulse Response Function for FAVAR
#'
#' @param fit FAVAR object.
#' @param nvar whose impulse response is computed? It's coloumn index in X.
#' @return a object from \code{ggplot2::ggplot}.
#' @export
irfFAVAR <- function(fit, nvar = 116){
  if (!class(fit) %in% 'favar') stop('fit must be from FAVAR funciton')
  # list as array
  ans <- array(0,dim = c(length(fit$imp),nrow(fit$imp[[1]]),ncol(fit$imp[[1]])))
  for (i in 1:length(fit$imp)) {
    ans[i,,] <- fit$imp[[i]]
  }
  ans <- ans[,,-1]

  irf <- ans[,nvar,]
  picdata <- data.frame(irf = apply(irf, 2, stats::median),
                        up = apply(irf, 2, stats::quantile, probs = 0.9),
                        dw = apply(irf, 2, stats::quantile, probs = 0.1))
  picdata[,'nhor'] <- 1:nrow(picdata)
  p <- ggplot2::ggplot(picdata, ggplot2::aes(x = nhor, y = irf)) + ggplot2::geom_line() +
    ggplot2::geom_line(ggplot2::aes(y = up), linetype = 2) + ggplot2::geom_hline(yintercept = 0) +
    ggplot2::geom_line(ggplot2::aes(y = dw), linetype = 2) + ggplot2::labs(x = '', y= '') +
    ggplot2::theme_bw()
  return(p)
}
