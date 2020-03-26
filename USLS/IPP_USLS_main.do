/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES IN "LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
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
import excel "IPP_USLS_DATA.xlsx", sheet("NA_Aggregate") cellrange(A1:BN119) firstrow clear

gen ttrend 		= _n
gen Y 	= GDP

// DEPRECIATION OF CAPITAL
// CFC IN NATIONAL INCOME ACCOUNT IS EQUIVALENT TO PRIVATE AND GOVERNMENT DEP (NO DEP OF CONSUMER DURABLES)
egen DEP_KP_ES		= rsum(DEP_KP_EQ_Nres  DEP_KP_EQ_Res	DEP_KP_ST_Nres 	DEP_KP_ST_Res)
egen DEP_KG_ES		= rsum(DEP_KG_EQ_Nres  DEP_KG_EQ_Res	DEP_KG_ST_Nres 	DEP_KG_ST_Res)
egen DEP_KP_ESS		= rsum(DEP_KP_EQ_Nres  DEP_KP_EQ_Res	DEP_KP_ST_Nres 	DEP_KP_ST_Res  DEP_KP_Software)
egen DEP_KG_ESS		= rsum(DEP_KG_EQ_Nres  DEP_KG_EQ_Res	DEP_KG_ST_Nres 	DEP_KG_ST_Res  DEP_KG_Software)
egen DEP_KP_ESI		= rsum(DEP_KP_EQ_Nres  DEP_KP_EQ_Res	DEP_KP_ST_Nres 	DEP_KP_ST_Res 	DEP_KP_IPP)
egen DEP_KG_ESI		= rsum(DEP_KG_EQ_Nres  DEP_KG_EQ_Res	DEP_KG_ST_Nres 	DEP_KG_ST_Res	DEP_KG_IPP)
egen DEP_KPG_ES		= rsum(DEP_KP_ES  DEP_KG_ES)
egen DEP_KPG_ESS	= rsum(DEP_KP_ESS  DEP_KG_ESS)
egen DEP_KPG_ESI	= rsum(DEP_KP_ESI  DEP_KG_ESI)
egen DEP_ES 		= rsum(DEP_KP_ES 	DEP_KG_ES 	DEP_CD)
egen DEP_ESS 		= rsum(DEP_KP_ESS 	DEP_KG_ESS 	DEP_CD)
egen DEP_ESI 		= rsum(DEP_KP_ESI 	DEP_KG_ESI 	DEP_CD)
egen DEP_NP_RD  	= rsum(DEP_KNP_IPP)


// CAPITAL STOCK
egen KP_ES			= rsum(KP_EQ_Nres KP_EQ_Res KP_ST_Nres KP_ST_Res)
egen KG_ES			= rsum(KG_EQ_Nres KG_EQ_Res KG_ST_Nres KG_ST_Res)
egen KP_ESS			= rsum(KP_EQ_Nres KP_EQ_Res KP_ST_Nres KP_ST_Res KP_Software)
egen KG_ESS			= rsum(KG_EQ_Nres KG_EQ_Res KG_ST_Nres KG_ST_Res KG_Software)
egen KP_ESI			= rsum(KP_EQ_Nres KP_EQ_Res KP_ST_Nres KP_ST_Res KP_IPP)
egen KG_ESI			= rsum(KG_EQ_Nres KG_EQ_Res KG_ST_Nres KG_ST_Res KG_IPP)
egen K_ES			= rsum(KP_ES KG_ES CD)
egen K_ESI 			= rsum(KP_ESI KG_ESI CD)


// DEPRECIATION RATE
gen dep_CD 			= DEP_CD / CD
gen dep_KP_ES 		= DEP_KP_ES/KP_ES
gen dep_KG_ES 		= DEP_KG_ES/KG_ES
gen dep_KP_ESS 		= DEP_KP_ESS/KP_ESS
gen dep_KG_ESS 		= DEP_KG_ESS/KG_ESS
gen dep_KP_ESI 		= DEP_KP_ESI/KP_ESI
gen dep_KG_ESI 		= DEP_KG_ESI/KG_ESI
gen dep_ES 			= DEP_ES/K_ES
gen dep_ESI 		= DEP_ESI/K_ESI


