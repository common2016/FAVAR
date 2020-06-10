#' Impulse Response Function for FAVAR
#'
#' @param fit
#' @param nvar
#' @return a object from \code{ggplot2::ggplot}.
#' @export
irfFAVAR <- function(fit, nvar = 116){
  if (!class(fit) %in% 'favar') stop('fit must be from FAVAR funciton')

  irf <- fit$imp[,nvar,]
  picdata <- data.frame(irf = apply(irf, 2, median),
                        up = apply(irf, 2, quantile, probs = 0.9),
                        dw = apply(irf, 2, quantile, probs = 0.1))
  picdata$nhor <- 1:nrow(picdata)
  p <- ggplot2::ggplot(picdata, aes(x = nhor, y = irf)) + ggplot2::geom_line() +
    ggplot2::geom_line(aes(y = up), linetype = 2) + ggplot2::geom_hline(yintercept = 0) +
    ggplot2::geom_line(aes(y = dw), linetype = 2) + ggplot2::labs(x = '', y= '') +
    ggplot2::theme_bw()
  return(p)
}
