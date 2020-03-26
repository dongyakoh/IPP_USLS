/***************************************************************
THIS PROGRAM GENERATES SECTOR LABOR SHARES IN 
"LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.

CREATED BY DONGYA KOH, 3/14/2020
***************************************************************/
	
clear
clear matrix
set more off,permanently


// SET A PATH TO A FOLDER WHERE DATA FILE IS STORED
cd ""


// IMPORT SECTOR LEVEL NA DATA (ONLY AVAILABLE FROM 1948 IN BEA)
import excel "IPP_USLS_DATA.xlsx", sheet("NA_Sector") cellrange(A4:AW94) firstrow clear
drop if year<1929 | year>2018

gen tt = _n

*-------------------------------------------------------------------------------  
*-------------------------------------------------------------------------------  
gen GVA_B 			= GVA_C + GVA_NC
gen CE_B 			= CE_C + CE_NC
gen Tax_B 			= Tax_C + Tax_NC
gen PI_B 			= PI_C + PI_NC
gen IPP_B 			= IPP_C + IPP_NC
gen I_B 			= I_C + I_NC

gen GVA_HHNP 		= GVA_HH + GVA_NP
gen CE_HHNP 		= CE_HH + CE_NP
gen Tax_HHNP 		= Tax_HH + Tax_NP
gen PI_HHNP 		= PI_HH + PI_NP
gen IPP_HHNP 		= IPP_HH + IPP_NP
gen I_HHNP 			= I_HH + I_NP



// GVA SHARE
gen sGVA0_C 		= GVA_C/GVA_AGG		// CORPORATE BUSINESS = NONFINANCIAL + FINANCIAL
gen sGVA0_NF 		= GVA_NF/GVA_AGG	// NONFINANCIAL
gen sGVA0_F 		= GVA_F/GVA_AGG		// FINANCIAL
gen sGVA0_NC 		= GVA_NC/GVA_AGG	// NONCORPORATE BUSINESS
gen sGVA0_HH 		= GVA_HH/GVA_AGG	// HOUSEHOLD AND NP
gen sGVA0_NP 		= GVA_NP/GVA_AGG	// HOUSEHOLD AND NP
gen sGVA0_HHNP 		= GVA_HHNP/GVA_AGG	// HOUSEHOLD AND NP
gen sGVA0_Gov 		= GVA_Gov/GVA_AGG	// GENERAL GOVERNMENT
gen sGVA0_B 		= GVA_B/GVA_AGG		// PRIVATE BUSINESS

gen sGVA1_C 	= (GVA_C - Tax_C)/(GVA_AGG - Tax_AGG)		// CORPORATE BUSINESS = NONFINANCIAL + FINANCIAL
gen sGVA1_NF 	= (GVA_NF - Tax_NF)/(GVA_AGG - Tax_AGG)		// NONFINANCIAL
gen sGVA1_F 	= (GVA_F - Tax_F)/(GVA_AGG - Tax_AGG)		// FINANCIAL
gen sGVA1_NC 	= (GVA_NC - Tax_NC)/(GVA_AGG - Tax_AGG)		// NONCORPORATE BUSINESS
gen sGVA1_HH 	= (GVA_HH - Tax_HH)/(GVA_AGG - Tax_AGG)		// HOUSEHOLD AND NP
gen sGVA1_NP 	= (GVA_NP - Tax_NP)/(GVA_AGG - Tax_AGG)		// HOUSEHOLD AND NP
gen sGVA1_HHNP 	= (GVA_HHNP - Tax_HHNP)/(GVA_AGG - Tax_AGG)		// HOUSEHOLD AND NP
gen sGVA1_Gov 	= (GVA_Gov - Tax_Gov)/(GVA_AGG - Tax_AGG)	// GENERAL GOVERNMENT
gen sGVA1_B 	= (GVA_B - Tax_B)/(GVA_AGG - Tax_AGG)		// PRIVATE BUSINESS