// IPP INVESTMENT
replace IP_IPP 	= IP_Soft + IP_RD + IP_Ent
egen I_EQ 		= rsum(IP_EQ_Nres 	IG_EQ_Nres	IP_EQ_Res)
egen I_ST 		= rsum(IP_ST_Nres 	IG_ST_Nres	IP_ST_Res IG_ST_Res)
egen I_IPP 		= rsum(IP_IPP 		IG_IPP)
egen I_Soft 	= rsum(IP_Software 	IG_Software)
egen I_RD 		= rsum(IP_RD 		IG_RD)
egen I_Ent 		= rsum(IP_Ent)
egen I_NP_RD	= rsum(INP_IPP)
egen I_ESI 		= rsum(I_EQ I_ST I_IPP)
egen IP_ESI 	= rsum(IP_EQ_Nres  IP_EQ_Res  IP_ST_Nres  IP_ST_Res  IP_IPP)
egen IG_ESI 	= rsum(IG_EQ_Nres  IG_ST_Nres  IG_ST_Res  IG_IPP)
egen I_ESI_Nres = rsum(IP_EQ_Nres	IP_ST_Nres	IP_IPP		IG_EQ_Nres	IG_ST_Nres	IG_IPP)


gen sI_EQ 		= I_EQ/I_ESI
gen sI_ST 		= I_ST/I_ESI
gen sI_IPP 		= I_IPP/I_ESI
gen sI_Soft 	= I_Soft/I_ESI
gen sI_RD 		= I_RD/I_ESI
gen sI_Ent 		= I_Ent/I_ESI
gen sI_IPP_Nres	= I_IPP/I_ESI_Nres


gen sY_EQ 		= I_EQ/Y
gen sY_ST 		= I_ST/Y
gen sY_IPP 		= I_IPP/Y
gen sY_Soft 	= I_Soft/Y
gen sY_RD 		= I_RD/Y
gen sY_Ent 		= I_Ent/Y


/*********** POST-2013 ************/
gen LS_ESI 		= CE/(Y - Tax + Sub - PI)
gen LS_ESI_NET 	= CE/(Y - Tax + Sub - PI - DEP_ESI)


/*********** PRE-1999 ************/
gen Delta_ES 	= IP_IPP - I_NP_RD + DEP_NP_RD + DEP_KG_IPP
gen LS_ES 		= CE/(Y - Tax + Sub - PI - Delta_ES)
gen LS_ES_NET 	= CE/(Y - Tax + Sub - PI - DEP_ES - Delta_ES)


/*********** PRE-2013 ************/
gen Delta_ESS 	= IP_RD + IP_Ent - I_NP_RD + DEP_NP_RD + DEP_KG_RD
gen LS_ESS 		= CE/(Y - Tax + Sub - PI - Delta_ESS)
gen LS_ESS_NET 	= CE/(Y - Tax + Sub - PI - DEP_ESS - Delta_ESS)


/*********** BARRO ************/
gen LS_Barro1	= CE/(Y - Tax + Sub - PI - I_ESI)
gen LS_Barro2	= CE/(Y - Tax + Sub - PI - (I_ESI - I_IPP))



//////////////////////////////////////////////////////////////
////////			    CAPITAL SHARE				  ////////
//////////////////////////////////////////////////////////////

// CAPITAL SHARE OF IPP AND TANGIBLES (POST-2013)
gen YK_ESI 		= (Y - Tax + Sub - PI) - CE
gen CS_ESI 		= YK_ESI/(Y - Tax + Sub - PI)
gen CS_ESI_IPP 	= I_IPP/(Y - Tax + Sub - PI)
gen CS_ESI_nIPP = (YK_ESI - I_IPP)/(Y - Tax + Sub - PI)
gen CS_SFT 		= I_Soft/(Y - Tax + Sub - PI)
gen CS_RND 		= I_RD/(Y - Tax + Sub - PI)
gen CS_Ent 		= I_Ent/(Y - Tax + Sub - PI)


