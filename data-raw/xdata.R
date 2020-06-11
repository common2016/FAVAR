## code to prepare `xdata` dataset goes here
rm(list = ls())
library(pacman)
p_load(matlab,R.matlab,tidyverse,MyFun,bvartools,foreach)

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

fit <- FAVAR(Y, X, slowcode = NULL,fctmethod = 'BGM',varprior = 'mn',
             nrep = 15000, nburn = 5000, K = 3, plag = 7, nhor = 20,ncores = 6)

fit <- FAVAR(matrix(Y[,ncol(Y)],ncol = 1), X, slowcode,fctmethod = 'BBE',varprior = 'none',
             nrep = 5000, nburn = 1000, K = 3, plag = 7, nhor = 48, delta = 0.091,ncores = 6)

summary.favar(fit,xvar = c(3,5))
irfFAVAR(fit,116)
# usethis::use_data(regdata, overwrite = TRUE)