gen sGVA2_C 	= (GVA_C - Tax_C - PI_C)/(GVA_AGG - Tax_AGG - PI_AGG)		// CORPORATE BUSINESS = NONFINANCIAL + FINANCIAL
gen sGVA2_NF 	= (GVA_NF - Tax_NF - PI_NF)/(GVA_AGG - Tax_AGG - PI_AGG)	// NONFINANCIAL
gen sGVA2_F 	= (GVA_F - Tax_F - PI_F)/(GVA_AGG - Tax_AGG - PI_AGG)		// FINANCIAL
gen sGVA2_NC 	= (GVA_NC - Tax_NC - PI_NC)/(GVA_AGG - Tax_AGG - PI_AGG)	// NONCORPORATE BUSINESS
gen sGVA2_HH 	= (GVA_HH - Tax_HH - PI_HH)/(GVA_AGG - Tax_AGG - PI_AGG)	// HOUSEHOLD AND NP
gen sGVA2_NP 	= (GVA_NP - Tax_NP - PI_NP)/(GVA_AGG - Tax_AGG - PI_AGG)	// HOUSEHOLD AND NP
gen sGVA2_HHNP 	= (GVA_HHNP - Tax_HHNP - PI_HHNP)/(GVA_AGG - Tax_AGG - PI_AGG)	// HOUSEHOLD AND NP
gen sGVA2_Gov 	= (GVA_Gov - Tax_Gov - PI_Gov)/(GVA_AGG - Tax_AGG - PI_AGG)	// GENERAL GOVERNMENT
gen sGVA2_B 	= (GVA_B - Tax_B - PI_B)/(GVA_AGG - Tax_AGG - PI_AGG)		// PRIVATE BUSINESS


// IPP SHARE
gen sIPP_C 		= IPP_C/IPP_AGG
gen sIPP_NF		= IPP_NF/IPP_AGG
gen sIPP_F 		= IPP_F/IPP_AGG
gen sIPP_NC 	= IPP_NC/IPP_AGG
gen sIPP_HH 	= IPP_HH/IPP_AGG
gen sIPP_NP 	= IPP_NP/IPP_AGG
gen sIPP_HHNP 	= IPP_HHNP/IPP_AGG
gen sIPP_Gov	= IPP_Gov/IPP_AGG
gen sIPP_B		= IPP_B/IPP_AGG


// IPP-GVA RATIO
gen IPP_GVA0_C 		= IPP_C/GVA_AGG
gen IPP_GVA0_NF		= IPP_NF/GVA_AGG
gen IPP_GVA0_F 		= IPP_F/GVA_AGG
gen IPP_GVA0_NC 	= IPP_NC/GVA_AGG
gen IPP_GVA0_HH 	= IPP_HH/GVA_AGG
gen IPP_GVA0_NP 	= IPP_NP/GVA_AGG
gen IPP_GVA0_HHNP 	= IPP_HHNP/GVA_AGG
gen IPP_GVA0_Gov	= IPP_Gov/GVA_AGG
gen IPP_GVA0_B		= IPP_B/GVA_AGG


gen IPP_GVA1_C 		= IPP_C/(GVA_C - Tax_C)
gen IPP_GVA1_NF		= IPP_NF/(GVA_C - Tax_C)
gen IPP_GVA1_F 		= IPP_F/(GVA_C - Tax_C)
gen IPP_GVA1_NC 	= IPP_NC/(GVA_AGG - Tax_AGG)
gen IPP_GVA1_HH 	= IPP_HH/(GVA_AGG - Tax_AGG)
gen IPP_GVA1_NP 	= IPP_NP/(GVA_AGG - Tax_AGG)
gen IPP_GVA1_HHNP 	= IPP_HHNP/(GVA_AGG - Tax_AGG)
gen IPP_GVA1_Gov	= IPP_Gov/(GVA_AGG - Tax_AGG)
gen IPP_GVA1_B		= IPP_B/(GVA_AGG - Tax_AGG)