// CAPITAL SHARE OF IPP AND TANGIBLES (PRE-1999)
gen chi_KSZ			= 1-LS_ES
gen CS_ESIx 		= (YK_ESI - (1-chi_KSZ)*I_IPP) / (Y - Tax + Sub - PI)
gen CS_ESIx_IPP 	= chi_KSZ*I_IPP/(Y - Tax + Sub - PI)
gen CS_ESIx_nIPP 	= (YK_ESI - I_IPP) / (Y - Tax + Sub - PI)

*-------------------------------------------------------------------------------  
*------------------------------------------------------------------------------- 

// TREND
regress LS_ESI ttrend
predict XBLS_ESI
regress LS_ESI_NET ttrend
predict XBLS_ESI_NET

regress LS_ES ttrend
predict XBLS_ES
regress LS_ES_NET ttrend
*regress LS_ES_NET
predict XBLS_ES_NET

regress LS_ESS ttrend
predict XBLS_ESS
regress LS_ESS_NET ttrend
predict XBLS_ESS_NET

regress LS_Barro1 ttrend
predict XBLS_Barro1
regress LS_Barro2 ttrend
predict XBLS_Barro2

regress CS_ESI ttrend
predict XBCS_ESI
regress CS_ESI_IPP ttrend
predict XBCS_ESI_IPP
regress CS_ESI_nIPP ttrend
predict XBCS_ESI_nIPP

regress CS_RND ttrend
predict XBCS_RND
regress CS_SFT ttrend if year>=1960
predict XBCS_SFT if year>=1960
regress CS_Ent ttrend
predict XBCS_Ent

regress CS_ESIx ttrend
predict XBCS_ESIx
regress CS_ESIx_IPP ttrend
predict XBCS_ESIx_IPP
regress CS_ESIx_nIPP ttrend
predict XBCS_ESIx_nIPP


// TREND
regress LS_ESI ttrend if year>=1991
regress LS_ES ttrend if year>=1991
regress LS_ESI ttrend if year>=1995
regress LS_ES ttrend if year>=1995


// PLOT FIGURES
twoway (line sI_ST  year, lcolor(magenta) lpattern(shortdash) lwidth(vthick)) ///
	   (line sI_EQ  year, lcolor(green) lpattern(dash) lwidth(vthick)) ///
       (line sI_IPP year, lcolor(black) lpattern(solid) lwidth(vthick)), ///
	   scheme(s1color)  ytitle("Share of Aggregate Investment") ylabel(0(0.1)0.9,labsize(medium)) xtitle("") xlabel(1901(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) size(medium) rows(1) pos(12) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invshares_1901_2018_type.png", width(1400) height(1000) replace


drop if year<1929
twoway (line sY_ST  year, lcolor(magenta) lpattern(shortdash) lwidth(vthick)) ///
	   (line sY_EQ  year, lcolor(green) lpattern(dash) lwidth(vthick)) ///
       (line sY_IPP year, lcolor(black) lpattern(solid) lwidth(vthick)), ///
	   scheme(s1color)  ytitle("Share of GDP") ylabel(0(0.03)0.18,labsize(medium)) xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) size(medium) rows(1) pos(12) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invsharesY_1929_2018_type.png", width(1400) height(1000) replace


