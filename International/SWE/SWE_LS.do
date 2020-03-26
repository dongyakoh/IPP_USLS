/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES OF THE INTERNATIONAL EVIDENCE FOR SWEDEN
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

* IMPORT MAIN DATA
import excel "SWE_NA.xlsx", sheet("SWE_NA") cellrange(A1:H70) firstrow clear


drop if year<1950 | year>2018

*-------------------------------------------------------------------------------  
* IMPUTE IPP INVESTMENT
*------------------------------------------------------------------------------- 
gen IPP_GFCF_ratio = GFCF_IPP/GFCF
gen IPP_GFCF_ratio_hat = IPP_GFCF_ratio
replace IPP_GFCF_ratio_hat = 0.044 if year==1950
reg IPP_GFCF_ratio_hat year if year<=1980
predict IPP_GFCF_ratio_hat2
replace IPP_GFCF_ratio_hat = IPP_GFCF_ratio_hat2 if year<=1980
replace GFCF_IPP = IPP_GFCF_ratio_hat * GFCF if missing(GFCF_IPP)


twoway (line IPP_GFCF_ratio 			year if year>=1980, 			lcolor(blue) lwidth(1.0)) || ///
	   (line IPP_GFCF_ratio_hat 		year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("IPP Share") ylabel(, labsize(medium)) xtitle("") xlabel(1950(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(1 "SNA08" 2 "Imputed IPP share"))
graph export "SWE_IPP_share.png", width(1400) height(1000) replace



*-------------------------------------------------------------------------------  
* LS
*------------------------------------------------------------------------------- 
ren GDP 		Y
ren GFCF_IPP 	I_IPP
ren GFCF 		I_AGG


gen LS0 	= CE/Y
gen LS1 	= CE/(Y - Tax_Sub)
gen LS2 	= CE/(Y - Tax_Sub - NMI)
gen LS3 	= CE/(Y - NMI)
gen LS0IPP 	= CE/(Y - I_IPP)
gen LS1IPP 	= CE/(Y - Tax_Sub - I_IPP)
gen LS2IPP 	= CE/(Y - Tax_Sub - NMI - I_IPP)
gen LS3IPP 	= CE/(Y - NMI - I_IPP)
gen sIPP_AGG 	= I_IPP/I_AGG
gen sIPP_GVA 	= I_IPP/Y


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
reg LS3 ttrend
predict XBLS3, xb
reg LS3IPP ttrend
predict XBLS3IPP, xb


gen tt = _n
gen ln_LS2 = ln(LS2)
reg ln_LS2 tt
gen ln_LS2IPP = ln(LS2IPP)
reg ln_LS2IPP tt


ss
twoway (line LS0 	year, 				lcolor(blue) lwidth(1)) || ///
	   (line XBLS0 	year, 				lcolor(blue) lpattern(dash) lwidth(1)) || ///
	   (line LS0IPP 	year, 				lcolor(orange) lwidth(1)) || ///
	   (line XBLS0IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(1)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.4(0.05)0.80, labsize(medium)) xtitle("") xlabel(1950(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/Y" 3 "Counterfactual"))
graph export "SWE_LS0.png", width(1400) height(1000) replace

twoway (line LS1 	year, 				lcolor(blue) lwidth(1)) || ///
	   (line XBLS1 	year, 				lcolor(blue) lpattern(dash) lwidth(1)) || ///
	   (line LS1IPP 	year, 				lcolor(orange) lwidth(1)) || ///
	   (line XBLS1IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(1)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.4(0.05)0.80, labsize(medium)) xtitle("") xlabel(1950(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/(Y-Tax_Sub)" 3 "Counterfactual"))
graph export "SWE_LS1.png", width(1400) height(1000) replace

twoway (line LS2 		year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS2 		year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS2IPP 	year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS2IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.53(0.04)0.77, labsize(medium)) xtitle("") xlabel(1950(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(2) size(medium) ///
	   order(1 "SNA08" 3 "Pre-SNA93"))
graph export "SWE_LS2.png", width(1400) height(1000) replace