gen IPP_GVA2_C 		= IPP_C/(GVA_C - Tax_C - PI_C)
gen IPP_GVA2_NF		= IPP_NF/(GVA_C - Tax_C - PI_C)
gen IPP_GVA2_F 		= IPP_F/(GVA_C - Tax_C - PI_C)
gen IPP_GVA2_NC 	= IPP_NC/(GVA_AGG - Tax_AGG - PI_AGG)
gen IPP_GVA2_HH 	= IPP_HH/(GVA_AGG - Tax_AGG - PI_AGG)
gen IPP_GVA2_NP 	= IPP_NP/(GVA_AGG - Tax_AGG - PI_AGG)
gen IPP_GVA2_HHNP 	= IPP_HHNP/(GVA_AGG - Tax_AGG - PI_AGG)
gen IPP_GVA2_Gov	= IPP_Gov/(GVA_AGG - Tax_AGG - PI_AGG)
gen IPP_GVA2_B 		= IPP_B/(GVA_AGG - Tax_AGG - PI_AGG)


// LS and COUNTERFACTUAL LS
gen LS0_AGG		= CE_AGG/GVA_AGG
gen LS0_C		= CE_C/GVA_C
gen LS0_NF		= CE_NF/GVA_NF
gen LS0_F		= CE_F/GVA_F
gen LS0_NC		= CE_NC/GVA_NC
gen LS0_HH		= CE_HH/GVA_HH
gen LS0_NP		= CE_NP/GVA_NP
gen LS0_HHNP	= CE_HHNP/GVA_HHNP
gen LS0_Gov		= CE_Gov/GVA_Gov
gen LS0_B		= CE_B/GVA_B


gen LS0Barr_AGG	= CE_AGG/(GVA_AGG - I_AGG)
gen LS0IPP_AGG	= CE_AGG/(GVA_AGG - IPP_AGG)
gen LS0IPP_C	= CE_C/(GVA_C - IPP_C)
gen LS0IPP_NF	= CE_NF/(GVA_NF - IPP_NF)
gen LS0IPP_F	= CE_F/(GVA_F - IPP_F)
gen LS0IPP_NC	= CE_NC/(GVA_NC - IPP_NC)
gen LS0IPP_HH	= CE_HH/(GVA_HH - IPP_HH)
gen LS0IPP_NP	= CE_NP/(GVA_NP - IPP_NP)
gen LS0IPP_HHNP	= CE_HHNP/(GVA_HHNP - IPP_HHNP)
gen LS0IPP_Gov	= CE_Gov/(GVA_Gov - IPP_Gov)
gen LS0IPP_B	= CE_B/(GVA_B - IPP_B)


gen wLS0_C		= sGVA0_C * LS0_C
gen wLS0_NF		= sGVA0_NF * LS0_NF
gen wLS0_F		= sGVA0_F * LS0_F
gen wLS0_NC		= sGVA0_NC * LS0_NC
gen wLS0_HH		= sGVA0_HH * LS0_HH
gen wLS0_NP		= sGVA0_NP * LS0_NP
gen wLS0_HHNP	= sGVA0_HHNP * LS0_HHNP
gen wLS0_Gov	= sGVA0_Gov * LS0_Gov
gen wLS0_B		= sGVA0_B * LS0_B


gen LS1_AGG		= CE_AGG/(GVA_AGG - Tax_AGG)
gen LS1_C		= CE_C/(GVA_C - Tax_C)
gen LS1_NF		= CE_NF/(GVA_NF - Tax_NF)
gen LS1_F		= CE_F/(GVA_F - Tax_F)
gen LS1_NC		= CE_NC/(GVA_NC - Tax_NC)
gen LS1_HH		= CE_HH/(GVA_HH - Tax_HH)
gen LS1_NP		= CE_NP/(GVA_NP - Tax_NP)
gen LS1_HHNP	= CE_HHNP/(GVA_HHNP - Tax_HHNP)
gen LS1_Gov		= CE_Gov/(GVA_Gov - Tax_Gov)
gen LS1_B		= CE_B/(GVA_B - Tax_B)


