cap log close // closes any log files
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample2, replace

**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 2  - The Simple Regression Model
* Computer Exercises (Examples)
* Nov 22, 2018
******************** SETUP *********************

*example2.1. N/A

*example2.2. N/A

*example2.3. CEO Salary & Return on Equity ; salary = b0 + b1roe + u
use ceosal1.dta, clear
regress salary roe

*example2.4 
u wage1.dta, clear
sum wage educ
reg wage educ 

*example2.5 
u vote1.dta, clear
reg voteA shareA

*example2.6  Table2.2
use ceosal1.dta, clear
regress salary roe
esttab, r2 
predict salaryhat, xb 
predict uhat, residual 
list roe salary salaryhat uhat in 1/15, table separator(15)

*example2.7 Wage & education.
u wage1.dta, clear
sum wage
qui reg wage educ 
esttab, r2 
display as text "if educ=12.56, then wage_hat = " as result -.90 + .54*12.56

*example2.8. CEO Salary - R-squared.  
use ceosal1.dta, clear
qui regress salary roe
esttab, r2 

*example2.9 Voting outcome - R-squared. See example2.5 for details.
u vote1.dta, clear
qui reg voteA shareA
esttab, r2 

*example2.3 in session2.4 Units of measurement & functional form 
use ceosal1.dta, clear
g salardol=1000*salary
eststo: regress salardol roe
eststo: regress salary roe 
esttab, r2 
est clear

*example2.10 A log wage equation (log-lin model; semi-elasticity )
u wage1.dta, clear
sum wage lwage educ
reg lwage educ 
esttab, r2 

*example2.11 Ceo Salary & Fim Sales (log-log model; elasticity)
use ceosal1.dta, clear
regress lsalary lsales 
esttab, r2 

*example2.12 Student math performance 
u meap93.dta, clear
reg math10 lnchprg
esttab, r2 

*example2.13 N/A 

log close
log2html iexample2, replace ti(Chapter 2 - Examples)
