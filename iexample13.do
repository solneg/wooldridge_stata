cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample13, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* CHAPTER 13. Pooling Cross Sections across Time: Simple Panel Data Methods 
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 13.1 Women’s Fertility over Time
u fertil1, clear
reg kids educ age agesq black-y84
test y74 y76 y78 y80 y82 y84

predict u, res
g u2 = u^2
qui reg u2 educ age agesq black-y84
display e(N) * e(r2)

*Example 13.2 Changes in the Return to Education and the Gender Wage Gap
u cps78_85, clear
reg lwage y85 educ y85educ exper expersq union female y85fem
display "Return to Education in 1978 is " _b[educ]*100 "%"
display "Return to Education in 1985 is " (_b[educ] + _b[y85educ])*100 "%"

*Example 13.3 Effect of a Garbage Incinerator’s Location on Housing Prices
u KIELMC, clear
reg rprice nearinc if year==1981
reg rprice nearinc if year==1978
eststo One: reg rprice y81 nearinc y81nrinc 
eststo Two: qui reg rprice y81 nearinc y81nrinc age agesq
eststo Three: qui reg rprice y81 nearinc y81nrinc age agesq intst land area rooms baths 
estout, cells(b(nostar fmt(2)) se(par fmt(2))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared Observations)) varlabels(_cons constant) varwidth(20) ti("Table 13.2 Effects of Incinerator Location on Housing Prices (rprice)")
est clear
reg lprice y81 nearinc y81nrinc 
reg lprice y81 nearinc y81nrinc age agesq lintst lland larea rooms baths 

*Example 13.4 Effect of Worker Compensation Laws on Weeks out of Work
u injury, clear
reg ldurat afchnge highearn afhigh if ky==1

*Example 13.5 Sleeping versus Working
u slp75_81, clear
reg cslpnap ctotwrk ceduc cmarr cyngkid cgdhlth

*Example 13.6 Distributed Lag of Crime Rate on Clear-Up Rate
u crime3, clear
reg clcrime cclrprc1 cclrprc2 

*Example 13.7 Effect of Drunk Driving Laws on Traffic Fatalities
u traffic1, clear
reg cdthrte copen cadmn

*Example 13.8 Effect of Enterprise Zones on Unemployment Claims
u ezunem, clear
reg guclms d82-d88 cez 
display exp(_b[cez])-1
predict u, res
g u2=u^2
g u_1=u[_n-1]
reg u2 d82-d88 cez
reg u d83-d88 cez u_1

*Example 13.9 County Crime Rates in North Carolina 
u crime4, clear
eststo hetrosk: qui reg clcrmrte i.year clprbarr clprbcon clprbpri clavgsen clpolpc
predict u, res
eststo robust: qui reg clcrmrte i.year clprbarr clprbcon clprbpri clavgsen clpolpc, r
estout, cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared Observations)) varlabels(_cons constant) varwidth(20) ti("Dependent Variable is clcrmrte")
est clear
g usq=u^2
g u_1=u[_n-1]
reg usq i.year clprbarr clprbcon clprbpri clavgsen clpolpc
reg u i.year clprbarr clprbcon clprbpri clavgsen clpolpc u_1

log close 
log2html iexample13, replace ti(Chapter 13 Panel Data - Examples)