gen LS1Barr_AGG	= CE_AGG/(GVA_AGG - Tax_AGG - I_AGG)
gen LS1IPP_AGG	= CE_AGG/(GVA_AGG - Tax_AGG - IPP_AGG)
gen LS1IPP_C	= CE_C/(GVA_C - Tax_C - IPP_C)
gen LS1IPP_NF	= CE_NF/(GVA_NF - Tax_NF - IPP_NF)
gen LS1IPP_F	= CE_F/(GVA_F - Tax_F - IPP_F)
gen LS1IPP_NC	= CE_NC/(GVA_NC - Tax_NC - IPP_NC)
gen LS1IPP_HH	= CE_HH/(GVA_HH - Tax_HH - IPP_HH)
gen LS1IPP_NP	= CE_NP/(GVA_NP - Tax_NP - IPP_NP)
gen LS1IPP_HHNP	= CE_HHNP/(GVA_HHNP - Tax_HHNP - IPP_HHNP)
gen LS1IPP_Gov	= CE_Gov/(GVA_Gov - Tax_Gov - IPP_Gov)
gen LS1IPP_B	= CE_B/(GVA_B - Tax_B - IPP_B)


gen wLS1_C		= sGVA1_C * LS1_C
gen wLS1_NF		= sGVA1_NF * LS1_NF
gen wLS1_F		= sGVA1_F * LS1_F
gen wLS1_NC		= sGVA1_NC * LS1_NC
gen wLS1_HH		= sGVA1_HH * LS1_HH
gen wLS1_NP		= sGVA1_NP * LS1_NP
gen wLS1_HHNP	= sGVA1_HHNP * LS1_HHNP
gen wLS1_Gov	= sGVA1_Gov * LS1_Gov
gen wLS1_B		= sGVA1_B * LS1_B


gen LS2_AGG		= CE_AGG/(GVA_AGG - Tax_AGG - PI_AGG)
gen LS2_C		= CE_C/(GVA_C - Tax_C - PI_C)
gen LS2_NF		= CE_NF/(GVA_NF - Tax_NF - PI_NF)
gen LS2_F		= CE_F/(GVA_F - Tax_F - PI_F)
gen LS2_NC		= CE_NC/(GVA_NC - Tax_NC - PI_NC)
gen LS2_HH		= CE_HH/(GVA_HH - Tax_HH - PI_HH)
gen LS2_NP		= CE_NP/(GVA_NP - Tax_NP - PI_NP)
gen LS2_HHNP	= CE_HHNP/(GVA_HHNP - Tax_HHNP - PI_HHNP)
gen LS2_Gov		= CE_Gov/(GVA_Gov - Tax_Gov - PI_Gov)
gen LS2_B		= CE_B/(GVA_B - Tax_B - PI_B)


gen LS2Barr_AGG	= CE_AGG/(GVA_AGG - Tax_AGG - PI_AGG - I_AGG)
gen LS2Barr1_NF	= CE_NF/(GVA_NF - Tax_NF - PI_NF - I_NF)
gen LS2Barr2_NF	= CE_NF/(GVA_NF - Tax_NF - PI_NF - (I_NF-IPP_NF))
gen LS2Barr1_C	= CE_C/(GVA_C - Tax_C - PI_C - I_C)
gen LS2Barr2_C	= CE_C/(GVA_C - Tax_C - PI_C - (I_C - IPP_C))
gen LS2IPP_AGG	= CE_AGG/(GVA_AGG - Tax_AGG - PI_AGG - IPP_AGG)
gen LS2IPP_C	= CE_C/(GVA_C - Tax_C - PI_C - IPP_C)
gen LS2IPP_NF	= CE_NF/(GVA_NF - Tax_NF - PI_NF - IPP_NF)
gen LS2IPP_F	= CE_F/(GVA_F - Tax_F - PI_F - IPP_F)
gen LS2IPP_NC	= CE_NC/(GVA_NC - Tax_NC - PI_NC - IPP_NC)
gen LS2IPP_HH	= CE_HH/(GVA_HH - Tax_HH - PI_HH - IPP_HH)
gen LS2IPP_NP	= CE_NP/(GVA_NP - Tax_NP - PI_NP - IPP_NP)
gen LS2IPP_HHNP	= CE_HHNP/(GVA_HHNP - Tax_HHNP - PI_HHNP - IPP_HHNP)
gen LS2IPP_Gov	= CE_Gov/(GVA_Gov - Tax_Gov - PI_Gov - IPP_Gov)
gen LS2IPP_B	= CE_B/(GVA_B - Tax_B - PI_B - IPP_B)


