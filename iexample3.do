cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample3, replace

**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 3  - Multiple Regression Analysis 
* Computer Exercises (Examples)
******************** SETUP *********************

*example3.1  Determinants of College GPA
u gpa1.dta, clear
eststo: reg colG hsGP ACT
eststo: reg colG  ACT
esttab, se
est clear

*example3.2 Wage equation
u wage1.dta, clear
reg lwage educ exper tenure

*example3.3 Participation in 401(k) pension plans 
u 401k.dta, clear
reg prate mrate age

*example3.4 Determinants of College GPA, R-squared. See example3.1.
u gpa1.dta, clear
reg colG hsGP ACT

*example3.5 Arrest records
u crime1.dta, clear
eststo: reg narr86 pcnv  ptime86 qemp86
eststo: reg narr86 pcnv avgsen ptime86 qemp86
esttab, se r2
est clear

*example3.6 Wage equation
u wage1.dta, clear
reg lwage educ 

log close
log2html iexample3, replace ti(Chapter 3 - Examples)
