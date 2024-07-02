cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample11, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 11 Further Issues in Using OLS with Time Series Data
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 11.1 Static Model
//NA

* Example 11.2 Finite Distributed Lag Model
//NA

*Example 11.3 AR(1) Model
//NA

*Example 11.4 Efficient Markets Hypothesis
u nyse, clear
reg return return_1
//Equation [11.18]
g return_2 = return[_n-2]
reg return return_1 return_2
test return_1 return_2

*Example 11.5 Expectations Augmented Phillips Curve
u phillips, clear
d
reg cinf unem
display as text "u_0 = " _b[_cons]/-_b[unem]

*Example 11.6 Fertility Equation
u fertil3, clear
reg cgfr cpe cpe_1 cpe_2
test cpe cpe_1

*Example 11.7 Wages and Productivity
u earns, clear
reg lhrwage loutphr t
reg ghrwage goutphr

*Example 11.8 Fertility Equation
u fertil3, clear
reg cgfr cgfr_1 cpe cpe_1 cpe_2 
test cpe cpe_1

log close
log2html iexample11, replace ti(Chapter 11 - Examples)
