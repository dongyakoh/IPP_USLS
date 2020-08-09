/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES OF THE INTERNATIONAL EVIDENCE FOR CANADA
IN "LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.
CREATED BY DONGYA KOH, 3/14/2020
***************************************************************/

clear
clear matrix
set more off,permanently


// SET A PATH TO A FOLDER WHERE DATA FILE IS STORED
cd ""

*-------------------------------------------------------------------------------  
*------------------------------------------------------------------------------- 
// IMPORT SNA68 DATA
import excel "CAN_NA.xlsx", sheet("CAN_NA_1926_1986") cellrange(A1:G62) firstrow clear
ren * *_68
ren year_68 year
save CAN_NA_68.dta, replace


// IMPORT SNA08 DATA
import excel "CAN_NA.xlsx", sheet("CAN_NA") cellrange(A1:G235) firstrow clear
gen qdate 	= yq(real(substr(year, -4, 4)), real(substr(year, 2, 1)))
format qdate %tq

drop if qdate<tq(1961q1) | qdate>tq(2019q1)

// CONVERT QUARTERLY TO YEARLY
drop year
gen year = yofd(dofq(qdate))
collapse (mean) GDP CE Tax_Sub NMI GFCF_IPP GFCF, by(year)
ren * *_08
ren year_08 year


// MERGE 1926-1986 DATA
merge 1:1 year using CAN_NA_68, nogen
sort year


*-------------------------------------------------------------------------------  
* DATA CONSTRUCTION
*------------------------------------------------------------------------------- 
// ADJUST 1926-1986 DATA TO CURRENT LS
foreach var in CE{
	gen `var'_merge 	= `var'_08
	gen r`var'_08_68 	= `var'_08/`var'_68
	reg r`var'_08_68 year  if year>=1961 & year<=1986
	predict r`var'_08_68_hat
	replace `var'_merge	= r`var'_08_68_hat * `var'_68 if year>=1926 & year<1961
}
foreach var in GDP GFCF Tax_Sub{
	gen `var'_merge 	= `var'_08
	gen r`var'_08_68 	= `var'_08/`var'_68
	egen r`var'_08_68_hat = mean(r`var'_08_68)
	replace `var'_merge	= r`var'_08_68_hat * `var'_68 if year>=1926 & year<1961
}
foreach var in NMI{
	gen `var'_merge 	= `var'_08
	gen r`var'_08_68 	= `var'_08/`var'_68
	replace `var'_merge = r`var'_08_68[36]*`var'_68  if year>=1926 & year<1961
}


// EXTRAPOLATE IPP INVESTMENT
gen GFCF_IPP_merge 		= GFCF_IPP_08
gen ratio_IPP_GFCF 		= GFCF_IPP_08/GFCF_merge
replace ratio_IPP_GFCF 	= 0.01 	in 1
reg ratio_IPP_GFCF year if year<1962
predict ratio_IPP_GFCF_hat
replace GFCF_IPP_merge 	= ratio_IPP_GFCF_hat*GFCF_merge if year<1962
line GFCF_IPP_merge GFCF_IPP_08 year


