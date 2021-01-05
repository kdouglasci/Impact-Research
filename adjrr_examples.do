clear all
set more off
capture log close


sjlog using adjrr1, replace
use meps2004_adjrr.dta
summarize
sjlog close, replace

sjlog using adjrr2, replace
tab ins_group
sjlog close, replace


*****************************************
***** ARR & ARD for binary outcomes *****
*****************************************

sjlog using adjrr3, replace
logit insured female age race_bl race_oth, nolog
sjlog close, replace

sjlog using adjrr4, replace
adjrr female
adjrr age, x0(20) x1(30)
sjlog close, replace

sjlog using adjrr5, replace
probit insured female age race_bl race_oth, nolog
sjlog close, replace

sjlog using adjrr6, replace
adjrr female
adjrr age, x0(20) x1(30)
sjlog close, replace

sjlog using adjrr7, replace
adjrr female if race_bl == 1
sjlog close, replace


**********************************************
***** ARR & ARD for 3+ outcomes - mlogit *****
**********************************************
sjlog using adjrr8, replace
mlogit ins_group female age race_bl race_oth, nolog
sjlog close, replace

sjlog using adjrr9, replace
adjrr female
sjlog close, replace


**********************************************
***** ARR & ARD for 3+ outcomes - oprobit *****
**********************************************
sjlog using adjrr10, replace
oprobit ins_group female age race_bl race_oth, nolog
adjrr female
sjlog close, replace


***********************************************
********* ARR & ARD for survey data ***********
***********************************************
/* use NHANES data */
sjlog using adjrr11, replace
webuse nhanes2
logit diabetes i.female c.age i.female#c.age i.black i.orace, nolog
adjrr female
sjlog close, replace

sjlog using adjrr12, replace
adjrr female, at((mean) age)
sjlog close, replace

sjlog using adjrr13, replace
svyset psu [pweight=finalwgt], strata(strata)
svy: logit diabetes i.female c.age i.female#c.age i.black i.orace, nolog
adjrr female
sjlog close, replace

