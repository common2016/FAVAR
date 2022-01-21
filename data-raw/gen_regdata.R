## code to prepare `regdata` dataset goes here
rm(list = ls())
library(pacman)
p_load(matlab,R.matlab,tidyverse,MyFun,bvartools,foreach, devtools)
devtools::load_all()

regdata <- readMat('../FAVAR_matlab/regdata.mat')
X <- regdata$X
Y <- regdata$Y
namesXY <- as.character(unlist(regdata$namesXY))
slowcode <- read.table('../FAVAR_matlab/slowcode.dat')
slowcode <- as.logical(unlist(slowcode))
tcode <- readMat('data-raw/tcode.mat')$tcode %>% as.numeric()

colnames(X) <- namesXY[1:115]
colnames(Y) <- namesXY[116:118]

regdata <- cbind(X,Y)
tcode[tcode == 1] <- 'level'
tcode[tcode %in% '5'] <- 'Dln'
tcode[tcode %in% '4'] <- 'ln'
tcode <- c(tcode, rep('level',3))
# save(regdata, slowcode, tcode,file = 'data/regdata.rdata')
