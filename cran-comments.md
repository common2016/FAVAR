## Resubmission

This is a resubmission. In the link "https://cran.r-project.org/web/checks/check_results_FAVAR.html" it is shown that the test failed in the platform “r-devel-linux-x86_64-fedora-gcc”. Hoewever, by the command `rhub::check(platform = "fedora-gcc-devel")` the test is made in the platform “r-devel-linux-x86_64-fedora-gcc” again，and the test success. To confirm the results, we test it over again，the test still success. The follwing links is the two test results in platform “r-devel-linux-x86_64-fedora-gcc”:

- https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-74df5a2507354e0b9520c2e262553851
- https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-7885032cd2034b1789f18b58aa5d0bda

So, we guess that the reason is that there are several simulative generator in our codes, and in the test file the number of simulation is too few, and the test results may be different from the expected results. Based on the consideration we add the number of simulation from 100 to 1000. Finally we test it in five Debian platforms and three Ubuntu platforms in the `rhub` package, and test successes. The folloing is the test results link. We believe the bug have been fixed.

- Debian Linux, R-devel, GCC; https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-a2e61052089e4c75ac824f5f30b13ef9
- Debian Linux, R-devel, GCC, no long double; https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-0448743175134983ba4a722cadd59cc8
- Debian Linux, R-patched, GCC;https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-45f050786e164fd69953ae1454621ece
- Debian Linux, R-devel, clang, ISO-8859-15 locale; https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-96b003a2e1cd4a399f6919e4c3ad4e1e
- Debian Linux, R-release, GCC; https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-8b6fd266ddc94a2bb46e715d6b9af38f
- Ubuntu Linux 20.04.1 LTS, R-devel, GCC; https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-5ff61a0b271541119cd159c85c274ae3
- Ubuntu Linux 20.04.1 LTS, R-devel with rchk; https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-f3d12d59cf0c4b9aa1085f15eca6060c
- Ubuntu Linux 20.04.1 LTS, R-release, GCC;https://builder.r-hub.io/status/original/FAVAR_0.1.1.tar.gz-605591bed304430ab6a0f3ff1a7866fa


### last feedbacks

Dear maintainer,

Please see the problems shown on
<https://cran.r-project.org/web/checks/check_results_FAVAR.html>;.

Please correct before 2022-03-24 to safely retain your package on CRAN.

The CRAN Team

## Test environments

* local macOS Monterey,  R 4.1.2

* CentOS 8, stock R from EPEL (based on `rhub::check_on_linux()`)

* macOS 11.2.0 Big Sugar, R-release(based on `rhub::check(platform = 'macos-m1-bigsur-release', show_status = FALSE)`)

* Windows Server 2022, R-devel, 64 bit (based on `rhub::check()`(the 18th platform) and `check_win_devel()`)

  

## R CMD check results

There were no ERRORs, WARNINGS or Notes.

## Downstream dependencies

There are currently no downstream dependencies for this package

