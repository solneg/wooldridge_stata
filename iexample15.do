cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample15, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* CHAPTER 15 Instrumental Variables Estimation and Two Stage Least Squares 
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 15.1 Estimating the Return to Education for Married Women
u mroz, clear
reg lwage educ
reg educ fathedu
ivreg lwage (educ=fathedu) 

*Example 15.2 Estimating the Return to Education for Men
u wage2, clear
reg educ sibs
ivreg lwage (educ=sibs) 
reg lwage edu, nohead

*Example 15.3 Estimating the Effect of Smoking on Birth Weight
u bwght, clear
reg packs cigprice
ivreg lbwght (packs=cigprice)

*Example 15.4 Using College Proximity as an IV for Education
u card, clear
qui reg educ nearc4 exper* black smsa south smsa66 reg6* 
display "Constant = " _[_cons] ", b1 = " _b[nearc4] ", b2 = " _b[exper]
eststo OLS: qui reg lwage educ exper* black smsa south smsa66 reg6* 
eststo IV: qui ivreg lwage (educ=nearc4) exper* black smsa south smsa66 reg6* 
estout, cells(b(nostar fmt(3)) se(par fmt(3))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Observations)) varlabels(_cons constant) varwidth(20) ti("Table 15.1 Dependent Variable: (lwage)")
est clear

*Example 15.5 Return to Education for Working Women
u mroz, clear
qui reg educ exper* fatheduc motheduc 
test fatheduc motheduc
ivreg lwage (educ=fatheduc motheduc) exper*
qui reg lwage educ exper*
display "b1 = " _b[educ]

*Example 15.6 Using Two Test Scores as Indicators of Ability
u wage2, clear
ivreg lwage educ exper tenure married south urban black (IQ=KWW)

*Example 15.7 Return to Education for Working Women
u mroz, clear
qui reg educ exper* fatheduc motheduc if inlf==1
predict v2, res
ivreg lwage (educ=fatheduc motheduc) exper* v2
qui reg lwage educ exper*
display "The OLS estimate is " _b[educ] " (" _se[educ] ")"

*Example 15.8 Return to Education for Working Women
u mroz, clear
qui ivreg lwage (educ=fatheduc motheduc) exper* 
predict u1, res
reg u1 exper* fatheduc motheduc 
display "N*Rsquared =" e(r2)*e(N)

qui ivreg lwage (educ=fatheduc motheduc huseduc) exper* 
predict u1_h, res
qui reg u1_h exper* fatheduc motheduc huseduc
display "N*Rsquared =" e(r2)*e(N)

qui ivreg lwage (educ=fatheduc motheduc huseduc) exper* 
display "The IV estimate using all three instruments is " _b[educ] " (" _se[educ] ")"
qui ivreg lwage (educ=fatheduc motheduc) exper* 
display "The IV estimate using two instruments is " _b[educ] " (" _se[educ] ")"

*Example 15.9 Effect of Education on Fertility
u fertil1, clear
ivreg kids (educ=meduc feduc) age agesq black-y84
qui reg kids educ age agesq black-y84
display "The OLS estimate is " _b[educ] " (" _se[educ] ")"

//Endogeneity 
reg educ meduc feduc
predict v2, res
ivreg kids (educ=meduc feduc) age agesq black-y84 v2
display "The OLS estimate is " _b[v2] " (" _t[v2] ")"

*Example 15.10 Job Training and Worker Productivity
u jtrain, clear
reg chrsemp cgrant if year==1988
ivreg clscrap (chrsemp = cgrant) if year==1988
ivreg clscrap chrsemp if year==1988

log close 
log2html iexample15, replace ti(Chapter 15 Instrumental Variable - Examples)
