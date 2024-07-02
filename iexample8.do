cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 90

log using iexample8, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 8  - Heteroskedasticity
* Computer Exercises (Examples)
******************** SETUP *********************
 
*Example 8.1. Log wage equation with Heteroskedasticity- Robust Standard Errors
u wage1, clear
g marrmale = (female==0 & married==1)
g marrfem = (female==1 & married==1)
g singfem = (female==1 & married==0)
g singmen = (female==0 & married==0)
eststo hetroskedastic: qui reg lwage marrmale marrfem singfem educ exper* tenur*
eststo robust: qui reg lwage marrmale marrfem singfem educ exper* tenur*, robust 
estout , cells(b(nostar fmt(3)) se(par fmt(3))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(20)
est clear

*Example 8.2. Heteroskedasticity-Robust F Statistic
u gpa3, clear
eststo hetrosked: qui  reg cumgpa sat hsperc tothrs female black white if spring==1
eststo robust: qui  reg cumgpa sat hsperc tothrs female black white if spring==1, robust
estout , cells(b(nostar fmt(5)) se(par fmt(5))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(20)
est clear

*Example 8.3. Heteroskedasticity-Robust LM Statistic
u crime1, clear
g avgsensq = avgsen^2 
eststo hetrosked: qui reg narr86 pcnv avgsen avgsensq ptime86 qemp86 inc86 black hispan
eststo robust: qui reg narr86 pcnv avgsen avgsensq ptime86 qemp86 inc86 black hispan, r  
estout , cells(b(nostar fmt(5)) se(par fmt(5))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(20)
est clear

*LM Statistic  - not-robust (See Section 5-2)
qui reg narr86 pcnv ptime86 qemp86 inc86 black hispan
predict u, res
reg u pcnv avgsen avgsensq ptime86 qemp86 inc86 black hispan
display as text "N*Rsq = " 2725*.0013

*LM Statistic  - robust
foreach x of var avgsen avgsensq { 
qui reg `x'  pcnv ptime86 qemp86 inc86 black hispan 
predict r_`x', residual
gen ures`x'= u*r_`x'
}
gen one=1
reg one ures*, noc 
display as text "N - SSR = " 2725 - 2721.0029 

*Example 8.4. Heteroskedasticity in Housing Price Equations
u hprice1, clear
reg price lotsize sqrft bdrms 
predict u, res
g u2=u^2
reg u2 lotsize sqrft bdrms
display as text "LM = N*Rsq =" 88 * .1601
display chi2tail(3, 88*.1601)

reg lprice llotsize lsqrft bdrms 
predict lu, res
g lu2=lu^2
reg lu2 llotsize lsqrft bdrms
display as text "LM = N*Rsq =" 88 * .048
display chi2tail(3, 88*.048)

*Example 8.5. Special Form of the White Test
u hprice1, clear
reg lprice llotsize lsqrft bdrms 
predict u, res
g u2=u^2
predict y, xb
gen y2 = y^2
reg u2 y y2
display as text "LM = N*Rsq =" 88 * .0392
display chi2tail(2, 88*.0392)

*Example 8.6. Financial Wealth Equation
u 401ksubs, clear
keep if fsize==1 
g age25sq=(age-25)^2
eststo OLS1: qui reg nettfa inc, r
eststo WLS1: qui reg nettfa inc [aw=1/inc]
eststo OLS2: qui reg nettfa inc age25sq male e401k, r 
eststo WLS2: qui reg nettfa inc age25sq male e401k [aw=1/inc]
estout , cells(b(nostar fmt(5)) se(par fmt(5))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(20) ti(Table 8.1 Dependent Variable: nettfa)
est clear

*Example 8.7. Demand for Cigarettes
u smoke, clear
local x "lincome lcigpric educ age agesq restaurn" 
eststo OLS: reg cigs `x'
predict u, res
gen lu2=ln(u^2)
qui reg lu2 `x'
predict lu2h, xb
g e_lu2h=exp(lu2h)
eststo GLS: reg cigs `x' [aw=1/e_lu2h]
estout , cells(b(nostar fmt(5)) se(par fmt(5))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(20) ti(Table 8.1 Dependent Variable: nettfa)
est clear

*Example 8.8. Labor Force Participation of Married Women
u mroz, clear
local x "nwifeinc educ exper* age kidslt6 kidsge6"
eststo heterosked: qui reg inlf `x'
eststo Robust: qui reg inlf `x', r
estout , cells(b(nostar fmt(5)) se(par fmt(5))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(20) ti(Table 8.1 Dependent Variable: nettfa)
est clear

*Example 8.9 Determinants of Personal Computer Ownership
u gpa1, clear
g parcoll = ( fathcoll==1 | mothcoll==1)
eststo heterosked: qui reg PC hsGPA ACT parcoll 
eststo heterosked: qui reg PC hsGPA ACT parcoll, r
estout, cells(b(nostar fmt(5)) se(par fmt(5))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(20) ti(Table 8.1 Dependent Variable: nettfa)
est clear

qui reg PC hsGPA ACT parcoll 
predict yhat, xb
gen hhat = yhat*(1-yhat)
reg PC hsGPA ACT parcoll [aw=1/hhat]

log close
log2html iexample8, replace ti(Chapter 8 - Examples)


