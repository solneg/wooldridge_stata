cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample16, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* CHAPTER 16 Simultaneous Equations Models
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 16.1 Murder Rates and Size of the Police Force
//NA

*Example 16.2 Housing Expenditures and Saving
//NA

*Example 16.3 Labor Supply of Married, Working Women
//NA

*Example 16.4 Inflation and Openness
//NA

*Example 16.5 Labor Supply of Married, Working Women
u mroz, clear
ivreg hours (lwage=exper*) educ age kidslt6 nwifeinc
ivreg lwage (hours= age kidslt6 nwifeinc) educ exper*  

*Example 16.6 Inflation and Openness
u openness, clear
reg open lpcinc lland
ivreg inf (open=lland) lpcinc

*Example 16.7 Testing the Permanent Income Hypothesis
u consump, clear
ivreg gc (gy r3 =gy_1 gc_1 r3_1) 
predict u, res
g u_1 = u[_n-1]
reg u u_1
ivreg gc (gy r3 =gy_1 gc_1 r3_1) u_1 //Note the difference with the answer in the text book.

*Example 16.8 Effect of Prison Population on Violent Crime Rates
u prison, clear
local z "gpolpc gincpc cunem cblack cmetro cag0_14 cag15_17 cag18_24 cag25_34"
ivreg gcriv (gpris = final1 final2) `z' 
reg gcriv gpris `z'

log close 
log2html iexample16, replace ti(Chapter 16 Simultaneous Equations - Examples)
