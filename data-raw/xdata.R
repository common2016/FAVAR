## code to prepare `xdata` dataset goes here
rm(list = ls())
library(pacman)
p_load(matlab,R.matlab,tidyverse,MyFun,bvartools)

devtools::load_all()

if (FALSE){
  regdata <- readMat('../FAVAR_matlab/regdata.mat')
  X <- regdata$X
  Y <- regdata$Y
  namesXY <- as.character(unlist(regdata$namesXY))
  slowcode <- read.table('../FAVAR_matlab/slowcode.dat')
  slowcode <- as.logical(unlist(slowcode))
  save(X,Y,namesXY,slowcode, file = 'data-raw/regdata.rdata')
}else load('data-raw/regdata.rdata')

regdata <- cbind(X,Y) %>% as.data.frame()
colnames(regdata) <- namesXY
regdata$slowcode <- c(slowcode,rep(NA,75))


fit <- FAVAR(Y, X, slowcode,fctmethod = 'BBE',varprior = 'mn',
             nrep = 500, nburn = 100, K = 2, plag = 2, nhor = 20)

fit <- FAVAR(matrix(Y[,ncol(Y)],ncol = 1), X, slowcode,fctmethod = 'BBE',varprior = 'none',
             nrep = 5000, nburn = 1000, K = 3, plag = 7, nhor = 48, delta = 0.091)

summary.favar(fit,xvar = c(3,5))

irfFAVAR(fit,116)
# usethis::use_data(regdata, overwrite = TRUE)
