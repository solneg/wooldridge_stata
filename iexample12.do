cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample12, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 12 Serial Correlation and Heteroskedasticity in Time Series Regressions
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 12.1. Testing for AR(1) Serial Correlation in the Phillips Curve
u phillips, clear
qui reg inf unem
predict us, res
g us_1 = us[_n-1]
reg us us_1

qui reg cinf unem
predict ua, res
g ua_1 = ua[_n-1]
reg ua ua_1

*Example 12.2 Testing for AR(1) Serial Correlation in the Minimum Wage Equation
u prminwge, clear
qui reg lprepop lmincov lprgnp lusgnp t
predict u, res
g u_1 = u[_n-1]
reg u  lmincov lprgnp lusgnp t u_1
reg u u_1

*Example 12.3 Testing for AR(3) Serial Correlation
u barium, clear
qui reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6
predict u, res
g u_1 = u[_n-1]
g u_2 = u[_n-2]
g u_3 = u[_n-3]
reg u lchempi lgas lrtwex befile6 affile6 afdec6 u_1 u_2 u_3
test u_1 u_2 u_3

*Example 12.4. Prais-Winsten Estimation in the Event Study
u barium, clear
tsset t
local x "lchempi lgas lrtwex befile6 affile6 afdec6"
eststo OLS: qui reg lchnimp `x'
eststo PW: qui prais lchnimp `x'
estout , cells(b(nostar fmt(2)) se(par fmt(3))) stats(rho N r2, fmt(%9.3f %9.0g %9.3f ) labels(rho Observations R-squared )) varlabels(_cons intercept) varwidth(20) ti(Table 12.1 Dependent Variable: log(chnimp))
est clear

*Example 12.5 Static Phillips Curve
u phillips, clear
tsset year
eststo OLS: qui reg inf unem
eststo PW: qui prais inf unem
estout , cells(b(nostar fmt(3)) se(par fmt(3))) stats(rho N r2, fmt(%9.3f %9.0g %9.3f ) labels(rho Observations R-squared )) varlabels(_cons intercept) varwidth(20) ti(Table 12.2 Dependent Variable: inf)
est clear

*Example 12.6 Differencing the Interest Rate Equation
bcuse intdef, clear
reg i3 inf def
predict u, res
g u_1 = u[_n-1]
reg u u_1
reg ci3 cinf cdef
corr i3 i3_1
predict e, res
g e_1 = e[_n-1]
reg e e_1

*Example 12.7 The Puerto Rican Minimum Wage
u prminwge, clear
tsset year
eststo OLS: qui reg lprepop lmincov lprgnp lusgnp t
eststo Newey: qui newey lprepop lmincov lprgnp lusgnp t, lag(2)
eststo Pw: qui prais lprepop lmincov lprgnp lusgnp t
estout , cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared N)) varlabels(_cons intercept) varwidth(20) ti(Dependent Variables: log(prepop))
est clear

*Example 12.8 Heteroskedasticity and the Efficient Markets Hypothesis
u nyse, clear
reg return return_1
predict u, res
gen u2 = u^2
reg u2 return_1

*Example 12.9 ARCH in Stock Returns
u nyse, clear
qui reg return return_1
predict u, res
gen u2 = u^2
g u2_1 = u2[_n-1]
reg u2  u2_1
g u_1 = u[_n-1]
reg u  u_1

log close
log2html iexample12, replace ti(Chapter 12 - Examples)


