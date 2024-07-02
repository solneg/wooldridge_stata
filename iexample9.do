cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 90

log using iexample9, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 9  - More on Specification and Data Issues
* Computer Exercises (Examples)
******************** SETUP *********************
 
*Example 9.1.
u crime1, clear
g avgsensq = avgsen^2 
local x "pcnv avgsen tottime ptime86 qemp86 inc86 black hispan"
local x2 "pcnvsq pt86sq inc86sq"
eststo hetrosked: qui reg narr86 `x'
eststo robust: qui reg narr86 `x' `x2', r  
estout , cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons intercept) varwidth(20) ti(Dependent Variables: narr86)
est clear

*Example 9.2.
u hprice1, clear
reg price lotsize sqrft bdrms
predict prhat, xb
g prhat2=prhat^2
g prhat3 = prhat^3
reg price lotsize sqrft bdrms prhat2 prhat3
test prhat2 prhat3

reg lprice llotsize lsqrft bdrms
predict lprhat, xb
g lprhat2=lprhat^2
g lprhat3 = lprhat^3
reg lprice llotsize lsqrft bdrms lprhat2 lprhat3
test lprhat2 lprhat3

*Example 9.3. IQ as a Proxy for Ability
u wage2, clear
eststo A: qui reg lwage educ exper tenur married south urban black 
eststo B: qui reg lwage educ exper tenur married south urban black IQ
eststo C: qui reg lwage educ exper tenur married south urban black IQ c.educ#c.IQ
estout , cells(b(nostar fmt(3)) se(par fmt(3))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons intercept) varwidth(20) ti(Dependent Variables: log(wage))
est clear


*Example 9.4. City Crime Rates
u crime2, clear
eststo A: qui reg lcrmrte unem llawexp if year==87
eststo B: qui reg lcrmrte unem llawexp lcrmrt_1 if year==87
estout , cells(b(nostar fmt(3)) se(par fmt(3))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Adj-R-squared)) varlabels(_cons intercept) varwidth(20) ti("Table 9.3 Dependent Variable: log(crmrte_87)")
est clear

*Example 9.5 Savings Function with Measurement Error
**NA

*Example 9.6 Measurement Error in Scrap Rates
**NA

*Example 9.7 GPA Equation with Measurement Error
**NA

*Example 9.8 R&D Intensity and Firm Size
u rdchem, clear
reg rdintens sales profmarg
reg rdintens sales profmarg if sales<30000

*Example 9.9 R&D Intensity
u rdchem, clear
reg lrd lsales profmarg
reg lrd lsales profmarg if sales<30000

*Example 9.10 State Infant Mortality Rates
u infmrt, clear
reg infmort lpcinc lphysic lpopul if year==1990
reg infmort lpcinc lphysic lpopul if year==1990 & DC==0

log close
log2html iexample9, replace ti(Chapter 9 - Examples)