gen wLS2_C		= sGVA2_C * LS2_C
gen wLS2_NF		= sGVA2_NF * LS2_NF
gen wLS2_F		= sGVA2_F * LS2_F
gen wLS2_NC		= sGVA2_NC * LS2_NC
gen wLS2_HH		= sGVA2_HH * LS2_HH
gen wLS2_NP		= sGVA2_NP * LS2_NP
gen wLS2_HHNP	= sGVA2_HHNP * LS2_HHNP
gen wLS2_Gov	= sGVA2_Gov * LS2_Gov
gen wLS2_B		= sGVA2_B * LS2_B


// CAPITAL SHARE OF IPP AND TANGIBLES (POST-2013)
gen YK_NF 		= (GVA_NF - Tax_NF - PI_NF) - CE_NF
gen CS_NF 		= YK_NF/(GVA_NF - Tax_NF - PI_NF)
gen CS_NF_IPP 	= IPP_NF/(GVA_NF - Tax_NF - PI_NF)
gen CS_NF_nIPP 	= (YK_NF - IPP_NF)/(GVA_NF - Tax_NF - PI_NF)


// CAPITAL SHARE OF IPP AND TANGIBLES (PRE-1999)
gen chi_KSZ			= 1-LS2IPP_NF
gen CS_NFx 			= (YK_NF - (1-chi_KSZ)*IPP_NF) / (GVA_NF - Tax_NF - PI_NF)
gen CS_NFx_IPP 		= chi_KSZ*IPP_NF/(GVA_NF - Tax_NF - PI_NF)
gen CS_NFx_nIPP 	= (YK_NF - IPP_NF) /(GVA_NF - Tax_NF - PI_NF)



//-------------------------------------------------------------------------------  
// 		CORPORATE SECTORS, 1929-2018
//------------------------------------------------------------------------------- 

gen ln_LS2_C = ln(LS2_C)
reg ln_LS2_C tt
gen ln_LS2IPP_C = ln(LS2IPP_C)
reg ln_LS2IPP_C year

