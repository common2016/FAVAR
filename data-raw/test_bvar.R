rm(list = ls())
devtools::load_all()
library(pacman)
p_load(tidyverse, devtools)

Yraw <- read.table('data-raw/Yraw.dat') %>% as.matrix()

Yraw <- ts(Yraw, start = 1)
ans_my <- BayesVAR(Yraw, plag = 2,prior = 'none',type = 'none',ncores = 3)
rowMeans(ans_my$A)
rowMeans(ans_my$sigma)



var_md <- gen_var(Yraw, p = 2, deterministic = 'none',iterations = 5000, burnin = 1000)
prior_md <- add_priors(var_md, coef = list(v_i = 0, const = 0), sigma = list(df = 0, scale = 0.001))
prior_md <- add_priors(var_md, coef= list(minnesota = list(kappa0 = 0.7, kappa1 = 1)))
ans <- draw_posterior(prior_md)
colMeans(ans$A)
