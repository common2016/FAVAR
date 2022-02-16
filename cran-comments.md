## Resubmission

This is a resubmission. In this version I have fixed the bugs from the platform "macos-m1-bigsur-release".
The reason for the bugs is that the algorithm for principle components is different in the different platform, and 
the sign of the results for different platform maybe is opposite. By taking absolute values in the "test file",
I have fixed the bugs.

### last feedbacks

Thanks, we see:

M1mac still fails:
 > test_check("FAVAR")
 [ FAIL 2 | WARN 0 | SKIP 0 | PASS 1 ]

 ══ Failed tests ════════════════════════════════════════════════════════════════
 ── Failure (???): loading factor ───────────────────────────────────────────────
 lamb_tol < 0.01 is not TRUE

 `actual`:   FALSE
 `expected`: TRUE
 ── Failure (???): coefficients VAR ─────────────────────────────────────────────
 varcoef_tol < 0.01 is not TRUE

 `actual`:   FALSE
 `expected`: TRUE

 [ FAIL 2 | WARN 0 | SKIP 0 | PASS 1 ]


Please fix and resubmit.

Best,
Uwe Ligges

## Test environments

* local macOS Monterey,  R 4.1.2

* CentOS 8, stock R from EPEL (based on `rhub::check_on_linux()`)

* macOS 11.2.0 Big Sugar, R-release(based on `rhub::check(platform = 'macos-m1-bigsur-release', show_status = FALSE)`)

* Windows Server 2022, R-devel, 64 bit (based on `rhub::check()`(the 18th platform) and `check_win_devel()`)

  

## R CMD check results

There were no ERRORs, WARNINGS or Notes.

## Downstream dependencies

There are currently no downstream dependencies for this package