reg LS2_C year
predict XBLS2_C
reg LS2IPP_C year
predict XBLS2IPP_C
twoway 	(line LS2_C 			year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_C 			year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_C 			year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_C 		year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.6(0.05)0.8,labsize(large)) ///
		xlabel(1929(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_C.png", width(1400) height(1000) replace


reg LS2_NF year
predict XBLS2_NF
di _b[year]*(2018-1929+1)
reg LS2IPP_NF year
predict XBLS2IPP_NF
di _b[year]*(2018-1929+1)
twoway 	(line LS2_NF 			year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_NF 			year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_NF 		year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_NF 		year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.6(0.05)0.8,labsize(large)) ///
		xlabel(1929(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_NF.png", width(1400) height(1000) replace


reg LS2_F year
predict XBLS2_F
di _b[year]*(2018-1929+1)
reg LS2IPP_F year
predict XBLS2IPP_F
di _b[year]*(2018-1929+1)
twoway 	(line LS2_F 		year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_F 		year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_F 		year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_F 	year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.4(0.1)0.9,labsize(large)) ///
		xlabel(1929(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_F.png", width(1400) height(1000) replace




//-------------------------------------------------------------------------------  
// 		LS WITH BARRO(2019)
//------------------------------------------------------------------------------- 
reg LS2Barr1_C year
predict XBLS2Barr1_C
reg LS2Barr2_C year
predict XBLS2Barr2_C
twoway 	(line LS2Barr1_C 		year, 					lcolor(magenta) lwidth(vthick)) ///
		(line XBLS2Barr1_C 		year, 					lcolor(magenta) lpattern(dash) lwidth(thick)) ///
		(line LS2Barr2_C 		year, 					lcolor(green) lwidth(vthick)) ///
		(line XBLS2Barr2_C 		year, 					lcolor(green) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.7(.05)0.9,labsize(large)) ///
		xlabel(1929(3)2018, labsize(large) angle(90)) ///
		legend( region(lwidth(none) fcolor(none)) pos(6) ring(0) col(1) size(large) order(1 "Expensing Aggregate Inv" 3 "Expensing Tangible Inv"))
graph export "LS2_C_Barro.png", width(1400) height(1000) replace


//-------------------------------------------------------------------------------  
// 		BROADER INSTITUTIONAL SECTORS, 1948-2018
//------------------------------------------------------------------------------- 
drop if year<1948


twoway 	(line IPP_GVA0_B 		year, 		lcolor(black) lwidth(vthick)) ///
		(line IPP_GVA0_C 		year, 		lcolor(black) lpattern(longdash) lwidth(vthick)) ///
		(line IPP_GVA0_NC 		year, 		lcolor(black) lpattern(shortdash) lwidth(vthick)) ///
		(line IPP_GVA0_HHNP		year, 		lcolor(green) lwidth(vthick)) ///
		(line IPP_GVA0_HH		year, 		lcolor(green) lpattern(longdash) lwidth(vthick)) ///
		(line IPP_GVA0_NP		year, 		lcolor(green) lpattern(shortdash) lwidth(vthick)) ///
		(line IPP_GVA0_Gov 		year, 		lcolor(red) lwidth(vthick)), ///
		scheme(s1color) ytitle("IPP Share of GVA") xtitle("") ylabel(0(.01)0.05,labsize(large)) ///
		xlabel(1948(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(large) order(1 "Domestic Business" 2 "Domestic Business: Corporate" 3 "Domestic Business: Noncorporate" 4 "Households (including NPISH)" 5 "Households" 6 "NPISH" 7 "General Government"))
graph export "IPP_GVA2_sector.png", width(1400) height(1000) replace


reg LS2_B year
predict XBLS2_B
reg LS2IPP_B year
predict XBLS2IPP_B
twoway 	(line LS2_B 			year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_B 			year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_B 			year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_B 		year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.6(0.03)0.75,labsize(large)) ///
		xlabel(1948(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_B.png", width(1400) height(1000) replace


reg LS2_NC year
predict XBLS2_NC
reg LS2IPP_NC year
predict XBLS2IPP_NC
twoway 	(line LS2_NC 			year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_NC 			year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_NC 		year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_NC 		year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.4(0.1)0.9,labsize(large)) ///
		xlabel(1948(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_NC.png", width(1400) height(1000) replace



reg LS2_HH year
predict XBLS2_HH
reg LS2IPP_HH year
predict XBLS2IPP_HH
twoway 	(line LS2_HH 		year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_HH 		year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_HH 	year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_HH 	year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0(0.05)0.3,labsize(large)) ///
		xlabel(1948(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_HH.png", width(1400) height(1000) replace


reg LS2_NP year
predict XBLS2_NP
reg LS2IPP_NP year
predict XBLS2IPP_NP
twoway 	(line LS2_NP 		year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_NP 		year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_NP 	year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_NP 	year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.76(0.02)0.9,labsize(large)) ///
		xlabel(1948(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_NP.png", width(1400) height(1000) replace


reg LS2_HHNP year
predict XBLS2_HHNP
reg LS2IPP_HHNP year
predict XBLS2IPP_HHNP
twoway 	(line LS2_HHNP 			year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_HHNP 		year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_HHNP 		year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_HHNP 	year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.25(0.05)0.5,labsize(large)) ///
		xlabel(1948(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_HHNP.png", width(1400) height(1000) replace


reg LS2_Gov year
predict XBLS2_Gov
reg LS2IPP_Gov year
predict XBLS2IPP_Gov
twoway 	(line LS2_Gov 			year, 		lcolor(blue) lwidth(vthick)) ///
		(line XBLS2_Gov 		year, 		lcolor(blue) lpattern(dash) lwidth(thick)) ///
		(line LS2IPP_Gov 		year, 		lcolor(orange) lwidth(vthick)) ///
		(line XBLS2IPP_Gov 	year, 		lcolor(orange) lpattern(dash) lwidth(thick)), ///
		scheme(s1color) ytitle("") xtitle("") ylabel(0.65(0.05)0.9,labsize(large)) ///
		xlabel(1948(3)2018, labsize(large) angle(90)) ///
		legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS2_Gov.png", width(1400) height(1000) replace


