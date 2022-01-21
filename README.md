
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FAVAR

<!-- badges: start -->
<!-- badges: end -->

The goal of FAVAR is to estimate a FAVAR model by Bernanke et
al. (2005).

## Installation

You can install the development version of FAVAR from
[GitHub](https://github.com/) with:

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
              varprior = list(b0 = 0,vb0 = 10, nu0 = 0, s0 = 0),
              factorprior = list(b0 = 0, B0 = NULL, c0 = 0.01, d0 = 0.01),
              nrep = 500, nburn = 100, K = 2, plag = 2)
# print FAVAR estimation results
summary(fit,xvar = c(3,5))
#> Estimation VAR results for equation factor1 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.7240 0.0035  0.5686  0.8642
#> factor2.1        0.1512 0.0028  0.0305  0.2757
#> Inflation.1      0.0250 0.0044 -0.1630  0.2224
#> Unemployment.1  -0.1713 0.0035 -0.3178 -0.0216
#> Fed_funds.1      0.0612 0.0018 -0.0186  0.1406
#> factor1.2        0.2036 0.0040  0.0254  0.3709
#> factor2.2       -0.0435 0.0023 -0.1500  0.0518
#> Inflation.2     -0.0363 0.0038 -0.2024  0.1322
#> Unemployment.2   0.1156 0.0035 -0.0365  0.2594
#> Fed_funds.2     -0.0109 0.0019 -0.0877  0.0681
#> --------------
#> Estimation VAR results for equation factor2 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.5210 0.0050 -0.7399 -0.3068
#> factor2.1        0.7874 0.0037  0.6153  0.9528
#> Inflation.1      0.0051 0.0054 -0.2460  0.2490
#> Unemployment.1   0.3242 0.0047  0.1171  0.5353
#> Fed_funds.1     -0.0929 0.0027 -0.2120  0.0217
#> factor1.2        0.0073 0.0054 -0.2306  0.2407
#> factor2.2        0.0295 0.0034 -0.1202  0.1790
#> Inflation.2      0.1318 0.0048 -0.0818  0.3622
#> Unemployment.2  -0.3004 0.0046 -0.5191 -0.1030
#> Fed_funds.2      0.0198 0.0026 -0.0870  0.1361
#> --------------
#> Estimation VAR results for equation Inflation 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2284 0.0028  0.1077  0.3503
#> factor2.1        0.2728 0.0021  0.1869  0.3681
#> Inflation.1      0.9773 0.0033  0.8303  1.1113
#> Unemployment.1  -0.0416 0.0028 -0.1617  0.0761
#> Fed_funds.1     -0.0592 0.0015 -0.1203  0.0092
#> factor1.2        0.2528 0.0031  0.1202  0.3914
#> factor2.2        0.0788 0.0018 -0.0001  0.1584
#> Inflation.2     -0.1370 0.0029 -0.2605 -0.0122
#> Unemployment.2   0.0411 0.0027 -0.0779  0.1555
#> Fed_funds.2      0.0435 0.0015 -0.0221  0.1029
#> --------------
#> Estimation VAR results for equation Unemployment 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2832 0.0036  0.1332  0.4346
#> factor2.1       -0.3023 0.0026 -0.4146 -0.1910
#> Inflation.1     -0.0140 0.0042 -0.2028  0.1717
#> Unemployment.1   0.7661 0.0033  0.6162  0.9084
#> Fed_funds.1     -0.0070 0.0019 -0.0912  0.0753
#> factor1.2        0.1717 0.0038  0.0081  0.3297
#> factor2.2        0.1192 0.0024  0.0188  0.2205
#> Inflation.2      0.0095 0.0036 -0.1554  0.1622
#> Unemployment.2   0.1786 0.0032  0.0435  0.3395
#> Fed_funds.2      0.0240 0.0018 -0.0489  0.1007
#> --------------
#> Estimation VAR results for equation Fed_funds 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.0789 0.0054 -0.3144  0.1401
#> factor2.1        0.6090 0.0043  0.4175  0.8036
#> Inflation.1      0.1785 0.0060 -0.0830  0.4422
#> Unemployment.1   0.0730 0.0053 -0.1566  0.2943
#> Fed_funds.1      0.7559 0.0031  0.6203  0.8940
#> factor1.2        0.0557 0.0062 -0.2009  0.3357
#> factor2.2       -0.2984 0.0038 -0.4692 -0.1339
#> Inflation.2     -0.1429 0.0054 -0.3734  0.0957
#> Unemployment.2  -0.0899 0.0052 -0.3148  0.1237
#> Fed_funds.2      0.1853 0.0030  0.0487  0.3225
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
# plot impulse response figure
library(patchwork)
ans <- irf(fit,resvar = c(2,9,10), tcode = tcode, nhor = 21, showplot = T)
```

<img src="man/figures/README-example-1.png" width="100%" />

## Reference

-   Bernanke, B.S., J. Boivin and P. Eliasz, Measuring the Eeefects of
    Monetary Policy: A Factor-Augmented Vector Autoregressive (FAVAR)
    Approach. Quarterly Journal of Economics, 2005. 120(1): p. 387-422.
