/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES OF THE INTERNATIONAL EVIDENCE FOR JAPAN
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

// IMPORT MAIN DATA
import excel "JPN_NA.xlsx", sheet("GFCF_merge") cellrange(A2:C65) firstrow clear
ren GFCF 		GFCF_OECD
ren GFCF_IPP 	GFCF_IPP_OECD
save OECD.dta, replace

import excel "JPN_NA.xlsx", sheet("SNA08") cellrange(A1:L26) firstrow clear
ren * *_08
ren year_08 year
save SNA08.dta, replace

import excel "JPN_NA.xlsx", sheet("SNA93") cellrange(A1:J31) firstrow clear
ren * *_93
ren year_93 year
save SNA93.dta, replace

import excel "JPN_NA.xlsx", sheet("SNA68") cellrange(A1:G45) firstrow clear
ren * *_68
ren year_68 year
save SNA68.dta, replace


// MERGE ALL THE DATA
use SNA08.dta, clear
merge 1:1 year using SNA93.dta, nogen
merge 1:1 year using SNA68.dta, nogen
merge 1:1 year using OECD.dta, nogen


*-------------------------------------------------------------------------------  
* DATA CONSTRUCTION
*------------------------------------------------------------------------------- 
// MERGE GFCF
gen GFCF_merge 		= GFCF_08
gen rGFCF_08_93 	= GFCF_08/(GFCF_93 - GFCF_SFT_93)
gen rGFCF_93_68 	= (GFCF_93 - GFCF_SFT_93)/GFCF_68
reg rGFCF_08_93 year if year>=1994 & year<=2009
predict rGFCF_08_93_hat, xb
reg rGFCF_93_68 year if year>=1980 & year<=1998
predict rGFCF_93_68_hat, xb
replace GFCF_merge = rGFCF_08_93_hat*(GFCF_93 - GFCF_SFT_93) if year>=1980 & year<1994
replace GFCF_merge = rGFCF_93_68_hat*rGFCF_08_93_hat*GFCF_68 if year>=1955 & year<1980
gen diffGFCF = GFCF_merge/GFCF_OECD

