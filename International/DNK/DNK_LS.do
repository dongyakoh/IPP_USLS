/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES OF THE INTERNATIONAL EVIDENCE FOR DENMARK
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
import excel "DNK_NA.xlsx", sheet("DNK_NA") cellrange(A1:N54) firstrow clear


*------------------------------------------------------------------------------- 
* DATA CONSTRUCTION AND IMPUTATIONS 
*------------------------------------------------------------------------------- 
ren GFCF_IPP I_IPP


// GOS TO (GOS+GMI) RATIO
gen ratio_GOS_GOSGMI 	= GOS/(GOS+GMI)
regress   ratio_GOS_GOSGMI year if year>=2001
predict XB_ratio_GOS_GOSGMI

// IMPUTE GOS
gen impGOS				= XB_ratio_GOS_GOSGMI*GOS_MI
gen ratio_impGOS_GDP	= impGOS/GDP
replace GOS 			= impGOS if year<1995		
gen ratio_GOS_GDP   	= GOS/GDP

// IMPUTE GMI
gen impGMI	     		= GOS_MI-impGOS
gen ratio_impGMI_GDP    = impGMI/GDP
replace GMI 			= impGMI if year<1995
gen ratio_GMI_GDP     	= GMI/GDP


twoway (line XB_ratio_GOS_GOSGMI 	year, 				lcolor(gray) lpattern(dash)   lwidth(vthick)) || ///
	   (line ratio_GOS_GOSGMI 		year, 				lcolor(black)    lwidth(vthick)), ///
	   scheme(s1color) ytitle("") ylabel(0(.1)1, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) row(1) size(medium) order(2 "GOS to GOS+GMI" 1 "Imputed GOS to GOS+GMI"))
graph export "rGOS_GMI_DNK.png", width(1400) height(1000) replace


twoway  (line GMI  		year if year>=2001, lcolor(blue)   lwidth(vthick)) || ///
		(line impGMI  	year if year<=2001, lcolor(ltblue) lwidth(vthick) lpattern(dash)), ///
	   scheme(s1color) ytitle("") ylabel(, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) row(1) size(medium) order(1 "GMI" 2 "Imputed GMI"))
graph export "impGMI_DNK.png", width(1400) height(1000) replace


twoway  (line GOS  		year if year>=2001, lcolor(blue)   lwidth(vthick)) || ///
		(line impGOS  	year if year<=2001, lcolor(ltblue) lwidth(vthick) lpattern(dash)), ///
	   scheme(s1color) ytitle("") ylabel(, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) ring(0) row(1) size(medium) order(1 "GOS" 2 "Imputed GOS"))
graph export "impGOS_DNK.png", width(1400) height(1000) replace

		

// IMPUTE NOS
gen ratio_NOS_GOS 	= NOS/GOS
regress ratio_NOS_GOS year
predict XB_ratio_NOS_GOS
gen impNOS 			= XB_ratio_NOS_GOS*GOS
gen ratio_NOS_GDP		= NOS/GDP
gen ratio_impNOS_GDP 	= impNOS/GDP
replace NOS				= impNOS if year<1995


// IMPUTE NMI
gen ratio_NMI_GMI 	= NMI/GMI
regress ratio_NMI_GMI year
predict XB_ratio_NMI_GMI
gen impNMI 			= XB_ratio_NMI_GMI*GMI
gen ratio_impNMI_GDP 	= impNMI/GDP
gen ratio_NMI_GDP 		= NMI/GDP
replace NMI 		= impNMI if year<1995


twoway  (line XB_ratio_NOS_GOS  	year, lcolor(gray)    lwidth(vthick) lpattern(dash)) || ///
		(line ratio_NOS_GOS  		year, lcolor(black)   lwidth(vthick))  || ///
		(line XB_ratio_NMI_GMI  	year, lcolor(midblue) lwidth(vthick) lpattern(dash))  || ///
		(line ratio_NMI_GMI  		year, lcolor(blue)    lwidth(vthick)), ///
	   scheme(s1color) ytitle("") ylabel(0(0.1)1, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) row(1) size(medium) order(2 "NOS to GOS" 4 "NMI  to GMI"))
graph export "GrossTONet_DNK.png", width(1400) height(1000) replace


