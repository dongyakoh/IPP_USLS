/***************************************************************
THIS PROGRAM GENERATES CORPORATE SECTOR LABOR SHARE IN THE APPENDIX OF
"LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.

CREATED BY DONGYA KOH, 7/4/2019
***************************************************************/
	
clear
clear matrix
set more off,permanently

cd ""


// IMPORT DATA FROM NIPA AND FAT TABLES
import excel "IPP_USLS_CORP_DATA.xlsx", sheet("NIPA1.14") cellrange(A1:AF91) firstrow clear
save NIPA1_14.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("FAT4.1") cellrange(A1:M94) firstrow clear
save FAT4_1.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("FAT4.4") cellrange(A1:M94) firstrow clear
save FAT4_4.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("FAT4.7") cellrange(A1:M118) firstrow clear
save FAT4_7.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("BLS") cellrange(A1:B71) firstrow clear
save BLS_LS.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("NSF") cellrange(A1:B55) firstrow clear
save NSF_chi.dta, replace


// MERGE ALL VARIABLES BY YEAR
use NIPA1_14.dta, clear
merge 1:1 year using FAT4_1.dta, nogen
merge 1:1 year using FAT4_4.dta, nogen
merge 1:1 year using FAT4_7.dta, nogen
merge 1:1 year using BLS_LS.dta, nogen
merge 1:1 year using NSF_chi.dta, nogen

drop if year<1947 | year>2017


*-------------------------------------------------------------------------------
* NON-FINANCIAL & FINANCIAL CORPORATE
*-------------------------------------------------------------------------------
// AGGREGATE INVESTMENT IN CORPORATE SECTOR
egen I_ESI 			= rsum(IC_EQ	IC_ST	IC_IPP)
egen I_ES 			= rsum(IC_EQ	IC_ST)
egen I_S 			= rsum(IC_ST)
egen I_E 			= rsum(IC_EQ)
egen I_I 			= rsum(IC_IPP)

// DEPRECIATION IN CORPORATE SECTOR
egen DEP_tot 		= rsum(DEP_C_EQ		DEP_C_ST 		DEP_C_IPP)
gen DEP_nIPP 		= DEP_tot - DEP_C_IPP
gen DEP_IPP 		= DEP_C_IPP

// GVA AND CE
gen GVA 			= GVA_C
gen CE 				= CE_C
*/


*-------------------------------------------------------------------------------
* NON-FINANCIAL CORPORATE
*-------------------------------------------------------------------------------
/*
// AGGREGATE INVESTMENT IN CORPORATE SECTOR
egen I_ESI 			= rsum(ICNF_EQ	ICNF_ST	ICNF_IPP)
egen I_ES 			= rsum(ICNF_EQ	ICNF_ST)
egen I_S 			= rsum(ICNF_ST)
egen I_E 			= rsum(ICNF_EQ)
egen I_I 			= rsum(ICNF_IPP)

// DEPRECIATION IN CORPORATE SECTOR
egen DEP_tot 		= rsum(DEP_CNF_EQ		DEP_CNF_ST 		DEP_CNF_IPP)
gen DEP_nIPP 		= DEP_tot - DEP_CNF_IPP
gen DEP_IPP 		= DEP_CNF_IPP

// GVA AND CE
gen GVA 			= GVA_NF
gen CE 				= CE_NF
*/


// INVESTMENT SHARES IN CORPORATE SECTOR
gen sI_EQ 			= I_E/I_ESI
gen sI_ST 			= I_S/I_ESI
gen sI_IPP 			= I_I/I_ESI
gen sY_EQ 			= I_E/GVA
gen sY_ST 			= I_S/GVA
gen sY_IPP 			= I_I/GVA


// CHI MEASURES
gen x_NSF 			= NSF_chi
replace x_NSF 		= NSF_chi[16] in 1/15
egen x_NSF_mean 	= mean(x_NSF)
gen x_AI 			= (GVA - CE - I_I) / (GVA - I_I)
gen x_MP 			= 0.5


// COMPUTE LABOR SHARE WITH IPP, USING POST-REVISION 2014 NATIONAL INCOME DATA
// OUR DEFINITION OF LABOR SHARE IS IDENTICAL TO THE ONE BY KARABARBOUNIS & NEIMAN (2013).
// LS = COMPENSATION OF EMPLOYEES / GROSS VALUE ADDED
gen LS_ESI 			= CE / GVA
gen LS_ES 			= CE / (GVA - I_I)
gen LS_I 			= CE / (GVA - I_ES)
gen LS_ 			= CE / (GVA - I_ESI)
gen LS_AI 			= CE / GVA + (1-x_AI)*I_I / GVA
gen LS_MP 			= CE / GVA + (1-x_MP)*I_I / GVA
gen LS_NSF 			= CE / GVA + (1-x_NSF)*I_I / GVA
gen LS_NSF_mean 	= CE / GVA + (1-x_NSF_mean)*I_I / GVA
gen LS_1 			= CE / GVA
gen LS_0 			= CE / GVA + I_I / GVA



