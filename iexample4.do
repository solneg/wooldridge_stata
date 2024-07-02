cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample4, replace

**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6ed.  
* STATA Program, version 15.1. 

* Chapter 4  - Multiple Regression Analysis: Inference
* Computer Exercises (Examples)
******************** SETUP *********************

*example4.1. Wage equation
u wage1.dta, clear
reg lwage educ exper tenure

*example4.2. Student performance
u meap93.dta, clear
*Lin-lin model
eststo: reg math10 totcomp staff enroll
*Lin-log model
eststo: reg math10 ltotcomp lstaff lenroll
estout *, cells(b(star fmt(3)) se(par fmt(2))) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))   legend label collabels(none) varlabels(_cons Constant)
est clear

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

*example4.7 Job training (only for the year 1987 and for nonunionized firms)
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

*Exaploring further 4.5
u attend, clear
eststo: reg atndrte priGPA 
eststo: reg atndrte priGPA ACT
estout *, cells(b(star fmt(3)) se(par fmt(2))) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))   legend label collabels(none) varlabels(_cons Constant)
est clear

*example4.10 Salary-pension tradeoff for teachers
u meap93.dta, clear 
d bensal
eststo: qui reg lsalary bensal
eststo: qui reg lsalary bensal lenrol lstaff 
eststo: qui reg lsalary bensal lenrol lstaff droprate gradrate 
estout *, cells(b(star fmt(3)) se(par fmt(2))) stats(r2_a N, fmt(%9.3f %9.0g) labels(R-squared))    varlabels(_cons Constant) ti("Compare to Table 4.1 on the textbook")
est clear

log close
log2html iexample4, replace ti(Chapter 4 - Examples)
