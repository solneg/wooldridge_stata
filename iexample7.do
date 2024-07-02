cap log close // closes any log files 
set more 1 // Tells stata not to wait for keyboard input to continue execution 
clear 

set linesize 90

log using iexample7, replace
**********************************************
* Solomon Negash - Replicating Examples
* Wooldridge (2016). Introductory Econometrics: A Modern Approach. 6th ed.  
* STATA Program, version 15.1. 

* Chapter 7  - Multiple Regression Analysis with Qualitative Information
* Computer Exercises (Examples)
******************** SETUP *********************

*Example7.1. Hourly wage equation
u wage1, clear
reg wage female educ exper tenure
*b1 measures the average wage difference between men and women with the same level of educ, exper and tenure. 
reg wage female 
*b0 is the average wage for men in the sample.
mean wage if female==0
*b1 is the average wage difference between men and women, accounts no other factor
mean wage if female==1
display 4.5877 - 7.0995

*Example7.2. Effect of computer ownership on collage GPA
u gpa1, clear
reg colGPA PC hsGPA ACT
test hsGPA ACT

reg colGPA PC 
mean colGPA if PC==0
mean colGPA if PC==1
display  3.158929 - 2.989412

*Example7.3. Effect of Training Grants on hours of training
u jtrain, clear
reg hrsemp grant lsales lemploy if year==1988

*Example7.4. Housing price regression
u hprice1, clear
d llotsize lsqrft bdrm colonial
reg lprice llotsize lsqrft bdrm colonial

*Example7.5. Hourly wage equation
u wage1, clear
reg lwage female educ exper* tenur*
display exp(-.297) -1 

*Example7.6. Hourly wage equation
u wage1, clear
g marrmale = (female==0 & married==1)
g marrfem = (female==1 & married==1)
g singfem = (female==1 & married==0)
g singmen = (female==0 & married==0)
reg lwage marrmale marrfem singfem educ exper* tenur* 
reg lwage marrmale singmen singfem educ exper* tenur* 

*Example7.7. Effects of physical attractiveness on wage
use beauty, clear
/* if the file is not available in your folder, export it from R using the following script(assuming you have R installed in your PC, otherwise you may skip this):  
install.packages("wooldridge")
library(wooldridge)
data("beauty") 
require(foreign)
write.dta(beauty, "YOUR CURRENT DIRECTORY/beauty.dta")
*/
reg lwage belavg abvavg educ exper* union married black south good if female==0
reg lwage belavg abvavg educ exper* union married black south good if female==1

*Example7.8. Effects of law school rankings on starting salaries
u lawsch85, clear
g r61_100= (rank>=61 & rank<=100)
reg lsalary top10 r11_25 r26_40 r41_60 r61_100 LSAT GPA llibvol lcost
test LSAT GPA llibvol lcost
display exp(0.6996)-1 

*Example7.9. Effects of computer usage on wages
*No data. Link to original article - Kruger 1995, https://www.nber.org/papers/w3858.pdf

*Example7.10. Log hourly wage equation
u wage1, clear
reg lwage c.female##c.educ exper* tenur*
test female c.female#c.educ 

*Example7.11 Effects of race on baseball player salaries
u mlb1, clear
reg lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc allstar black hispan c.black#c.percblck c.hispan#c.perchisp if percblck !=.
test black hispan c.black#c.percblck c.hispan#c.perchisp 
reg lsalary years gamesyr bavg hrunsyr rbisyr runsyr fldperc allstar if percblck !=.

*Equation [7.22]
u gpa3, clear
reg cumgpa c.female##c.sat hsperc c.female#c.hsperc tothrs c.femal#c.tothrs if spring==1
test c.female#c.sat  c.female#c.hsperc  c.femal#c.tothrs 
*Equation [7.25]
reg cumgpa female sat  hsperc  tothrs  if spring==1
*Equation [7.29]
u mroz, clear
reg inlf nwifeinc educ exper* age kidslt6 kidsge6

*Example7.11 A linear probability model of arrest
u crime1, clear
g arr86 = (narr>0) 
reg arr86 pcnv avgsen tottime ptime qemp 
test avgsen tottime
*Equation [7.32]
reg arr86 pcnv avgsen tottime ptime qemp black hispan

*Equation [7.33]
u jtrain, clear
reg lscrap grant lsales lemploy if year==1988

*Equation [7.35] & [7.37]
u fertil2, clear
reg children age educ 
reg children age educ electric

log close
log2html iexample7, replace ti(Chapter 7 - Examples)