*-------------------------------------------------------------------------------  
*-------------------------------------------------------------------------------  
****************************************************
* PLOT FIGURE: CORPORATE SECTOR LABOR SHARE
****************************************************

gen ttrend = _n

reg LS_ESI ttrend
di _b[ttrend]*71
predict xbls_esi 	if LS_ESI!=.
reg LS_ES ttrend
di _b[ttrend]*71
predict xbls_es 	if LS_ES!=.
reg LS_I ttrend
predict xbls_I 		if LS_I!=.
reg LS_ ttrend
predict xbls 		if LS_!=.
reg LS_AI ttrend
predict XBLS_AI 	if LS_AI!=.
reg LS_MP ttrend
predict XBLS_MP 	if LS_MP!=.
reg LS_NSF ttrend
predict XBLS_NSF 	if LS_NSF!=.
reg LS_NSF_mean ttrend
predict XBLS_NSF_mean if LS_NSF_mean!=.
reg LS_0 ttrend
predict XBLS_0 		if LS_0!=.
reg LS_1 ttrend
predict XBLS_1 		if LS_1!=.


// FIGURE 6(b)
twoway (line LS_1 year, 				lcolor(blue)) || ///
	   (line LS_NSF year, 				lcolor(red)) || ///
	   (line LS_0 year, 				lcolor(green)) || ///
	   (line LS_NSF_mean year, 			lcolor(yellow)) || ///
	   (line LS_MP year, 				lcolor(gray)) || ///
	   (line LS_AI year, 				lcolor(magenta)) || ///
	   (line XBLS_1 year, 				lcolor(blue) lpattern(dash)) || ///
	   (line XBLS_NSF year, 			lcolor(red) lpattern(dash)) || ///
	   (line XBLS_0 year, 				lcolor(green) lpattern(dash)) || ///
	   (line XBLS_NSF_mean year, 		lcolor(yellow) lpattern(dash)) || ///
	   (line XBLS_MP year, 				lcolor(gray) lpattern(dash)) || ///
	   (line XBLS_AI year, 				lcolor(magenta) lpattern(dash)), ///
	   scheme(s1color) ytitle("Corporate Labor Share") ylabel(.56(.04).72, labsize(medium)) xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(2) size(medium) ///
	   order(1 "{&chi}=1, BEA LS"  2 "{&chi}= NSF R&D Cost Structure" 3 "{&chi}=0" 4 "{&chi}=0.41, NSF R&D Cost Average" 5 "{&chi}=MP (2010)" 6 "{&chi}=Ambiguous Income Treatment" ))
graph export "LS_C_x.png", width(1400) height(1000) replace


// FIGURE 7(a)
twoway (line LS_ESI  			year, lcolor(blue)) ///
	   (line xbls_esi			year if year>=1947 & year<=2017, lcolor(blue) lpattern(dash)) ///
	   (line LS_ES 				year, lcolor(orange)) ///
	   (line xbls_es			year if year>=1947 & year<=2017, lcolor(orange) lpattern(dash)), ///
		scheme(s1color) ytitle("Corporate Labor Share") xtitle("") ylabel(,labsize(medsmall)) ///
		xlabel(1947(3)2017, labsize(medsmall) angle(90)) ///
		legend(region(lwidth(none) fcolor(none))  size(medsmall) col(1) pos(8) ring(0) order(1 "BEA LS, Corporate Sector" 3 "Expensing IPP Investment"))
graph export "LS_C_ES.png", width(1400) height(1000) replace


// FIGURE 7(b)
twoway (line LS_I 		year, lcolor(green)) ///
	   (line xbls_I			year if year>=1947 & year<=2017, lcolor(green) lpattern(dash)) ///
	   (line LS_ 			year, lcolor(pink)) ///
	   (line xbls			year if year>=1947 & year<=2017, lcolor(pink) lpattern(dash)), ///
		scheme(s1color) ytitle("Corporate Labor Share") xtitle("") ylabel(,labsize(medsmall)) ///
		xlabel(1947(3)2017, labsize(medsmall) angle(90)) ///
		legend(region(lwidth(none) fcolor(none))  size(medsmall) col(1) pos(8) ring(0) order(1 "Expensing Tangible Investment" 3 "Expensing Tangible and IPP Investment"))
graph export "LS_C_I.png", width(1400) height(1000) replace