gen ln_LS_ESI = ln(LS_ESI)
reg ln_LS_ESI year
twoway (line LS_ESI year, 			lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS_ESI year, 		lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS_ES year, 			lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS_ES year, 			lcolor(orange) lpattern(dash) lwidth(thick)), ///	   
	   scheme(s1color) ytitle("Labor Share") ylabel(0.58(0.04)0.74, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(symxsize(8) region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS_aug0.png", width(1400) height(1000) replace


twoway (line LS_ESI year, 			lcolor(blue) lwidth(vthick)) || ///
	   (line XBLS_ESI year, 		lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line LS_ES year, 			lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS_ES year, 			lcolor(orange) lpattern(dash) lwidth(thick)) || ///	   
	   (line LS_ESS year, 			lcolor(magenta) lwidth(vthick)) || ///
	   (line XBLS_ESS year, 		lcolor(magenta) lpattern(dash) lwidth(thick)), ///	   
	   scheme(s1color) ytitle("Labor Share") ylabel(0.58(0.04)0.74, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(symxsize(8) region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS" 5 "Pre-2013 Revision Accounting LS"))
graph export "LS_aug1.png", width(1400) height(1000) replace

gen LS_ESS_ES = LS_ESS - LS_ES
gen LS_ESI_ESS = LS_ESI - LS_ESS
gen LS_ESI_ES = LS_ESI - LS_ES
twoway (line LS_ESS_ES year, 			lcolor(magenta) lwidth(vthick)) || ///
	   (line LS_ESI_ESS year, 			lcolor(ltblue) lwidth(vthick)) || ///
	   (line LS_ESI_ES year, 			lcolor(black) lwidth(vthick)), ///
	   scheme(s1color) ytitle("Labor Share Difference") ylabel(-0.05(0.01)0, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90))  xline(1960, lcolor(gs12) lwidth(thick)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(medium) order(1 "1999 Revision Effects (Software)" 2 "2013 Revision Effects (R&D and Artistic Originals)" 3 "Total Effects"))
graph export "LS_diff.png", width(1400) height(1000) replace




*------------------------------------------------------------------------------- 
*	CHI 
*------------------------------------------------------------------------------- 

gen NSF_chi1 	= NSF_chi
egen NSF_chi_mean = mean(NSF_chi)

reg NSF_chi1 year
predict NSF_hat if year<1968
*replace NSF_chi1 = NSF_hat in 1/33
*replace NSF_chi1 = NSF_chi[34] in 1/33
replace NSF_chi1 = NSF_chi_mean in 1/33
gen chi_inv_NSF1 	= 1- NSF_chi1
gen chi_inv_NSF 	= 1- NSF_chi


gen LS_chi0 		= (CE + 0*I_IPP)/(Y - Tax + Sub - PI)
gen LS_chi1 		= (CE + 1*I_IPP)/(Y - Tax + Sub - PI)
gen LS_chi2 		= (CE + 0.5*I_IPP)/(Y - Tax + Sub - PI)
gen LS_chi3 		= (CE + chi_inv_NSF1*I_IPP)/(Y - Tax + Sub - PI)

reg LS_chi0 year
predict XBLS_chi0
reg LS_chi1 year
predict XBLS_chi1
reg LS_chi2 year
predict XBLS_chi2
reg LS_chi3 year
predict XBLS_chi3

twoway (line LS_chi0 year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line LS_chi1 year, 				lcolor(green) lwidth(vthick)) || ///
	   (line LS_chi2 year, 				lcolor(red) lwidth(vthick)) || ///
	   (line LS_chi3 year, 				lcolor(gs5) lwidth(vthick)) || ///
	   (line LS_ES year, 				lcolor(orange) lwidth(vthick)) || ///
	   (line XBLS_chi0 year, 			lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line XBLS_chi1 year, 			lcolor(green) lpattern(dash) lwidth(thick)) || ///
	   (line XBLS_chi2 year, 			lcolor(red) lpattern(dash) lwidth(thick)) || ///
	   (line XBLS_chi3 year, 			lcolor(gs5) lpattern(dash) lwidth(thick)) || ///
	   (line XBLS_ES year, 				lcolor(orange) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("") ylabel(0.6(0.02)0.74, labsize(medium)) xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(2) size(medium) ///
	   order(1 "{&chi}=1, BEA LS"  2 "{&chi}= 0" 3 "{&chi}=0.5, MP (2010)" 4 "{&chi}=NSF R&D Cost Structure" 5 "{&chi}=Ambiguous Income Treatment" ))
graph export "LS_x.png", width(1400) height(1000) replace


gen chi_inv_MP 		= 0.5 if year>=1990 & year<=2003
gen chi_inv_SYZZ	= 0.75 if year>=2001 & year<=2014
gen chi_inv_LW0		= 0.25 if year==1988
replace chi_inv_LW0 = 0.57 if year==1998
gen chi_inv_LW1		= 0.25 if year<=1988
replace chi_inv_LW1 = 0.57 if year>=1998
ipolate chi_inv_LW0 year if year>=1988 & year<=1998, gen(chi_new)
replace chi_inv_LW1 = chi_new if year>=1988 & year<=1998
gen chi_inv_KSZ 	= 1 - chi_KSZ


twoway (line chi_inv_NSF year, 		lcolor(gs5) lwidth(vthick)) || ///
	   (line chi_inv_NSF1 year, 	lcolor(gs5) lpattern(dash)  lwidth(vthick)) || ///
	   (line chi_inv_MP year, 		lcolor(red) lwidth(vthick)) || ///
	   (line chi_inv_KSZ year, 		lcolor(orange) lwidth(vthick)) || ///
	   (line chi_inv_LW1 year, 		lcolor(ltblue) lpattern(dash) lwidth(thick)) || ///
	   (scatter chi_inv_LW0 year, 	mcolor(blue) msize(large)), ///
	   scheme(s1color) ytitle("") ylabel(0.2(0.2)1, labsize(medium)) xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) ring(0) col(2) size(medium) order(3 "1-{&chi}=MP (2010)" 4 "1-{&chi}=Ambiguous Income" 1 "1-{&chi}=NSF R&D Cost Structure" 6 "1-{&chi}=LW (2007)"))
graph export "chi_values.png", width(1400) height(1000) replace



// CAPITAL SHARE DECOMPOSITION
twoway (line CS_ESI year, 				lcolor(blue) lwidth(vthick)) || ///
	   (line XBCS_ESI year, 			lcolor(blue) lpattern(dash) lwidth(thick)) || ///
	   (line CS_ESI_nIPP year, 			lcolor(green) ylabel(0.28(0.02)0.4, axis(1) labsize(medium)) lwidth(vthick)) || ///
	   (line XBCS_ESI_nIPP year, 		lcolor(green) lpattern(dash) lwidth(thick)) || ///
	   (line CS_ESI_IPP year, 			lcolor(black) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0(0.02)0.12, axis(2) labsize(medium)) lwidth(vthick)) || ///
	   (line XBCS_ESI_IPP year, 		lcolor(black) lpattern(dash) yaxis(2) lwidth(thick)), ///
	   scheme(s1color) xlabel(1929(3)2018, labsize(medium) angle(90)) xtitle("") ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA Capital Share (left axis)" 3 "Tangible Capital Share (left axis)" 5 "IPP Capital Share (right axis)" ))
