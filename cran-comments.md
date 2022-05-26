## Submission state

Because of matlab package is put on archive, the FAVAR package is also put on archive. We

remove the dependence from matlab package in the submission.

## Test environments

* local macOS Monterey,  R 4.1.2

* CentOS 8, stock R from EPEL (based on `rhub::check_on_linux()`)

* macOS 11.2.0 Big Sugar, R-release(based on `rhub::check(platform = 'macos-m1-bigsur-release', show_status = FALSE)`)

* Windows Server 2022, R-devel, 64 bit (based on `rhub::check()`(the 18th platform) and `check_win_devel()`)

  

## R CMD check results

There were no ERRORs, WARNINGS.

However, there is a Note, "checking CRAN incoming feasibility ... NOTE". This is just a note that reminds CRAN maintainers to check that the submission comes actually from his maintainer and not anybody else. I think it's a safe to ignore such a message.

## Downstream dependencies

There are currently no downstream dependencies for this package.

