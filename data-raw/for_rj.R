rm(list = ls())
library(FAVAR)
data("regdata")
# X
head(regdata[,c(2,9,10)])
# Y
head(regdata[,116:118])

# estimate a FAVAR
fit <- FAVAR(Y = regdata[,c("Inflation","Unemployment","Fed_funds")],
             X = regdata[,1:115], slowcode = slowcode,
             nrep = 5000, nburn = 1000, K = 2, plag = 2)
summary(fit, xvar = c(2,9))


library(patchwork)
ans <- irf(fit, resvar = c(2,9,10,28, 42, 46, 77, 91, 92, 108, 109, 111),tcode = tcode,nhor = 20)
# ggsave('data-raw/irf_raw_rj.pdf')

# Boivin
fit_bgm <- FAVAR(Y = regdata[,c("Inflation","Unemployment","Fed_funds")],
             X = regdata[,1:115], fctmethod = 'BGM',
             nrep = 5000, nburn = 1000, K = 2, plag = 2)

fit$Lamb[,]