graph export "CS_IPP_aug.png", width(1400) height(1000) replace


twoway (line CS_Ent year, 				lcolor(gray) lwidth(thick)) || ///
	   (line CS_RND year, 				lcolor(ltblue) lwidth(vthick)) || ///
	   (line CS_SFT year, 				lcolor(magenta) lwidth(vthick)) || ///
	   (line CS_ESI_IPP year, 			lcolor(black) lwidth(vthick)) || ///
	   (line XBCS_ESI_IPP year, 		lcolor(black) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) xlabel(1929(3)2018, labsize(medium) angle(90)) xtitle("") ylabel(0(0.02)0.12, labsize(medium)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(4 "IPP Capital Share" 2 "R&D Capital Share" 3 "Software Capital Share" 1 "Artistic Originals Capital Share"))
graph export "CS_IPP_sub.png", width(1400) height(1000) replace


twoway (line LS_Barro1 year, 		lcolor(magenta) lwidth(vthick)) || ///
	   (line XBLS_Barro1 year, 		lcolor(magenta) lpattern(dash) lwidth(thick)) || ///
	   (line LS_Barro2 year, 		lcolor(green) lwidth(vthick)) || ///
	   (line XBLS_Barro2 year, 		lcolor(green) lpattern(dash) lwidth(thick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.7(0.05)1.0, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(symxsize(8) region(lwidth(none) fcolor(none)) pos(6) ring(0) col(1) size(medium) order(1 "Expensing Aggregate Inv" 3 "Expensing Tangible Inv"))
graph export "LS2_Barro.png", width(1400) height(1000) replace


