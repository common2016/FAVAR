
<!-- README.md is generated from README.Rmd. Please edit that file -->

# FAVAR

<!-- badges: start -->
<!-- badges: end -->

The goal of FAVAR is to estimate a FAVAR model by Bernanke et
al. (2005).

## Installation

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
              varprior = list(b0 = 0,vb0 = 10, nu0 = 0, s0 = 0),
              factorprior = list(b0 = 0, vb0 = NULL, c0 = 0.01, d0 = 0.01),
              nrep = 500, nburn = 100, K = 2, plag = 2)
# print FAVAR estimation results
summary(fit,xvar = c(3,5))
#> Estimation VAR results for equation factor1 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.7219 0.0033  0.5749  0.8745
#> factor2.1        0.1470 0.0026  0.0276  0.2540
#> Inflation.1      0.0319 0.0042 -0.1334  0.2159
#> Unemployment.1  -0.1703 0.0033 -0.3023 -0.0349
#> Fed_funds.1      0.0602 0.0018 -0.0134  0.1361
#> factor1.2        0.1967 0.0039  0.0250  0.3665
#> factor2.2       -0.0398 0.0024 -0.1421  0.0617
#> Inflation.2     -0.0415 0.0037 -0.2145  0.1059
#> Unemployment.2   0.1157 0.0032 -0.0252  0.2441
#> Fed_funds.2     -0.0116 0.0018 -0.0858  0.0592
#> --------------
#> Estimation VAR results for equation factor2 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.5192 0.0047 -0.7271 -0.3149
#> factor2.1        0.7920 0.0036  0.6360  0.9343
#> Inflation.1     -0.0061 0.0057 -0.2394  0.2402
#> Unemployment.1   0.3313 0.0043  0.1343  0.5185
#> Fed_funds.1     -0.0905 0.0026 -0.2043  0.0254
#> factor1.2        0.0121 0.0056 -0.2483  0.2460
#> factor2.2        0.0280 0.0034 -0.1127  0.1891
#> Inflation.2      0.1408 0.0050 -0.0845  0.3507
#> Unemployment.2  -0.3061 0.0042 -0.4843 -0.1287
#> Fed_funds.2      0.0181 0.0025 -0.0992  0.1292
#> --------------
#> Estimation VAR results for equation Inflation 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2309 0.0026  0.1209  0.3440
#> factor2.1        0.2768 0.0021  0.1821  0.3717
#> Inflation.1      0.9660 0.0034  0.8075  1.1060
#> Unemployment.1  -0.0352 0.0027 -0.1585  0.0728
#> Fed_funds.1     -0.0592 0.0014 -0.1237 -0.0022
#> factor1.2        0.2539 0.0030  0.1316  0.3850
#> factor2.2        0.0809 0.0018 -0.0052  0.1599
#> Inflation.2     -0.1265 0.0030 -0.2576  0.0071
#> Unemployment.2   0.0364 0.0026 -0.0701  0.1564
#> Fed_funds.2      0.0415 0.0014 -0.0151  0.1036
#> --------------
#> Estimation VAR results for equation Unemployment 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2906 0.0035  0.1306  0.4399
#> factor2.1       -0.3044 0.0029 -0.4426 -0.1698
#> Inflation.1     -0.0196 0.0042 -0.1893  0.1626
#> Unemployment.1   0.7716 0.0033  0.6219  0.9178
#> Fed_funds.1     -0.0068 0.0019 -0.0896  0.0678
#> factor1.2        0.1552 0.0040 -0.0221  0.3212
#> factor2.2        0.1218 0.0024  0.0075  0.2270
#> Inflation.2      0.0161 0.0036 -0.1515  0.1658
#> Unemployment.2   0.1728 0.0033  0.0322  0.3152
#> Fed_funds.2      0.0238 0.0019 -0.0519  0.1098
#> --------------
#> Estimation VAR results for equation Fed_funds 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.0793 0.0056 -0.3350  0.1596
#> factor2.1        0.6124 0.0044  0.4195  0.8051
#> Inflation.1      0.1886 0.0063 -0.0969  0.4811
#> Unemployment.1   0.0632 0.0051 -0.1487  0.2903
#> Fed_funds.1      0.7507 0.0033  0.6156  0.8856
#> factor1.2        0.0606 0.0060 -0.2119  0.3177
#> factor2.2       -0.3010 0.0038 -0.4601 -0.1267
#> Inflation.2     -0.1492 0.0056 -0.4005  0.0892
#> Unemployment.2  -0.0827 0.0050 -0.3156  0.1299
#> Fed_funds.2      0.1872 0.0031  0.0634  0.3159
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
