/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES OF THE INTERNATIONAL EVIDENCE FOR FRANCE
IN "LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.
CREATED BY DONGYA KOH, 3/14/2020
***************************************************************/
clear
clear matrix
set more off,permanently


// SET A PATH TO A FOLDER WHERE DATA FILE IS STORED
cd "C:\Users\Don Koh\Dropbox\My_Documents\IPP\Data\IPP_USLS_Data_Codes\International\FRA"


*-------------------------------------------------------------------------------  
*------------------------------------------------------------------------------- 

* IMPORT MAIN DATA
import excel "FRA_NA.xlsx", sheet("FRA_NA") cellrange(A1:O71) firstrow clear

drop if year<1949 | year>2018


*------------------------------------------------------------------------------- 
* 	DATA CONSTRUCTION AND IMPUTATIONS 
*------------------------------------------------------------------------------- 
// CONSTRUCTION OF VARIABLES
gen NOS 		= NOS_NF + NOS_F + NOS_HH + NOS_Gov + NOS_NPISH
ren GFCF_IPP 	I_IPP
ren Subsidy		Sub
gen Tax_Sub 	= Tax + Sub


// RATIOS
gen ratio_NOS_GOS 	= NOS/GOS
gen ratio_NMI_GMI 	= NMI/GMI
gen ratio_GOS_GDP 	= GOS/GVA
gen ratio_NOS_GDP 	= NOS/GVA
gen ratio_GMI_GDP 	= GMI/GVA
gen ratio_NMI_GDP 	= NMI/GVA


// LINEARLY EXTRAPOLATE NMI/GMI RATIO AND IMPUTET THE LEVELS
sort year
reg ratio_NOS_GOS year
predict XB_ratio_NOS_GOS
gen impNOS				= XB_ratio_NOS_GOS*GOS
replace NOS 			= impNOS if missing(NOS)
gen ratio_impNOS_GDP	= impNOS/GVA

reg ratio_NMI_GMI year
predict XB_ratio_NMI_GMI
gen impNMI				= XB_ratio_NMI_GMI*GMI
replace NMI 			= impNMI if missing(NMI)
gen ratio_impNMI_GDP	= impNMI/GVA


twoway  (line   XB_ratio_NOS_GOS  year, lcolor(gray)    lwidth(thick) lpattern(dash)) || ///
		(line	ratio_NOS_GOS  year, lcolor(black)   lwidth(vthick))  || ///
		(line   XB_ratio_NMI_GMI  year, lcolor(midblue) lwidth(medvthick) lpattern(dash))  || ///
		(line   ratio_NMI_GMI  year, lcolor(blue)    lwidth(vthick)), ///
	   scheme(s1color) ylabel(0(.1)1, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(2) size(medium) order(2 "NOS to GOS" 4 "NMI  to GMI"))
graph export "GrossTONet_FRA.png", width(1400) height(1000) replace


twoway  (line	ratio_GOS_GDP  		year, lcolor(black)  lwidth(vthick)) || ///
		(line   ratio_impNOS_GDP  	year if year<1979, lcolor(gray)   lwidth(vthick) lpattern(dash)) || ///
		(line   ratio_NOS_GDP  		year, lcolor(gray)   lwidth(vthick)), ///
	   scheme(s1color) ylabel(0(.1).4, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(2) size(medium) order(1 "GOS" 2 "NOS"))
graph export "GOSandNOS_FRA.png", width(1400) height(1000) replace
	   

twoway  (line	ratio_GMI_GDP  		year, lcolor(blue)  lwidth(vthick)) || ///
		(line	ratio_impNMI_GDP  	year if year<1979, lcolor(midblue)   lwidth(vthick) lpattern(dash)) || ///
		(line   ratio_NMI_GDP  		year, lcolor(midblue)   lwidth(vthick)), ///  
	   scheme(s1color) ylabel(0(.1).4, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(2) size(medium) order(1 "GMI" 2 "NMI"))
graph export "GMIandNMI_FRA.png", width(1400) height(1000) replace
	    
		
// IMPUTE IPP INVESTMENT
gen ratio_IPP_GFCF 		= I_IPP/GFCF 
gen ratio_impIPP_GFCF 	= ratio_IPP_GFCF
replace ratio_impIPP_GFCF	= .01  if year==1949
regress ratio_impIPP_GFCF year if year <1979
predict XB_ratio_IPP_GFCF
replace I_IPP 			= XB_ratio_IPP_GFCF*GFCF if missing(I_IPP)

twoway  (line	ratio_IPP_GFCF year, lcolor(blue) lwidth(vthick)) || ///
		(line   XB_ratio_IPP_GFCF  year if year <1979, lcolor(blue) lpattern(dash) lwidth(vthick)), ///
	   scheme(s1color) ylabel(0(.1).3, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) ring(0) col(2) size(medium) order(1 "IPP to GFCF Ratio" 2 "Imputed IPP to GFCF Ratio"))
graph export "rGFCF_IPP_GFCF_FRA.png", width(1400) height(1000) replace


*------------------------------------------------------------------------------- 
* 	INCOME COMPOSITIONS
*------------------------------------------------------------------------------- 
gen ratio_CE_GDP 	= CE/GVA
gen ratio_TS_GDP 	= Tax_Sub/GVA

twoway  (line 	ratio_CE_GDP  	year, lwidth(vthick)) || ///
		(line   ratio_GOS_GDP  	year, lwidth(vthick)) || ///
	    (line   ratio_GMI_GDP  	year, lwidth(vthick)) || ///
		(line   ratio_TS_GDP  	year, lwidth(vthick)), ///
	   scheme(s1color) ylabel(0(.1)1, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) ring(0) row(1) size(medium) order(1 "CE" 2 "GOS" 3 "GMI" 4 "TS"))
graph export "NIcomp_GDP_FRA.png", width(1400) height(1000) replace




*------------------------------------------------------------------------------- 
* 	AGGREGATE LABOR SHARE AND IPP EFFECTS
*------------------------------------------------------------------------------- 
gen LS0 	= CE/GVA
gen LS1 	= CE/(GVA - Tax_Sub)
gen LS2 	= CE/(GVA - Tax_Sub - NMI)
gen LS0IPP 	= CE/(GVA - I_IPP)
gen LS1IPP 	= CE/(GVA - Tax_Sub - I_IPP)
gen LS2IPP 	= CE/(GVA - Tax_Sub - NMI - I_IPP)


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



twoway (line LS0 		year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS0 		year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS0IPP 	year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS0IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.4(0.05)0.80, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/Y" 3 "Counterfactual"))
graph export "FRA_LS0.png", width(1400) height(1000) replace


twoway (line LS1 		year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS1 		year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS1IPP 	year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS1IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.4(0.05)0.80, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "LS=CE/(Y-Tax_Sub)" 3 "Counterfactual"))
graph export "FRA_LS1.png", width(1400) height(1000) replace


twoway (line LS2 		year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS2 		year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS2IPP 	year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS2IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.62(0.02)0.74, labsize(medium)) xtitle("") xlabel(1949(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(2) size(medium) ///
	   order(1 "SNA08" 3 "Pre-SNA93"))
graph export "FRA_LS2.png", width(1400) height(1000) replace


