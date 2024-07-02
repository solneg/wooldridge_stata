cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample4.log, replace

**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 4  - Multiple Regression Analysis: Inference
* Computer Exercises (Examples)
* Nov 21, 2018
******************** SETUP *********************

*example4.1. Wage equation
u wage1.dta, clear
reg lwage educ exper tenure

*example4.2. Student performance
u meap93.dta, clear

reg math10 totcomp staff enroll
*level-log model
reg math10 ltotcomp lstaff lenroll

*example4.3. Collage GPA
u gpa1.dta, clear
reg colGPA hsGPA ACT skipped

*example4.4 Campus crime & enrollment
u campus.dta, clear
reg lcrime lenroll


*example4.5 Housing prices
u hprice2.dta, clear 
g ldist=ln(dist) 
reg  lprice lnox ldist rooms stratio


*example4.6 Participation rates in 401k plans
u 401k.dta, clear
reg prate mrate age totemp 


*example4.7 Job training 
u jtrain.dta, clear
d year union 
reg lscrap hrsemp lsales lemploy if year==1987 & union==0
 
*example4.8 
u rdchem.dta, clear
reg lrd lsales profmarg

*example4.9 Parent's education on birth weight
u bwght.dta, clear
reg bwght cigs parity faminc motheduc fatheduc
test motheduc fatheduc

reg bwght cigs parity faminc 

*example4.10 Salary-pension tradeoff for teachers
u meap93.dta, clear 

d bensal

qui reg lsalary bensal
estimates store col1 

qui reg lsalary bensal lenrol lstaff 
estimates store col2 

qui reg lsalary bensal lenrol lstaff droprate gradrate 
estimates store col3
esttab col*, se r2  //Compare to Table 4.1 on the textbook



log close
