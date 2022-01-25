
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
#> factor1.1        0.7262 0.0035  0.5778  0.8921
#> factor2.1        0.1495 0.0028  0.0209  0.2657
#> Inflation.1      0.0268 0.0043 -0.1551  0.2084
#> Unemployment.1  -0.1714 0.0034 -0.3317 -0.0233
#> Fed_funds.1      0.0602 0.0019 -0.0165  0.1412
#> factor1.2        0.1998 0.0040  0.0284  0.3662
#> factor2.2       -0.0408 0.0024 -0.1504  0.0590
#> Inflation.2     -0.0367 0.0038 -0.1991  0.1264
#> Unemployment.2   0.1153 0.0033 -0.0198  0.2675
#> Fed_funds.2     -0.0123 0.0018 -0.0918  0.0686
#> --------------
#> Estimation VAR results for equation factor2 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.5065 0.0047 -0.7106 -0.2898
#> factor2.1        0.7968 0.0039  0.6309  0.9670
#> Inflation.1     -0.0195 0.0057 -0.2659  0.2342
#> Unemployment.1   0.3257 0.0044  0.1144  0.5083
#> Fed_funds.1     -0.0890 0.0025 -0.1923  0.0190
#> factor1.2        0.0058 0.0051 -0.2184  0.2280
#> factor2.2        0.0262 0.0033 -0.1258  0.1652
#> Inflation.2      0.1521 0.0050 -0.0623  0.3612
#> Unemployment.2  -0.3015 0.0043 -0.4761 -0.0908
#> Fed_funds.2      0.0168 0.0025 -0.0922  0.1175
#> --------------
#> Estimation VAR results for equation Inflation 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2371 0.0027  0.1149  0.3545
#> factor2.1        0.2771 0.0020  0.1846  0.3634
#> Inflation.1      0.9630 0.0033  0.8256  1.0946
#> Unemployment.1  -0.0367 0.0027 -0.1503  0.0686
#> Fed_funds.1     -0.0551 0.0015 -0.1161  0.0062
#> factor1.2        0.2492 0.0030  0.1190  0.3844
#> factor2.2        0.0778 0.0018 -0.0009  0.1636
#> Inflation.2     -0.1245 0.0027 -0.2386 -0.0077
#> Unemployment.2   0.0359 0.0026 -0.0758  0.1406
#> Fed_funds.2      0.0384 0.0014 -0.0279  0.0975
#> --------------
#> Estimation VAR results for equation Unemployment 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1        0.2852 0.0037  0.1142  0.4301
#> factor2.1       -0.3065 0.0027 -0.4336 -0.1952
#> Inflation.1     -0.0161 0.0044 -0.2023  0.1816
#> Unemployment.1   0.7730 0.0034  0.6220  0.9174
#> Fed_funds.1     -0.0099 0.0019 -0.0953  0.0710
#> factor1.2        0.1627 0.0039 -0.0054  0.3374
#> factor2.2        0.1237 0.0024  0.0227  0.2228
#> Inflation.2      0.0132 0.0038 -0.1678  0.1768
#> Unemployment.2   0.1730 0.0033  0.0324  0.3178
#> Fed_funds.2      0.0258 0.0018 -0.0523  0.1026
#> --------------
#> Estimation VAR results for equation Fed_funds 
#> -------------
#>                Estimate     se    q025    q975
#> factor1.1       -0.0887 0.0058 -0.3231  0.1585
#> factor2.1        0.6067 0.0043  0.4028  0.7770
#> Inflation.1      0.1805 0.0064 -0.0996  0.4609
#> Unemployment.1   0.0758 0.0052 -0.1641  0.2897
#> Fed_funds.1      0.7593 0.0031  0.6267  0.8932
#> factor1.2        0.0581 0.0058 -0.2034  0.3272
#> factor2.2       -0.2981 0.0037 -0.4636 -0.1493
#> Inflation.2     -0.1418 0.0057 -0.3853  0.1033
#> Unemployment.2  -0.0955 0.0051 -0.3216  0.1288
#> Fed_funds.2      0.1812 0.0031  0.0546  0.3197
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
