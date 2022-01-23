## code to prepare `xdata` dataset goes here
rm(list = ls())
library(pacman)
p_load(matlab,R.matlab,tidyverse, bvartools,foreach, devtools, patchwork)

# 该命令也会导入外部数据
devtools::load_all()
# 可以呈现数据
data('regdata')


# fit <- FAVAR(Y, X, slowcode = NULL,fctmethod = 'BGM',varprior = 'none',
#              nrep = 15000, nburn = 5000, K = 2, plag = 2, nhor = 22, ncores = 10)

# bernake (2005)的慢动速动抽取方法
ans <- Sys.time()
fit <- FAVAR(Y = regdata[,c("Inflation","Unemployment","Fed_funds")],
             X = regdata[,1:115], slowcode = slowcode,fctmethod = 'BBE',
             factorprior = list(b0 = 0, vb0 = NULL, c0 = 0.01, d0 = 0.01),
             varprior = list(b0 = 0,vb0 = 0, nu0 = 0, s0 = 0),
             nrep = 5000, nburn = 1000, K = 2, plag = 2,  ncores = 1)
Sys.time()-ans

summary(fit,xvar = c(3,5))

ans <- irf(fit, irftype = 'orth', tcode = tcode,
                resvar = c(2, 9, 10, 28, 42, 46, 77, 91, 92, 108, 109, 111, 116,117,118),
                impvar = NULL, nhor = 21)


# 绘图
# p <- lapply(c(2, 9, 10, 28, 42, 46, 77, 91, 92, 108, 109, 111), draw_irf, fit = fit)
# drtxt <- 'p[[1]]'
# for (i in 2:length(p)) {
#   drtxt <- paste(drtxt,'+p[[',i,']]',sep = '')
# }
# drtxt <- paste(drtxt,'+plot_layout(ncol = 3)',sep = '')
# eval(parse(text = drtxt))


