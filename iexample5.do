cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample5, replace

**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 5  - Multiple Regression Analysis: OLS Asymptotics 
* Computer Exercises (Examples)
******************** SETUP *********************

*Example5.1 N/A
  
*Example5.2 Birth weight equaiton, Standar Errors.
u bwght.dta, clear
egen id=seq()
sum id
eststo: qui reg lbwght cigs lfaminc if id<=694
eststo: qui reg lbwght cigs lfaminc
estout *, cells(b(star fmt(3)) se(par fmt(5))) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared)) varlabels(_cons Constant)
est clear


*Example5.3 Economic model of crime
u crime1.dta, clear
*Test using F-statistic
reg narr86 pcnv avgsen tottime ptime86 qemp86
test avgsen tottime 

*Test using LM statistic
reg narr86 pcnv ptime86 qemp86 
predict ur, residual //residuals from the restricted model
reg ur pcnv avgsen tottime ptime86 qemp86
display as text "LM statistic is the product of N & Rsquared the second regression which is equal to " as result 2725*0.0015

log close

log2html iexample5, replace ti(Chapter 5 - Examples)
