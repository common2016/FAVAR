
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
             factorprior = list(b0 = 0, vb0 = NULL, c0 = 0.01, d0 = 0.01), 
             varprior = list(b0 = 0,vb0 = 10, nu0 = 0, s0 = 0),
             nrep = 500, nburn = 100, K = 2, plag = 2)
# print FAVAR estimation results
summary(fit,xvar = c(3,5))
#> Estimation VAR results for equation factor1 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.7211 0.0039  0.5445  0.8907
#> factor2.1        0.1468 0.0026  0.0267  0.2599
#> Inflation.1      0.0266 0.0041 -0.1401  0.2092
#> Unemployment.1  -0.1663 0.0035 -0.3231 -0.0142
#> Fed_funds.1      0.0606 0.0019 -0.0193  0.1429
#> factor1.2        0.1949 0.0039  0.0195  0.3614
#> factor2.2       -0.0395 0.0025 -0.1526  0.0692
#> Inflation.2     -0.0337 0.0035 -0.1809  0.1120
#> Unemployment.2   0.1110 0.0034 -0.0367  0.2699
#> Fed_funds.2     -0.0135 0.0019 -0.1007  0.0701
#> --------------
#> Estimation VAR results for equation factor2 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.5142 0.0050 -0.7418 -0.2971
#> factor2.1        0.8034 0.0036  0.6417  0.9574
#> Inflation.1     -0.0111 0.0058 -0.2555  0.2436
#> Unemployment.1   0.3307 0.0047  0.1385  0.5395
#> Fed_funds.1     -0.0881 0.0026 -0.1961  0.0223
#> factor1.2        0.0120 0.0052 -0.2147  0.2472
#> factor2.2        0.0213 0.0033 -0.1219  0.1605
#> Inflation.2      0.1429 0.0052 -0.0660  0.3670
#> Unemployment.2  -0.3079 0.0046 -0.5086 -0.1118
#> Fed_funds.2      0.0188 0.0026 -0.0871  0.1351
#> --------------
#> Estimation VAR results for equation Inflation 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2288 0.0027  0.1121  0.3510
#> factor2.1        0.2747 0.0020  0.1908  0.3649
#> Inflation.1      0.9740 0.0034  0.8248  1.1105
#> Unemployment.1  -0.0335 0.0027 -0.1502  0.0837
#> Fed_funds.1     -0.0575 0.0015 -0.1189  0.0072
#> factor1.2        0.2512 0.0031  0.1158  0.3850
#> factor2.2        0.0791 0.0019 -0.0055  0.1541
#> Inflation.2     -0.1333 0.0029 -0.2531 -0.0122
#> Unemployment.2   0.0340 0.0026 -0.0832  0.1496
#> Fed_funds.2      0.0403 0.0014 -0.0216  0.1039
#> --------------
#> Estimation VAR results for equation Unemployment 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2870 0.0036  0.1333  0.4427
#> factor2.1       -0.3041 0.0025 -0.4124 -0.1922
#> Inflation.1     -0.0200 0.0039 -0.1839  0.1483
#> Unemployment.1   0.7642 0.0036  0.5982  0.9219
#> Fed_funds.1     -0.0087 0.0020 -0.0918  0.0835
#> factor1.2        0.1663 0.0040 -0.0113  0.3504
#> factor2.2        0.1226 0.0024  0.0193  0.2268
#> Inflation.2      0.0171 0.0035 -0.1323  0.1709
#> Unemployment.2   0.1813 0.0035  0.0269  0.3345
#> Fed_funds.2      0.0225 0.0019 -0.0610  0.1009
#> --------------
#> Estimation VAR results for equation Fed_funds 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.0801 0.0055 -0.3263  0.1427
#> factor2.1        0.6103 0.0043  0.4220  0.8039
#> Inflation.1      0.1847 0.0065 -0.0898  0.4524
#> Unemployment.1   0.0615 0.0053 -0.1637  0.3112
#> Fed_funds.1      0.7586 0.0031  0.6251  0.8846
#> factor1.2        0.0564 0.0063 -0.2293  0.3300
#> factor2.2       -0.3043 0.0036 -0.4574 -0.1632
#> Inflation.2     -0.1471 0.0058 -0.3838  0.1088
#> Unemployment.2  -0.0805 0.0051 -0.3128  0.1343
#> Fed_funds.2      0.1808 0.0030  0.0575  0.3164
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

-   Bernanke, B.S., J. Boivin and P. Eliasz, Measuring the Effects of
    Monetary Policy: A Factor-Augmented Vector Autoregressive (FAVAR)
    Approach. Quarterly Journal of Economics, 2005. 120(1): p. 387-422.
