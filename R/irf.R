#' Impulse Response Function for FAVAR
#'
#'
#' Based on a shock to one standard deviation, compute the IRF.
#'
#' @param fit FAVAR object.
#' @param irftype \code{'orth'} is orthogonal IRF, and \code{'gen'} is generalized
#' IRF.
#' @param tcode a scalor \code{'level'} or a vector whose length equal \code{ncol(X)+ncol(Y)}.
#' \code{X,Y} is the parameters of the \code{FAVAR} function. If the variable is taken the
#' logarithm(\code{'ln'}) or the first difference of logarithm(\code{'Dln'}),
#' the IRF needs to return to its level value, and you can set the pamameter.
#' Default is \code{'level'}.
#' @param resvar whose impulse response is computed? It's coloumn index in \code{XY}.
#' It's a scalor or a vector.
#' @param impvar a numeric scalar which is position of variables in VAR equation.
#' If it's \code{NULL} that is default, its postion is the last.
#' @param nhor IRF horizon, default is \code{10}
#' @param ci confidence interval, default is 0.8.
#' @param showplot whether show figure. \code{TRUE} is default.
#'
#' @return A list containing 2 elements. The first element is a object from \code{ggplot2::ggplot}, the
#' second element is raw data for IRF.
#' @examples
#' # see FAVAR function
#' @importFrom dplyr .data
#' @export
#'
irf <- function(fit, irftype = 'orth', tcode = 'level', resvar = 1,
                impvar = NULL, nhor = 10,
                ci = 0.8, showplot = TRUE){
  if (!class(fit) %in% 'favar') stop('fit must be from FAVAR funciton')

  # IRF for every variable
  if (is.null(impvar)) impvar <- fit$model_info$p
  imp <- lapply(1:fit$model_info$nrep,irf_single,
                varrlt = fit$varrlt, Lamb = fit$Lamb,
                type = irftype, impvar = impvar, nhor = nhor, Ynum = ncol(fit$model_info$Y))

  # translate data
  if (!(length(tcode) == 1 &  tcode[1] == 'level')){
    imp <- lapply(imp, function(imp, tcode){
      for (i in 1:length(tcode)){
        if (tcode[i] == 'ln'){
          imp[i,] <- exp(imp[i,]) - 1
        }else if (tcode[i] == 'Dln'){
          imp[i,] <- exp(cumsum(imp[i,])) - 1
        }
      }
      return(imp)
    }, tcode = tcode)
  }


  # list as array
  ans <- array(0,dim = c(length(imp),nrow(imp[[1]]),ncol(imp[[1]])))
  for (i in 1:length(imp)) {
    ans[i,,] <- imp[[i]]
  }
  ans <- ans[,,-1]

  # draw
  ttl <- c(colnames(fit$model_info$X),colnames(fit$model_info$Y))
  p <- vector('list', length(resvar))
  names(p) <- as.character(resvar)
  for (i in resvar) {
    irf <- ans[,i,]
    picdata <- data.frame(irf = apply(irf, 2, stats::median),
                          up = apply(irf, 2, stats::quantile, probs = ci + (1-ci)/2),
                          dw = apply(irf, 2, stats::quantile, probs = (1-ci)/2))
    picdata[,'nhor'] <- 1:nrow(picdata)
    p[[as.character(i)]] <- ggplot2::ggplot(picdata, ggplot2::aes(x = .data$nhor, y = .data$irf)) +
      ggplot2::geom_line() + ggplot2::geom_line(ggplot2::aes(y = .data$up), linetype = 2) +
      ggplot2::geom_hline(yintercept = 0) +
      ggplot2::geom_line(ggplot2::aes(y = .data$dw), linetype = 2) +
      ggplot2::labs(x = '', y= '', title = ttl[i]) +
      ggplot2::theme_bw()
  }

  # print
  if (showplot){
    if (length(resvar) == 1){
      print(p[[1]])
    }else {
      drtxt <- 'p[[1]]'
      for (i in 2:length(p)) {
        drtxt <- paste(drtxt,'+p[[',i,']]', sep = '')
      }
      eval(parse(text = drtxt)) %>% print()
    }
  }

  return(list(p = p, imp = imp))
}