twoway (line GFCF_merge 	year if year>=1994, 			lcolor(blue) lwidth(1.0)) || ///
	   (line GFCF_merge 	year, 							lcolor(blue) lwidth(1.0) lpattern(dash)) || ///
	   (line GFCF_93 		year, 							lcolor(midblue) lwidth(1.0)) || ///
	   (line GFCF_68 		year, 							lcolor(ltblue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("GFCF") ylabel(, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) ///
	   order(1 "SNA08" 2 "Imputed SNA08" 3 "SNA93" 4 "SNA68"))
graph export "JPN_GFCF_imputed.png", width(1400) height(1000) replace


// EXTRAPOLATE IPP
gen GFCF_IPP_merge1 	= GFCF_IPP_08
gen GFCF_IPP_merge2 	= GFCF_IPP_08
gen rGFCF_IPP			= GFCF_IPP_08/GFCF_merge

gen rGFCF_IPP_hat1 	= rGFCF_IPP
gen ln_rGFCF_IPP 	= ln(rGFCF_IPP)
reg ln_rGFCF_IPP year if year<2010
predict ln_rGFCF_IPP_hat
replace rGFCF_IPP_hat1 = exp(ln_rGFCF_IPP_hat) if year<1994
replace GFCF_IPP_merge1 = rGFCF_IPP_hat1*GFCF_merge if year<1994

replace rGFCF_IPP 	= 0.04 if year==1955
ipolate rGFCF_IPP year, gen(rGFCF_IPP_hat2)
replace GFCF_IPP_merge2 = rGFCF_IPP_hat2*GFCF_merge if year<1994
twoway (line rGFCF_IPP_hat1 	year, 							lcolor(ltblue) lwidth(1.0) lpattern(dash)) || ///
	   (line rGFCF_IPP_hat2 	year, 							lcolor(blue) lwidth(1.0) lpattern(dash)) || ///
	   (line rGFCF_IPP 			year if year>=1994, 			lcolor(blue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("IPP/GFCF Ratio") ylabel(, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(3 "SNA08" 1 "Imputed IPP/GFCF (exponential)" 2 "Imputed IPP/GFCF (linear)"))
graph export "JPN_GFCF_IPP_imputed.png", width(1400) height(1000) replace


gen GFCF_IPP_merge = GFCF_IPP_merge1

// ADJUST GDP
*gen GDP_merge 		= GDP_08
replace GDP_93 	= (GDP_93 - GFCF_SFT_93) + GFCF_IPP_merge
replace GDP_68 	= GDP_68 + GFCF_IPP_merge


// ADJUST CE, Tax, Sub, NMI
// THIS CREATES EXTRA BIAS IN LS
// SO EVENTUALLY WE DID NOT USE THESE ADJUSTED CE, TAX, SUB, NMI
foreach var in GDP CE Tax Sub NMI{
	
	gen `var'_merge 	= `var'_08
	gen r`var'_08_93 	= `var'_08/`var'_93
	egen r`var'_08_93_hat = mean(r`var'_08_93)
*	gen r`var'_08_93_hat = r`var'_08_93[40]
*	reg r`var'_08_93 year if year>=1994 & year<=2009
*	predict r`var'_08_93_hat
	replace `var'_merge	= r`var'_08_93_hat * `var'_93 if year>=1980 & year<1994

	gen r`var'_93_68 	= `var'_93/`var'_68
	egen r`var'_93_68_hat = mean(r`var'_93_68)
*	gen r`var'_93_68_hat = r`var'_93_68[26]
*	reg r`var'_93_68 year if year>=1980 & year<=1998
*	predict r`var'_93_68_hat
	replace `var'_merge	=  r`var'_08_93_hat * r`var'_93_68_hat * `var'_68 if year<1980
	
}

twoway (line GDP_93 			year, 							lcolor(midblue) lwidth(1.0)) || ///
	   (line GDP_68 			year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line GDP_08 			year if year>=1994, 			lcolor(blue) lwidth(1.0)) || ///
	   (line GDP_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("GDP") ylabel(, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(3 "SNA08" 4 "Imputed GDP" 1 "SNA93" 2 "SNA68"))
graph export "JPN_GDP_imputed.png", width(1400) height(1000) replace


twoway (line CE_93 			year, 							lcolor(midblue) lwidth(1.0)) || ///
	   (line CE_68 			year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line CE_08 			year if year>=1994, 			lcolor(blue) lwidth(1.0)) || ///
	   (line CE_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("CE") ylabel(, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(3 "SNA08" 4 "Imputed GDP" 1 "SNA93" 2 "SNA68"))
graph export "JPN_CE_imputed.png", width(1400) height(1000) replace



twoway (line Tax_93 			year, 							lcolor(midblue) lwidth(1.0)) || ///
	   (line Tax_68 			year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line Tax_08 			year if year>=1994, 			lcolor(blue) lwidth(1.0)) || ///
	   (line Tax_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("CE") ylabel(, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(3 "SNA08" 4 "Imputed GDP" 1 "SNA93" 2 "SNA68"))
graph export "JPN_Tax_imputed.png", width(1400) height(1000) replace



twoway (line Sub_93 			year, 							lcolor(midblue) lwidth(1.0)) || ///
	   (line Sub_68 			year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line Sub_08 			year if year>=1994, 			lcolor(blue) lwidth(1.0)) || ///
	   (line Sub_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("CE") ylabel(, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(3 "SNA08" 4 "Imputed GDP" 1 "SNA93" 2 "SNA68"))
graph export "JPN_Sub_imputed.png", width(1400) height(1000) replace


twoway (line NMI_93 			year, 							lcolor(midblue) lwidth(1.0)) || ///
	   (line NMI_68 			year, 							lcolor(ltblue) lwidth(1.0)) || ///
	   (line NMI_08 			year if year>=1994, 			lcolor(blue) lwidth(1.0)) || ///
	   (line NMI_merge 			year, 							lcolor(blue) lwidth(1.0) lpattern(dash)), ///
	   scheme(s1color) ytitle("CE") ylabel(, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(10) ring(0) col(1) size(medium) order(3 "SNA08" 4 "Imputed GDP" 1 "SNA93" 2 "SNA68"))
graph export "JPN_NMI_imputed.png", width(1400) height(1000) replace



ren GDP_merge 		Y
ren GFCF_IPP_merge	I_IPP
ren GFCF_merge		I_AGG
ren CE_merge		CE
ren Tax_merge		Tax
ren Sub_merge		Sub
ren NMI_merge		NMI


*-------------------------------------------------------------------------------  
* BY INCOME COMPOSITIONS
*------------------------------------------------------------------------------- 
gen CE_Y0		= CE/Y
gen CE_Y1		= CE/(Y - Tax + Sub)
gen CE_Y2		= CE/(Y - Tax + Sub - NMI)
gen TS_Y0		= (Tax - Sub)/Y
gen TS_Y1		= (Tax - Sub)/(Y - Tax + Sub)
gen TS_Y2		= (Tax - Sub)/(Y - Tax + Sub - NMI)
gen NMI_Y0		= NMI/Y
gen NMI_Y1		= NMI/(Y - Tax + Sub)
gen NMI_Y2		= NMI/(Y - Tax + Sub - NMI)



twoway (line CE_Y0 		year, 				lcolor(green) lwidth(1.0)) || ///
	   (line TS_Y0 		year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line NMI_Y0 	year, 				lcolor(blue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("") ylabel(0(0.1)1.0, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) ///
	   order(1 "CE" 2 "TS" 3 "NMI"))
graph export "JPN_inc_composition0.png", width(1400) height(1000) replace

twoway (line CE_Y1 		year, 				lcolor(green) lwidth(1.0)) || ///
	   (line TS_Y1 		year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line NMI_Y1 	year, 				lcolor(blue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("") ylabel(0(0.1)1.0, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) ///
	   order(1 "CE" 2 "TS" 3 "NMI"))
graph export "JPN_inc_composition1.png", width(1400) height(1000) replace

twoway (line CE_Y2 		year, 				lcolor(green) lwidth(1.0)) || ///
	   (line TS_Y2 		year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line NMI_Y2 	year, 				lcolor(blue) lwidth(1.0)), ///
	   scheme(s1color) ytitle("") ylabel(0(0.1)1.0, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) ///
	   order(1 "CE" 2 "TS" 3 "NMI"))
graph export "JPN_inc_composition2.png", width(1400) height(1000) replace



*-------------------------------------------------------------------------------  
* AGGREGATE LABOR SHARE AND IPP EFFECTS
*------------------------------------------------------------------------------- 
gen LS0 		= CE/Y
gen LS1 		= CE/(Y - Tax + Sub)
gen LS2 		= CE/(Y - Tax + Sub - NMI)
gen LS0IPP 		= CE/(Y - I_IPP)
gen LS1IPP 		= CE/(Y - Tax + Sub - I_IPP)
gen LS2IPP 		= CE/(Y - Tax + Sub - NMI - I_IPP)
gen sIPP_AGG 	= I_IPP/I_AGG
gen sIPP_GVA 	= I_IPP/(Y - Tax + Sub)


sort year
reg LS0 year
predict XBLS0
reg LS0IPP year
predict XBLS0IPP
reg LS1 year
predict XBLS1
reg LS1IPP year
predict XBLS1IPP
reg LS2 year
predict XBLS2
reg LS2IPP year
predict XBLS2IPP


gen tt = _n
gen ln_LS2 = ln(LS2)
reg ln_LS2 tt
gen ln_LS2IPP = ln(LS2IPP)
reg ln_LS2IPP tt


reg LS2 year if year>1975
reg LS2IPP year if year>1975


twoway (line LS0 		year, 				lcolor(blue) lwidth(1.0)) || ///
	   (line XBLS0 		year, 				lcolor(blue) lpattern(dash) lwidth(1.0)) || ///
	   (line LS0IPP 	year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line XBLS0IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(1.0)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.4(0.05)0.80, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/Y" 3 "Counterfactual"))
graph export "JPN_LS0.png", width(1400) height(1000) replace


twoway (line LS1 		year, 				lcolor(blue) lwidth(1.0)) || ///
	   (line XBLS1 		year, 				lcolor(blue) lpattern(dash) lwidth(1.0)) || ///
	   (line LS1IPP 	year, 				lcolor(orange) lwidth(1.0)) || ///
	   (line XBLS1IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(1.0)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.4(0.05)0.80, labsize(medium)) xtitle("") xlabel(1955(4)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/(Y-Tax_Sub)" 3 "Counterfactual"))
graph export "JPN_LS1.png", width(1400) height(1000) replace


twoway (line LS2 		year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS2 		year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS2IPP 	year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS2IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.52(0.04)0.72, labsize(medium)) xtitle("") xlabel(1955(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) ring(0) col(2) size(medium) ///
	   order(1 "SNA08" 3 "Pre-SNA93"))
graph export "JPN_LS2.png", width(1400) height(1000) replace

