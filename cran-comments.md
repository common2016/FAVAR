## Resubmission

This is a resubmission. In the version,

- I have writed TRUE and FALSE instead of T and F for every function.
- In `FAVAR`, I added a tag "See Also" containing the exported all S3 methods for class "favar"
and the explanation of the functions results. Meanwhile, I more clearly stated the
structure of the class "favar" and its means in the tag "Value".
- In `summary.favar` I add the tag "Value" whose content is "No return value, called for side effects".
- I added copyright holders "Koop and Korobilis" in `Authors@R` field.

### Last feedback

Please write TRUE and FALSE instead of T and F. (Please don't use 'T' or
'F' as vector names.), e.g.:
   man/ar2ma.Rd:
     ar2ma(ar, p, n = 11, CharValue = T)

Please add \value to .Rd files regarding exported methods and explain
the functions results in the documentation. Please write about the
structure of the output (class) and also what the output means. (If a
function does not return a value, please document that too, e.g.
\value{No return value, called for side effects} or similar)
Missing Rd-tags:
      summary.favar.Rd: \value

Please always add all authors, contributors and copyright holders in the
Authors@R field with the appropriate roles.
 From CRAN policies you agreed to:
"Where copyrights are held by an entity other than the package authors,
this should preferably be indicated via ‘cph’ roles in the ‘Authors@R’
field, or using a ‘Copyright’ field (if necessary referring to an
inst/COPYRIGHTS file)."
e.g.: Koop and Korobilis
Please explain in the submission comments what you did about this issue.

Please fix and resubmit.

Best,
Julia Haider

## Test environments

* local windows 10,  R 4.0.3

* CentOS 8, stock R from EPEL (based on `rhub::check_on_linux()`)

* macOS 10.13.6 High Sierra, R-release, brew (based on `rhub::check()`, the 10th platform)

* Windows Server 2022, R-devel, 64 bit (based on `rhub::check()`(the 18th platform) and `check_win_devel()`)

  

## R CMD check results

There were no ERRORs or WARNINGS.

One NOTES, because it's first submission.

## Downstream dependencies

There are currently no downstream dependencies for this package