twoway  (line ratio_GOS_GDP  		year, lcolor(black)  lwidth(vthick)) || ///
		(line ratio_impNOS_GDP  	year if year<=2001, lcolor(gray)   lwidth(vthick) lpattern(dash)) || ///
		(line ratio_NOS_GDP  		year if year>=2001, lcolor(gray)   lwidth(vthick)), ///
		scheme(s1color) ytitle("") ylabel(0(0.1)0.4, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	    legend(region(lwidth(none) fcolor(none)) pos(12) ring(0) row(1) size(medium) order(1 "GOS to GDP" 2 "NOS to GDP"))
graph export "GOSandNOS_DNK.png", width(1400) height(1000) replace
		 

twoway  (line ratio_GMI_GDP  		year, lcolor(blue)  lwidth(vthick)) || ///
		(line ratio_impNMI_GDP  	year if year<=2001, lcolor(midblue)   lwidth(vthick) lpattern(dash)) || ///
		(line ratio_NMI_GDP  		year if year>=2001, lcolor(midblue)   lwidth(vthick)), ///
		scheme(s1color) ytitle("") ylabel(0(0.1)0.4, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	    legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) row(1) size(medium) order(1 "GMI to GDP" 2 "NMI to GDP"))
graph export "GMIandNMI_DNK.png", width(1400) height(1000) replace



*------------------------------------------------------------------------------- 
* IPP SHARE OF GFCF
*------------------------------------------------------------------------------- 
gen ratio_IPP_GFCF 	= I_IPP/GFCF
twoway  (line ratio_IPP_GFCF 	year, lcolor(blue) lwidth(vthick)), ///
		scheme(s1color) ytitle("") ylabel(0(0.05)0.3, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) legend(off)
graph export "rGFCF_IPP_GFCF_DNK.png", width(1400) height(1000) replace



*------------------------------------------------------------------------------- 
* INCOME COMPOSITION OF GDP
*------------------------------------------------------------------------------- 
gen ratio_CE_GDP 	= CE/GDP
gen Tax_Sub_Product = GDP - GVA 		// TAXES LESS SUBSIDIES ON PRODUCTS
gen ratio_TS_GDP 	= (Tax_Sub_Product + Tax_Sub)/GDP 	// ADD OTHER TAXES LESS SUBSIDIES

twoway  (line ratio_CE_GDP  	year, lwidth(vthick)) || ///
		(line ratio_GOS_GDP  	year, lwidth(vthick)) || ///
	    (line ratio_GMI_GDP  	year, lwidth(vthick)) || ///
		(line ratio_TS_GDP  	year, lwidth(vthick)), /// 
		scheme(s1color) ytitle("") ylabel(0(0.1)1, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	    legend(region(lwidth(none) fcolor(none)) pos(12) ring(0) row(1) size(medium) order(1 "CE" 2 "GOS" 3 "GMI" 4 "TS"))
graph export "NIcomp_GDP_DNK.png", width(1400) height(1000) replace



*------------------------------------------------------------------------------- 
* AGGREGATE LABOR SHARE AND IPP EFFECTS
*------------------------------------------------------------------------------- 
gen LS0 	= CE/GVA
gen LS1 	= CE/(GVA - Tax_Sub)
gen LS2 	= CE/(GVA - Tax_Sub - NMI)
gen LS3 	= CE/(GVA - NMI)
gen LS0IPP 	= CE/(GVA - I_IPP)
gen LS1IPP 	= CE/(GVA - Tax_Sub - I_IPP)
gen LS2IPP 	= CE/(GVA - Tax_Sub - NMI - I_IPP)
gen LS3IPP 	= CE/(GVA - NMI - I_IPP)


reg LS0 year
predict XBLS0, xb
reg LS0IPP year
predict XBLS0IPP, xb
reg LS1 year
predict XBLS1, xb
reg LS1IPP year
predict XBLS1IPP, xb
reg LS2 year
predict XBLS2
reg LS2IPP year
predict XBLS2IPP
reg LS3 year
predict XBLS3
reg LS3IPP year
predict XBLS3IPP


gen tt = _n
gen ln_LS2 = ln(LS2)
reg ln_LS2 tt
gen ln_LS2IPP = ln(LS2IPP)
reg ln_LS2IPP tt

// PLOT FIGURES
twoway (line LS0 		year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS0 		year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS0IPP 	year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS0IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.5(0.05)0.7, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "SNA08" 3 "Pre-SNA93"))
graph export "DNK_LS0.png", width(1400) height(1000) replace


twoway (line LS1 		year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS1 		year, 				lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS1IPP 	year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS1IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(medvthick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.5(0.05)0.7, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) ///
	   order(1 "SNA08" 3 "Pre-SNA93"))
graph export "DNK_LS1.png", width(1400) height(1000) replace


twoway (line LS2 		year, 				lcolor(blue) lwidth(vvthick)) || ///
	   (line XBLS2 		year, 				lcolor(blue) lpattern(dash) lwidth(vthick)) || ///
	   (line LS2IPP 	year, 				lcolor(orange) lwidth(vvthick)) || ///
	   (line XBLS2IPP 	year, 				lcolor(orange) lpattern(dash) lwidth(vthick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.6(0.02)0.7, labsize(medium)) xtitle("") xlabel(1966(2)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(2) size(medium) ///
	   order(1 "SNA08" 3 "Pre-SNA93"))
graph export "DNK_LS2.png", width(1400) height(1000) replace

