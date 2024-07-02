cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample17, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* CHAPTER 17 Limited Dependent Variable Models and Sample Selection Corrections
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 17.1 Married Women’s Labor Force Participation

u mroz, clear
eststo LPM_OLS: reg inlf nwifeinc educ exper* age kidslt6 kidsge6 
eststo Logit_MLE: logit inlf nwifeinc educ exper* age kidslt6 kidsge6 
margins, dydx( educ)
eststo Probit_MLE: probit inlf nwifeinc educ exper* age kidslt6 kidsge6 
margins, dydx( educ)
estout, cells(b(nostar fmt(4)) se(par fmt(4))) stats(N, fmt(%9.0g) labels(Observations)) varlabels(_cons constant) varwidth(10) ti("Table 17.1 LPM, Logit, and Probit Estimates of Labor Force Participation: (inlf)")
est clear

eststo LPM: qui reg inlf nwifeinc educ exper* age kidslt6 kidsge6 
qui logit inlf nwifeinc educ exper* age kidslt6 kidsge6 
eststo Logit: qui margins, dydx( nwifeinc educ exper* age kidslt6 kidsge6) post
qui probit inlf nwifeinc educ exper* age kidslt6 kidsge6 
eststo Probit: qui margins, dydx( nwifeinc educ exper* age kidslt6 kidsge6) post
estout, cells(b(nostar fmt(4)) se(par fmt(4))) drop(_cons expersq) varwidth(10) ti("Table 17.2 Average Partial Effects for the Labor Force Participation Models: (inlf)")
est clear

*Example 17.2 Married Women’s Annual Labor Supply

u mroz, clear
eststo Linear_OLS: reg hours nwifeinc educ exper* age kidslt6 kidsge6 
eststo Linear: qui margins, dydx( nwifeinc educ exper* age kidslt6 kidsge6) post
eststo Tobit_MLE: tobit hours nwifeinc educ exper* age kidslt6 kidsge6, ll(0)
eststo Tobit: qui margins, dydx( nwifeinc educ exper* age kidslt6 kidsge6) post pred(ystar(0,.))

estout Linear_OLS Tobit_MLE, cells(b(nostar fmt(4)) se(par fmt(4))) stats(N, fmt(%9.0g) labels(Observations)) varlabels(_cons constant) varwidth(10) ti("Table 17.3 OLS and Tobit Estimation of Annual Hours Worked: (hours)")
estout Linear Tobit, cells(b(nostar fmt(4)) se(par fmt(4))) varwidth(10) ti("Table 17.4 Average Partial Effects for the Hours Worked Models: (hours)")
est clear

*Example 17.3 Poisson Regression for Number of Arrests

u crime1, clear
eststo Linear: qui reg narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60 
eststo Poisson: qui poisson narr86 pcnv avgsen tottime ptime86 qemp86 inc86 black hispan born60 
estout, cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 rmse ll, fmt(%9.0g %9.0g %9.0g) labels(R-Squared rmse Log-Likelihood)) varlabels(_cons constant) varwidth(10) ti("Table 17.5 Determinants of Number of Arrests for Young Men: (narr86)")
est clear

*Example 17.4 Duration of Recidivism

u recid, clear
cnreg  ldurat workprg priors tserved felon alcohol drugs black married educ age, censor(cens)

*Example 17.5 Wage Offer Equation for Married Women

u mroz, clear
eststo OLS: reg lwage educ exper* 
eststo Heckit: heckman lwage educ exper*, twostep select(inlf = educ exper* nwifeinc age kidslt6 kidsge6) 
estout, cells(b(nostar fmt(4)) se(par fmt(4)))  varlabels(_cons constant) varwidth(10) ti("Table 17.7 Wage Offer Equation for Married Women: (lwage)")
est clear

log close 
log2html iexample17, replace ti(Chapter 17 Limited Dependent Variable - Examples)
