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

fit <- FAVAR(Y, X, slowcode,fctmethod = 'BBE', nrep = 500, nburn = 100, K = 2, plag = 2, nhor = 20)
class(fit)

irfFAVAR(fit,118)
# usethis::use_data(xdata, overwrite = TRUE)
