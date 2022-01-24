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

library(ggplot2)
library(patchwork)
ans <- irf(fit, resvar = c(2,9,10,28, 42, 46, 77, 91, 92, 108, 109, 111),tcode = tcode,nhor = 20)
# ggsave('data-raw/irf_raw_rj.pdf')

# Boivin
fit_bgm <- FAVAR(Y = regdata[,c("Inflation","Unemployment","Fed_funds")],
             X = regdata[,1:115], fctmethod = 'BGM',
             nrep = 5000, nburn = 1000, K = 2, plag = 2)

library(stargazer)
fct_cmp <- cbind(fit$factorx, fit_bgm$factorx)
colnames(fct_cmp) <- c('bee_fct1','bee_fct2','bgm_fct1','bgm_fct2')
stargazer(fct_cmp[,c('bee_fct1','bgm_fct1','bee_fct2','bgm_fct2')],type = 'text',summary = T)

ans <- irf(fit_bgm, resvar = c(2,9,10,28, 42, 46, 77, 91, 92, 108, 109, 111),tcode = tcode,nhor = 20)
# ggsave('data-raw/irf_bgm_rj.pdf')

# Minnesota prior
fit_mn <- FAVAR(Y = regdata[,c("Inflation","Unemployment","Fed_funds")],
             X = regdata[,1:115], slowcode = slowcode,
             varprior = list(mn = list(kappa0 = 0.7, kappa1 = 1), nu0 = 0, s0 = 0),
             nrep = 15000, nburn = 5000, K = 2, plag = 2, ncores = 2)
ans <- irf(fit_mn, resvar = c(2,9,10,28, 42, 46, 77, 91, 92, 108, 109, 111),tcode = tcode,nhor = 20)
# ggsave('data-raw/irf_mn_rj.pdf')

# Generalized IRF
ans <- irf(fit,irftype = 'gen', resvar = c(2,9,10,28, 42, 46, 77, 91, 92, 108, 109, 111),tcode = tcode,nhor = 20)
# ggsave('data-raw/irf_gen_rj.pdf')
