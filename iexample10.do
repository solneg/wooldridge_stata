cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 90

log using iexample10, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 10 Basic Regression Analysis with Time Series Data
* Computer Exercises (Examples)
******************** SETUP *********************
 
*Example 10.1. Static Phillips Curve
u phillips, clear
reg inf unem

*Example 10.2.  Effects of Inflation and Deficits on Interest Rates
bcuse intdef, clear
reg i3 inf def
display _b[inf]

*Example 10.3. Puerto Rican Employment and the Minimum Wage
u prminwge, clear
reg lprepop lmincov lusgnp

*Example 10.4. Effects of Personal Exemption on Fertility Rates
u fertil3, clear
reg gfr pe ww2 pill
reg gfr pe pe_1 pe_2 ww2 pill
display _b[pe] + _b[pe_1] + _b[pe_2] 

*Example 10.5. Antidumping Filings and Chemical Imports
u barium, clear
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6
display 100*(exp(_b[afdec6]) -1)

*Example 10.6. Election Outcomes and Economic Performance
u fair, clear
reg demvote partyWH incum c.partyWH#c.gnew c.partyWH#c.inf if year<1996
display _b[_cons] + _b[partyWH] + _b[incum] + _b[c.partyWH#c.gnew]*3 + _b[c.partyWH#c.inf]*3.019

*Example 10.7 Housing Investment and Prices
u hseinv, clear
reg linvpc lprice
reg linvpc lprice t

*Example 10.8 Fertility Equation
u fertil3, clear
reg gfr pe ww2 pill t
reg gfr pe ww2 pill t tsq

*Example 10.9 Puerto Rican Employment
u prminwge, clear
reg lprepop lmincov lusgnp t

*Example 10.10 Housing Investment
u hseinv, clear
reg linvpc lprice t
qui reg linvpc t
predict uh, res
eststo Detrended: qui reg uh lprice t
eststo Trended: qui reg linvpc lprice t
estout , cells(b(nostar fmt(4)) se(par fmt(4))) stats(r2 r2_a N, fmt(%9.3f %9.3f %9.0g) labels(R-squared Adj-R-squared N)) varlabels(_cons intercept) varwidth(20) ti(Dependent Variables: log(invpc))
est clear

*Example 10.11 Effects of Antidumping Filings
u barium, clear
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6 feb-dec
test feb mar apr may jun jul aug sep oct nov dec
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6 spr sum fall
test spr sum fall

log close
log2html iexample10, replace ti(Chapter 10 Time Series - Examples)