// IMPUTED INCOME COMPONENTS
twoway (line GDP_68 			year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line GDP_08 			year if year>=1961, 			lcolor(blue) lwidth(1.0)) || ///
	   (line GDP_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("GDP") ylabel(, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(2 "SNA08" 3 "Imputed GDP" 1 "SNA68"))
graph export "CAN_GDP_imputed.png", width(1400) height(1000) replace


twoway (line CE_68 				year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line CE_08 				year if year>=1961, 			lcolor(blue) lwidth(1.0)) || ///
	   (line CE_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("CE") ylabel(, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(2 "SNA08" 3 "Imputed CE" 1 "SNA68"))
graph export "CAN_CE_imputed.png", width(1400) height(1000) replace


twoway (line Tax_Sub_68 		year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line Tax_Sub_08 		year if year>=1961, 			lcolor(blue) lwidth(1.0)) || ///
	   (line Tax_Sub_merge 		year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("Tax-Sub") ylabel(, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(2 "SNA08" 3 "Imputed Tax-Sub" 1 "SNA68"))
graph export "CAN_TS_imputed.png", width(1400) height(1000) replace


twoway (line NMI_68 				year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line NMI_08 				year if year>=1961, 			lcolor(blue) lwidth(1.0)) || ///
	   (line NMI_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("NMI") ylabel(, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(2 "SNA08" 3 "Imputed NMI" 1 "SNA68"))
graph export "CAN_NMI_imputed.png", width(1400) height(1000) replace





*-------------------------------------------------------------------------------  
* BY INCOME COMPONENTS
*------------------------------------------------------------------------------- 
ren *_merge *


gen CE_Y0		= CE/GDP
gen CE_Y1		= CE/(GDP - Tax_Sub)
gen CE_Y2		= CE/(GDP - Tax_Sub - NMI)
gen TS_Y0		= Tax_Sub/GDP
gen TS_Y1		= Tax_Sub/(GDP - Tax_Sub)
gen TS_Y2		= Tax_Sub/(GDP - Tax_Sub - NMI)
gen NMI_Y0		= NMI/GDP
gen NMI_Y1		= NMI/(GDP - Tax_Sub)
gen NMI_Y2		= NMI/(GDP - Tax_Sub - NMI)



twoway (line CE_Y0 		year, 				lcolor(green) lwidth(1.0)) || ///
	   (line TS_Y0 		year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line NMI_Y0 	year, 				lcolor(blue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("") ylabel(0(0.1)1.0, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) ///
	   order(1 "CE" 2 "TS" 3 "NMI"))
graph export "CAN_inc_composition0.png", width(1400) height(1000) replace

twoway (line CE_Y1 		year, 				lcolor(green) lwidth(1.0)) || ///
	   (line TS_Y1 		year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line NMI_Y1 	year, 				lcolor(blue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("") ylabel(0(0.1)1.0, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) ///
	   order(1 "CE" 2 "TS" 3 "NMI"))
graph export "CAN_inc_composition1.png", width(1400) height(1000) replace

twoway (line CE_Y2 		year, 				lcolor(green) lwidth(1.0)) || ///
	   (line TS_Y2 		year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line NMI_Y2 	year, 				lcolor(blue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("") ylabel(0(0.1)1.0, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) ///
	   order(1 "CE" 2 "TS" 3 "NMI"))
graph export "CAN_inc_composition2.png", width(1400) height(1000) replace



*-------------------------------------------------------------------------------  
* IPP SHARE
*------------------------------------------------------------------------------- 
gen IPP_ratio = GFCF_IPP/GFCF
twoway (line IPP_ratio 					year if year>=1961, 			lcolor(blue) lwidth(1.0)) || ///
	   (line IPP_ratio 					year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("IPP Share") ylabel(, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(1 "SNA08" 2 "Imputed IPP share"))
graph export "CAN_IPP_share.png", width(1400) height(1000) replace



*-------------------------------------------------------------------------------  
* AGGREGATE LABOR SHARE
*------------------------------------------------------------------------------- 
gen LS0 	= CE/GDP
gen LS1 	= CE/(GDP - Tax_Sub)
gen LS2 	= CE/(GDP - Tax_Sub - NMI)
gen LS0IPP 	= CE/(GDP - GFCF_IPP)
gen LS1IPP 	= CE/(GDP - Tax_Sub - GFCF_IPP)
gen LS2IPP 	= CE/(GDP - Tax_Sub - NMI - GFCF_IPP)
gen sIPP_AGG 	= GFCF_IPP/GFCF
gen sIPP_GVA 	= GFCF_IPP/(GDP-Tax_Sub)

gen ttrend = _n
reg LS0 ttrend
predict XBLS0, xb
reg LS0IPP ttrend
predict XBLS0IPP, xb
reg LS1 ttrend
predict XBLS1, xb
reg LS1IPP ttrend
predict XBLS1IPP, xb
reg LS2 ttrend
predict XBLS2, xb
reg LS2IPP ttrend
predict XBLS2IPP, xb

gen ln_LS2 = ln(LS2)
reg ln_LS2 ttrend
gen ln_LS2IPP = ln(LS2IPP)
reg ln_LS2IPP ttrend



twoway (line LS0 	year, 				lcolor(blue) lwidth(1.0)) || ///
	   (line XBLS0 	year, 				lcolor(blue) lpattern(dash) lwidth(1.0)) || ///
	   (line LS0IPP 	year, 			lcolor(orange) lwidth(1.0)) || ///
	   (line XBLS0IPP 	year, 			lcolor(orange) lpattern(dash) lwidth(1.0)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.45(0.05)0.70, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/Y" 3 "Counterfactual"))
graph export "CAN_LS0.png", width(1400) height(1000) replace


twoway (line LS1 	year, 				lcolor(blue) lwidth(1.0)) || ///
	   (line XBLS1 	year, 				lcolor(blue) lpattern(dash) lwidth(1.0)) || ///
	   (line LS1IPP 	year, 			lcolor(orange) lwidth(1.0)) || ///
	   (line XBLS1IPP 	year, 			lcolor(orange) lpattern(dash) lwidth(1.0)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.45(0.05)0.70, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/(Y-Tax_Sub)" 3 "Counterfactual"))
graph export "CAN_LS1.png", width(1400) height(1000) replace


twoway (line LS2 	year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS2 	year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS2IPP 	year, 			lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS2IPP 	year, 			lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.58(0.02)0.68, labsize(medium)) xtitle("") xlabel(1926(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(2) size(medium) ///
	   order(1 "SNA08" 3 "Pre-SNA93"))
graph export "CAN_LS2.png", width(1400) height(1000) replace
