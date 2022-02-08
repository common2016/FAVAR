
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FAVAR

<!-- badges: start -->
<!-- badges: end -->

The goal of FAVAR is to estimate a FAVAR model by Bernanke et
al. (2005).

## Installation

You can install the package FAVAR from CRAN:

``` r
install.packages('FAVAR')
```

You can install the development version of FAVAR from
[GitHub](https://github.com/common2016/FAVAR) with:

``` r
# install.packages("devtools")
devtools::install_github("common2016/FAVAR")
```

## Example

This is a basic example which shows you how to estimate a FAVAR model:

``` r
library(FAVAR)
## basic example code
data('regdata')
fit <- FAVAR(Y = regdata[,c("Inflation","Unemployment","Fed_funds")],
             X = regdata[,1:115], slowcode = slowcode,fctmethod = 'BBE',
             factorprior = list(b0 = 0, vb0 = NULL, c0 = 0.01, d0 = 0.01), 
             varprior = list(b0 = 0,vb0 = 10, nu0 = 0, s0 = 0),
             nrep = 500, nburn = 100, K = 2, plag = 2)
# print FAVAR estimation results
summary(fit,xvar = c(3,5))
#> Estimation VAR results for equation factor1 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.7236 0.0035  0.5651  0.8700
#> factor2.1        0.1463 0.0026  0.0344  0.2603
#> Inflation.1      0.0268 0.0041 -0.1336  0.2166
#> Unemployment.1  -0.1733 0.0034 -0.3215 -0.0221
#> Fed_funds.1      0.0592 0.0019 -0.0211  0.1427
#> factor1.2        0.1954 0.0038  0.0359  0.3667
#> factor2.2       -0.0400 0.0024 -0.1465  0.0616
#> Inflation.2     -0.0335 0.0037 -0.1926  0.1194
#> Unemployment.2   0.1168 0.0033 -0.0237  0.2606
#> Fed_funds.2     -0.0106 0.0018 -0.0916  0.0681
#> --------------
#> Estimation VAR results for equation factor2 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.5147 0.0051 -0.7437 -0.2973
#> factor2.1        0.8002 0.0037  0.6343  0.9516
#> Inflation.1     -0.0076 0.0060 -0.2751  0.2370
#> Unemployment.1   0.3294 0.0042  0.1295  0.5041
#> Fed_funds.1     -0.0894 0.0027 -0.2132  0.0213
#> factor1.2        0.0127 0.0054 -0.2186  0.2711
#> factor2.2        0.0202 0.0031 -0.1077  0.1615
#> Inflation.2      0.1378 0.0053 -0.0847  0.3757
#> Unemployment.2  -0.3043 0.0041 -0.4742 -0.1103
#> Fed_funds.2      0.0180 0.0026 -0.0907  0.1372
#> --------------
#> Estimation VAR results for equation Inflation 
#> -------------
#>                Estimate     se    q025   q975
#> factor1.1        0.2308 0.0028  0.1127 0.3677
#> factor2.1        0.2765 0.0022  0.1826 0.3718
#> Inflation.1      0.9731 0.0034  0.8121 1.1173
#> Unemployment.1  -0.0320 0.0027 -0.1458 0.0795
#> Fed_funds.1     -0.0580 0.0014 -0.1192 0.0037
#> factor1.2        0.2515 0.0031  0.1115 0.3866
#> factor2.2        0.0792 0.0018 -0.0087 0.1597
#> Inflation.2     -0.1338 0.0029 -0.2663 0.0030
#> Unemployment.2   0.0323 0.0026 -0.0748 0.1478
#> Fed_funds.2      0.0415 0.0014 -0.0156 0.0982
#> --------------
#> Estimation VAR results for equation Unemployment 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2806 0.0037  0.1172  0.4362
#> factor2.1       -0.3049 0.0028 -0.4272 -0.1945
#> Inflation.1     -0.0208 0.0044 -0.2263  0.1565
#> Unemployment.1   0.7705 0.0035  0.6228  0.9287
#> Fed_funds.1     -0.0110 0.0018 -0.0830  0.0690
#> factor1.2        0.1685 0.0042 -0.0046  0.3616
#> factor2.2        0.1293 0.0024  0.0150  0.2378
#> Inflation.2      0.0186 0.0037 -0.1384  0.1889
#> Unemployment.2   0.1744 0.0034  0.0301  0.3208
#> Fed_funds.2      0.0270 0.0018 -0.0575  0.1045
#> --------------
#> Estimation VAR results for equation Fed_funds 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.0826 0.0055 -0.3069  0.1667
#> factor2.1        0.6031 0.0043  0.4049  0.7826
#> Inflation.1      0.1715 0.0062 -0.0811  0.4602
#> Unemployment.1   0.0654 0.0053 -0.1575  0.2950
#> Fed_funds.1      0.7489 0.0029  0.6216  0.8723
#> factor1.2        0.0518 0.0062 -0.2181  0.3232
#> factor2.2       -0.2942 0.0037 -0.4427 -0.1254
#> Inflation.2     -0.1307 0.0055 -0.3806  0.1026
#> Unemployment.2  -0.0881 0.0053 -0.3171  0.1353
#> Fed_funds.2      0.1904 0.0029  0.0703  0.3254
#> --------------
#> 
#> =================================================================================
#> Estimation results for the 3th equation in X = FY 
#> ------------
#>                  loading  loading_se        q025        q975
#> factor1      -1.68390725 0.011857036 -2.13008865 -1.08789590
#> factor2       0.57351588 0.007049173  0.28645862  0.88920757
#> Inflation     0.17500014 0.004882530 -0.03514514  0.36357533
#> Unemployment  0.05065144 0.002760542 -0.06667948  0.18144093
#> Fed_funds    -0.14186086 0.003393773 -0.28570561  0.01174437
#> -------------
#> Estimation results for the 5th equation in X = FY 
#> ------------
#>                 loading  loading_se        q025        q975
#> factor1      -0.5431962 0.012825894 -1.04440858  0.06499368
#> factor2       0.7660636 0.007873015  0.43876128  1.11441043
#> Inflation     0.1760928 0.005413527 -0.06253258  0.38725944
#> Unemployment  0.2045756 0.003149414  0.06955185  0.35321617
#> Fed_funds    -0.3872807 0.003923484 -0.55207957 -0.21091164
#> -------------
#> NULL
# plot impulse response figure
library(patchwork)
ans <- irf(fit,resvar = c(2,9,10), tcode = tcode, nhor = 21, showplot = T)
```

<img src="man/figures/README-example-1.png" width="100%" />

## Reference

-   Bernanke, B.S., J. Boivin and P. Eliasz, Measuring the Effects of
    Monetary Policy: A Factor-Augmented Vector Autoregressive (FAVAR)
    Approach. Quarterly Journal of Economics, 2005. 120(1): p. 387-422.
