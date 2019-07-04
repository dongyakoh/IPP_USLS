/***************************************************************
THIS PROGRAM GENERATES CORPORATE SECTOR LABOR SHARE IN THE APPENDIX OF
"LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.

CREATED BY DONGYA KOH, 6/30/2018
***************************************************************/
	
clear
clear matrix
set more off,permanently

cd ""				// FOLDER WHERE GRAPHS ARE STORED


// IMPORT DATA FROM NIPA AND FAT TABLES
import excel "IPP_USLS_CORP_DATA.xlsx", sheet("NIPA1.14") cellrange(A1:AF71) firstrow clear
save NIPA1_14.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("FAT4.1") cellrange(A1:M71) firstrow clear
save FAT4_1.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("FAT4.4") cellrange(A1:M71) firstrow clear
save FAT4_4.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("FAT4.7") cellrange(A1:M71) firstrow clear
save FAT4_7.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("FAT4.7") cellrange(A1:M71) firstrow clear
save FAT4_7.dta, replace

import excel "IPP_USLS_CORP_DATA.xlsx", sheet("BLS") cellrange(A1:B71) firstrow clear
save BLS_LS.dta, replace


// MERGE ALL VARIABLES BY YEAR
use NIPA1_14.dta, clear
merge 1:1 year using FAT4_1.dta, nogen
merge 1:1 year using FAT4_4.dta, nogen
merge 1:1 year using FAT4_7.dta, nogen
merge 1:1 year using BLS_LS.dta, nogen


*-------------------------------------------------------------------------------  
*-------------------------------------------------------------------------------  

// AGGREGATE INVESTMENT IN CORPORATE SECTOR
egen IC_ESI 		= rsum(IC_EQ	IC_ST	IC_IPP)
egen IC_ES 			= rsum(IC_EQ	IC_ST)
egen IC_S 			= rsum(IC_ST)
egen IC_E 			= rsum(IC_EQ)
egen IC_I 			= rsum(IC_IPP)

egen ICF_ESI 		= rsum(ICF_EQ	ICF_ST	ICF_IPP)
egen ICF_ES 		= rsum(ICF_EQ	ICF_ST)

egen ICNF_ESI 		= rsum(ICNF_EQ	ICNF_ST	ICNF_IPP)
egen ICNF_ES 		= rsum(ICNF_EQ	ICNF_ST)


// DEPRECIATION IN CORPORATE SECTOR
egen DEP_tot 		= rsum(DEP_C_EQ		DEP_C_ST 	DEP_C_IPP)
gen DEP_nIPP 		= DEP_tot - DEP_C_IPP
gen DEP_IPP 		= DEP_C_IPP


// INVESTMENT SHARES IN CORPORATE SECTOR
gen s_IPP_ESI = IC_IPP/IC_ESI
line s_IPP_ESI year

gen share_IPP = IC_IPP/GVA_C

gen sI_EQ 		= IC_E/IC_ESI
gen sI_ST 		= IC_S/IC_ESI
gen sI_IPP 		= IC_I/IC_ESI
gen sY_EQ 		= IC_E/GVA_C
gen sY_ST 		= IC_S/GVA_C
gen sY_IPP 		= IC_I/GVA_C


// COMPUTE LABOR SHARE WITH IPP, USING POST-REVISION 2014 NATIONAL INCOME DATA
// OUR DEFINITION OF LABOR SHARE IS IDENTICAL TO THE ONE BY KARABARBOUNIS & NEIMAN (2013).
// LS = COMPENSATION OF EMPLOYEES / GROSS VALUE ADDED
gen LS_C_ESI 		= CE_C / GVA_C
gen LS_C_ES 		= 1 - (GVA_C - CE_C - IC_I)/(GVA_C - IC_I)




*-------------------------------------------------------------------------------  
*-------------------------------------------------------------------------------  
* PLOT GRAPHS

****************************************************
* PLOT FIGURE IN APPENDIX: CORPORATE SECTOR LABOR SHARE
****************************************************
drop if year<1947
local inity1 = 1947
local endy 	= 2016

gen ttrend = _n

reg LS_C_ESI ttrend   if year<=`endy' & year>=`inity1'
predict xbls_3		if year<=`endy' & year>=`inity1'
reg LS_C_ES ttrend   	if year<=`endy' & year>=`inity1'
predict xbls_2		if year<=`endy' & year>=`inity1'


****************************************************
* CORPORATE LS WITH BLS LS
****************************************************	   
gen BLS_LS_norm 		= BLS_LS  - (BLS_LS[63] -  LS_C_ESI[63])
twoway (line LS_C_ESI 	year, lcolor(blue)) ///
	   (line xbls_3		year if year>=`inity1' & year<=`endy', lcolor(blue) lpattern(dash)) ///
	   (line LS_C_ES 	year, lcolor(orange)) ///
	   (line xbls_2		year if year>=`inity1' & year<=`endy', lcolor(orange) lpattern(dash)) ///
	   (line BLS_LS_norm 	year, lcolor(lime)), ///
		scheme(s1color) ytitle("Corporate Labor Share") xtitle("") ylabel(.55(.03).7,labsize(medsmall)) ///
		xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
		legend(size(medsmall) col(1) pos(8) ring(0) order(1 "BEA LS, Corporate Sector" 3 "Pre-1999 Revision Accounting LS, Corporate Sector" 5 "Asset Basis BLS LS, Economy-Wide"))
graph export "LS_C_BLS.png", width(1400) height(1000) replace


****************************************************
* INVESTMENT LEVEL
****************************************************	   
twoway (line IC_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line IC_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line IC_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Billions of USD, Nominal") ylabel(,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(11) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "inv_type_C.png", width(1400) height(1000) replace


****************************************************
* INVESTMENT SHARE
****************************************************	   
twoway (line sI_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line sI_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line sI_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Share of Aggregate Investment") ylabel(0(0.1)0.6,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(6) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invshares_type_C.png", width(1400) height(1000) replace


****************************************************
* INVESTMENT SHARE OF GNP
****************************************************	   
twoway (line sY_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line sY_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line sY_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Share of Gross Value Added") ylabel(0(0.03)0.12,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(6) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invsharesY_type_C.png", width(1400) height(1000) replace


