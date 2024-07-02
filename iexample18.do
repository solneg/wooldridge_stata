cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 85

log using iexample18, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* CHAPTER 18 Advanced Time Series Topics
* Computer Exercises (Examples)
******************** SETUP *********************

*Example 18.1 Housing Investment and Residential Price Inflation
u hseinv, clear
tsset year
reg linvpc t
predict y, res
g y1 = y[_n-1]
g gprice_1 = gprice[_n-1] 
eststo GeometricDL: qui reg y gprice y1 
eststo RationalDL: qui reg y gprice y1 gprice_1
estout, cells(b(nostar fmt(3)) se(par fmt(3))) stats(N r2_a, fmt(%5.0g) labels(Smaple-size Adjusted-R-squared)) varlabels(_cons constant) varwidth(18) ti("Table 18.1 Distributed Lag Models for Housing Investment: log(invpc)")
est clear

*Example 18.2 Unit Root Test for Three-Month T-Bill Rates
u intqrt, clear
reg cr3 r3_1
display "roh = " 1 + _b[r3_1]
di "t statistics on r3_1 = " _b[r3_1]/_se[r3_1]
reg r3 r3_1

*Example 18.3 Unit Root Test for Annual U.S. Inflation
u phillips, clear
reg cinf inf_1 cinf_1
di "roh = " 1 + _b[inf_1]
reg cinf inf_1
di "roh2 = " 1 + _b[inf_1]

*Example 18.4 Unit Root in the Log of U.S. Real Gross Domestic Product
u inven, clear
g lgdp_1 = ln(gdp[_n-1])
g ggdp_1 = ggdp[_n-1]
egen t=seq()
reg ggdp t lgdp_1 ggdp_1 
di "roh = " 1 + _b[lgdp_1]
reg ggdp lgdp_1 ggdp_1 
di "roh = " 1 + _b[lgdp_1]

*Example 18.5 Cointegration between Fertility and Personal Exemption
u fertil3, clear
tsset t
//regression in levels
reg gfr t pe 
predict u, res
//regression in levels
reg cgfr cpe 
// Augmented DF test for gfr & pe
dfuller gfr, lags(1) trend
dfuller pe,  lags(1) trend
//Regression in levels with a single lag & time trend, manually
gen u_1=u[_n-1]
gen cu = u - u_1
gen cu_1 = cu[_n-1]
reg cu u_1 cu_1 t
//Augumented DF test stata command
dfuller u, lags(1) trend reg
// First difference regression, with two lags (equation 11.27)
reg cgfr cpe cpe_1 cpe_2

*Example 18.6 Cointegrating Parameter for Interest Rates
u intqrt, clear
g cr3_2=cr3[_n-2]
g cr3_a=cr3[_n+1]
g cr3_b=cr3[_n+2]
reg r6 r3 cr3 cr3_1 cr3_2 cr3_a cr3_b
*test Ho: B=1
di (_b[r3]-1)/_se[r3]
*Test serial correlation
predict u, res
g u_1 = u[_n-1]
reg r6 r3 cr3 cr3_1 cr3_2 cr3_a cr3_b u_1
reg u u_1
*Compare with Simple OLS
reg r6 r3

*Example 18.7 Error Correction Model for Holding Yields
u intqrt, clear
g hy3_2=hy3[_n-2]
g hy6_1hy3_2= hy6_1 - hy3_2
reg chy6 chy3_1 hy6_1hy3_2

*Example 18.8 Forecasting the U.S. Unemployment Rate
u phillips, clear
reg unem unem_1
di "Forcasts of unem for 1997 =" %6.3f _b[_cons] + _b[unem_1]*5.4 
reg unem unem_1 inf_1
di "Forcasts of unem for 1997 =" %6.3f _b[_cons] + _b[unem_1]*5.4 + _b[inf_1]*3
*95% forecast interval
g unem_1f = unem_1 - 5.4
g inf_1f = inf_1 - 3
reg unem unem_1f inf_1f
di "Forcast = "%5.3f _b[_cons] ", SE = " %5.3f _se[_cons] " & se(e+1) = " %5.3f [_se[_cons]^2 + e(rmse)^2]^0.5
di "The 95% forcast interval is " "[" %6.3f _b[_cons] - 1.96 * [_se[_cons]^2 + e(rmse)^2]^0.5 " , "%6.3f _b[_cons] + 1.96 * [_se[_cons]^2 + e(rmse)^2]^0.5 "]"

*Example 18.9 Out-of-Sample Comparisons of Unemployment Forecasts
u phillips, clear
qui reg unem unem_1 
di "RMSE = " %5.3f e(rmse)
predict u, res
g ua=abs(u)
sum ua
di "MSE = " %5.3f r(mean)
qui reg unem unem_1 inf_1 
di "RMSE = " %5.3f e(rmse)
predict uinf, res
g uinfa=abs(uinf)
sum uinfa
di "MSE = " %5.3f r(mean)

*Example 18.10 Two-Year-Ahead Forecast for the Unemployment Rate
u phillips, clear
reg inf inf_1 unem_1, nohead
reg inf inf_1
qui { 
g inf_96=inf if year==1996
g inf_97= _b[_cons] + _b[inf]*inf_96
sum inf_97 
}
di "Inf_97 = " %5.2f r(mean)
qui {
reg unem unem_1 inf_1
g unem_96 = unem if year==1996
g unem_97 = _b[_cons] + _b[unem_1]*unem_96 + _b[inf]*inf_96
g unem_98 = _b[_cons] + _b[unem_1]*unem_97 + _b[inf]*inf_97
sum unem_98
}
di "unem_98 = " %5.2f  r(mean)

log close 
log2html iexample18, replace ti(Chapter 18. Advanced Time Series Topics - Examples)
