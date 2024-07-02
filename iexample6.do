cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample6, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 6  - Multiple Regression Analysis: Further Analysis 
* Computer Exercises (Examples)
******************** SETUP *********************

*Table6.1  Determinants of College GPA
u bwght, clear
eststo: qui reg bwght cigs faminc
eststo: qui reg bwghtlb cigs faminc
eststo: qui reg bwght packs faminc
esttab *, se r2 nostar ti("Compare to Table6.1 'Effects of Data Scaling'")
est clear

*Example6.1. Effects of pollution on housing prices
u hprice2, clear
//Standardizing the variables  
foreach x of varlist price nox crime rooms dist stratio  {
                egen z`x'= std(`x')
				label var z`x' "`x' - standardized"
        }
reg zprice znox zcrime zrooms zdist zstratio 
//Compare the result to Example 4.5.
g ldist=ln(dist)  
reg  lprice lnox ldist rooms stratio

//Equation (6.7)
reg lprice lnox rooms  
//Equation (6.12)
u wage1, clear
reg wage exper*  

*Example6.2. Effects of pollution on housing prices
u hprice2, clear
g ldis=ln(dist)
g roomsq = rooms^2
reg lprice lnox ldis rooms roomsq stratio 

*Example6.3. Effects of attendance on final exam performance
u attend, clear
g priGPAsq = priGPA^2
g ACTsq = ACT^2
eststo stndfnl: qui reg stndfnl atndrte priGPA ACT priGPAsq ACTsq c.priGPA#c.atndrte
estout , cells(b(nostar fmt(3)) se(par fmt(5))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(25) interaction("X")
est clear

*Example6.4. CEO compensation and frim perfromance
u ceosal1.dta, clear
eststo salary: qui reg salary sales roe
eststo lsalary: qui reg lsalary lsales roe
estout , cells(b(nostar fmt(3)) se(par fmt(5))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(25) interaction("X")
est clear

*Example6.5. Confidence interval for predicted college GPA
u gpa2, clear
eststo regression: reg colgpa sat hsperc hsize c.hsize#c.hsize 
g sat0 = sat - 1200
g hsperc0 = hsperc - 30
g hsize0 = hsize -5 
eststo prediction: reg colgpa sat0 hsperc0 hsize0 c.hsize0#c.hsize0
estout , cells(b(nostar fmt(5)) se(par fmt(5))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons Constant) varwidth(25) interaction("X")
est clear

*Example6.6. Confidence Interval for Future Collage GPA
u gpa2, clear
reg colgpa sat hsperc hsize c.hsize#c.hsize 
margins, at(sat = 1200 hsperc = 30 hsize = 5 )
display as text "Root MSE = "  e(rmse) 
predict u, res
gen u2 = u^2
mean u2
display sqrt(.313)
//The 95% CI 
display as text "Lower Bound = " 2.7 - 1.96*.56 
display as text "Upper Bound = " 2.7 + 1.96*.56 

*Example6.7. Predicting CEO log(salary)
u ceosal2.dta, clear
*Step 1
reg lsalary lsales lmktval ceoten 	
predict lsalaryhat, xb
predict uhat, residual
*Step 2
g euhat=exp(uhat)
mean euhat //The Duan smearing estimate (alpha_hat_0)
g mhat=exp(lsalaryhat)
reg salary mhat,noc // The coef. as in equation 46.44
*Step 3
qui reg lsalary lsales lmktval ceoten 
display _b[_cons]+_b[lsales]*log(5000)+_b[lmktval]*log(10000)+_b[ceoten]*10
*Step 4
qui reg salary mhat, noc 
display 1.136*exp(7.013) //or
display 1.117*exp(7.013)

*Example6.8. PRedicting CEO salary 
corr mhat salary, 
* u ceosal2.dta, clear
reg salary sales mktval ceoten 		

log close 

log2html iexample6, replace ti(Chapter 6 - Examples)
