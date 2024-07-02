cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample14, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* CHAPTER 14. Advanced Panel Data Methods 
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 14.1 Effect of Job Training on Firm Scrap Rates
u jtrain, clear
xtset fcode year
xtreg lscrap d88 d89 grant grant_1, fe
display exp(_b[grant_1])-1
xtreg lscrap d88 d89 grant, fe

*Example 14.2 Has the Return to Education Changed over Time?
u wagepan, clear
xtset nr year
xtreg lwage c.educ##i.year union mar, fe
testparm c.educ#i.year

*Example 14.3 Effect of Job Training on Firm Scrap Rates
u jtrain, clear
xtset fcode year
xtreg lscrap d88 d89 grant grant_1 lsales lempl, fe

*Example 14.4 A Wage Equation Using Panel Data
u wagepan, clear
xtset nr year
eststo POLS: qui reg lwage educ black hisp exper expersq mar union i.year
eststo RE: qui xtreg lwage educ black hisp exper expersq mar union i.year, re
eststo FE: qui xtreg lwage expersq mar union i.year, fe
estout, cells(b(nostar fmt(3)) se(par fmt(3))) stats(r2 N, fmt(%9.3f %9.0g) labels(R-squared Observations)) varlabels(_cons constant) varwidth(20) ti("Table 14.2 Three Different Estimators of a Wage Equation (lwage)")
est clear

log close 
log2html iexample14, replace ti(Chapter 14 Advanced Panel Data - Examples)
