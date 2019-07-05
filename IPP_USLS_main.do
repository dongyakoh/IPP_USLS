/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES IN "LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.
CREATED BY DONGYA KOH, 7/4/2019
***************************************************************/

clear
clear matrix
set more off,permanently


// SET A PATH TO A FOLDER WHERE DATA FILE IS STORED
cd ""


*-------------------------------------------------------------------------------  
*------------------------------------------------------------------------------- 
* IMPORT MAIN DATA
import excel "IPP_USLS_DATA.xlsx", sheet("Data") cellrange(A1:BL118) firstrow clear

drop if year<1947 | year>2017

gen ttrend 		= _n

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
egen DEP_IPP 		= rsum(DEP_KP_IPP DEP_KG_IPP)


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
egen I_EQ 		= rsum(IP_EQ_Nres 	IG_EQ_Nres	IP_EQ_Res)
egen I_ST 		= rsum(IP_ST_Nres 	IG_ST_Nres	IP_ST_Res IG_ST_Res)
egen I_IPP 		= rsum(IP_IPP 		IG_IPP)
egen I_Soft 	= rsum(IP_Software 	IG_Software)
egen I_RD 		= rsum(IP_RD 		IG_RD)
egen I_Ent 		= rsum(IP_Ent)
egen I_NP_RD	= rsum(INP_IPP)
egen I_ESI 		= rsum(I_EQ I_ST I_IPP)
egen I_ES 		= rsum(I_EQ I_ST)
egen IP_ESI 	= rsum(IP_EQ_Nres  IP_EQ_Res  IP_ST_Nres  IP_ST_Res  IP_IPP)
egen IG_ESI 	= rsum(IG_EQ_Nres  IG_ST_Nres  IG_ST_Res  IG_IPP)

egen IP_Nres 	= rsum(IP_EQ_Nres 	IP_ST_Nres 	IP_IPP)
egen IG_Nres 	= rsum(IG_EQ_Nres 	IG_ST_Nres 	IG_IPP)
egen I_Nres 	= rsum(IP_Nres 	IG_Nres)
gen IPP_sh_NRes = I_IPP/I_Nres

// INVESTMENT SHARE
gen sI_EQ 		= I_EQ/I_ESI
gen sI_ST 		= I_ST/I_ESI
gen sI_IPP 		= I_IPP/I_ESI
gen sY_EQ 		= I_EQ/GNP
gen sY_ST 		= I_ST/GNP
gen sY_IPP 		= I_IPP/GNP


/*********** POST-2013 ************/
gen UCI_ESI 	= RI + CP + NI + GE + (Tax - Sub - Exc_Tax - Sale_Tax) + BCTP + SDis
gen UI_ESI  	= UCI_ESI + CFC + CE
gen theta_ESI 	= (UCI_ESI + CFC) / UI_ESI
gen AI_ESI  	= PI + Exc_Tax + Sale_Tax
gen ACI_ESI  	= theta_ESI * AI_ESI
gen YKP_ESI    	= UCI_ESI + CFC + ACI_ESI
gen r_ESI 		= (YKP_ESI - CFC) / KP_ESI
gen YKD_ESI 	= (r_ESI + dep_CD)*CD
gen YKG_ESI 	= r_ESI*KG_ESI
gen YK_ESI		= YKP_ESI + YKD_ESI + YKG_ESI
gen GNP_ESI 	= GNP + YKD_ESI + YKG_ESI
gen LS_ESI		= 1 - YK_ESI / GNP_ESI
gen YK_ESI_NET  = YKP_ESI + YKD_ESI + YKG_ESI - DEP_ESI
gen GNP_ESI_NET = GNP + YKD_ESI + YKG_ESI - DEP_ESI
gen LS_ESI_NET	= 1 - YK_ESI_NET / GNP_ESI_NET


/*********** PRE-1999 ************/
gen Delta_ES 	= IP_IPP - I_NP_RD + DEP_NP_RD + DEP_KG_IPP
gen r_ES 		= (YKP_ESI - CFC) / KP_ES
gen YKD_ES 		= (r_ES + dep_CD)*CD
gen YKG_ES 		= r_ES*KG_ES
gen YK_ES     	= YKP_ESI + YKD_ES + YKG_ES - Delta_ES
gen GNP_ES 		= GNP + YKD_ES + YKG_ES - Delta_ES
gen LS_ES		= 1 - YK_ES / GNP_ES
gen YK_ES_NET  	= YKP_ESI + YKD_ES + YKG_ES - Delta_ES - DEP_ES
gen GNP_ES_NET 	= GNP + YKD_ES + YKG_ES - Delta_ES - DEP_ES
gen LS_ES_NET	= 1 - YK_ES_NET / GNP_ES_NET


/*********** PRE-2013 ************/
gen Delta_ESS 	= (IP_IPP - IP_Soft) - I_NP_RD + DEP_NP_RD + DEP_KG_RD
gen r_ESS 		= (YKP_ESI - CFC) / KP_ESS
gen YKD_ESS 	= (r_ESS + dep_CD)*CD
gen YKG_ESS 	= r_ESS*KG_ESS
gen YK_ESS     	= YKP_ESI + YKD_ESS + YKG_ESS - Delta_ESS
gen GNP_ESS 	= GNP + YKD_ESS + YKG_ESS - Delta_ESS
gen LS_ESS		= 1 - YK_ESS / GNP_ESS
gen YK_ESS_NET  = YKP_ESI + YKD_ESS + YKG_ESS - Delta_ESS - DEP_ESS
gen GNP_ESS_NET = GNP + YKD_ESS + YKG_ESS - Delta_ESS - DEP_ESS
gen LS_ESS_NET	= 1 - YK_ESS_NET / GNP_ESS_NET




//////////////////////////////////////////////////////////////
////////			    MEASURES OF CHI				  ////////
//////////////////////////////////////////////////////////////
// Chi measure from NSF cost structure
gen x_NSF 		= NSF_chi
replace x_NSF 	= NSF_chi[16] in 1/15
egen x_NSF_mean = mean(x_NSF)

// IPP INVESTMENT AS AMBIGUOUS INCOME
gen x_AI 		= (YK_ESI - I_IPP) / (GNP_ESI - I_IPP)

// MP(2010)
gen x_MP = 0.5

gen I_ratio 	= I_IPP/GNP_ESI
gen LS_ES_0 	= 1 - (YK_ESI / GNP_ESI) + I_ratio 				// x=0
gen LS_ES_1 	= 1 - (YK_ESI / GNP_ESI)						// x=1
gen LS_ES_NSF 	= 1 - (YK_ESI / GNP_ESI) + (1-x_NSF)*I_ratio 	// x=NSF
gen LS_ES_NSF_mean 	= 1 - (YK_ESI / GNP_ESI) + (1-x_NSF_mean)*I_ratio 	// x=NSF MEAN
gen LS_ES_AI 	= 1 - (YK_ESI / GNP_ESI) + (1-x_AI)*I_ratio 	// x=AI
gen LS_ES_MP 	= 1 - (YK_ESI / GNP_ESI) + (1-x_MP)*I_ratio 	// x=MP(2010)


//////////////////////////////////////////////////////////////
////////			    EXPENSING INVESTMENT		  ////////
//////////////////////////////////////////////////////////////

// EXPENSING TANGIBLE INVESTMENT
gen LS_I 		= 1 - (YK_ESI - I_ES) / (GNP_ESI - I_ES)

// EXPENSING AGGREGATE INVESTMENT
gen LS_ 	= 1 - (YK_ESI - I_ESI) / (GNP_ESI - I_ESI)


//////////////////////////////////////////////////////////////
////////			    CAPITAL SHARE				  ////////
//////////////////////////////////////////////////////////////

// CAPITAL SHARE OF IPP AND TANGIBLES (POST-2013)
gen CS_ESI 		= YK_ESI/GNP_ESI
gen CS_ESI_IPP 	= I_IPP/GNP_ESI
gen CS_ESI_nIPP = (YK_ESI - I_IPP)/GNP_ESI


// CAPITAL SHARE OF IPP AND TANGIBLES (PRE-1999)
gen CS_ESIx 		= (YK_ESI / GNP_ESI) - (1-x_NSF)*I_ratio
gen CS_ESIx_IPP 	= x_NSF*I_ratio
gen CS_ESIx_nIPP 	= (YK_ESI / GNP_ESI) - I_ratio



*-------------------------------------------------------------------------------  
*-------------------------------------------------------------------------------  
* PLOT GRAPHS

regress LS_ESI ttrend
predict XBLS_ESI if LS_ESI!=.
di _b[ttrend]*71
regress LS_ESI_NET ttrend
*predict XBLS_ESI_NET if LS_ESI_NET!=.
egen XBLS_ESI_NET = mean(LS_ESI_NET)
regress LS_ESS ttrend if year>=1960 & year<=2017
predict XBLS_ESS if year>=1960 & year<=2017
regress LS_ES ttrend
predict XBLS_ES if LS_ES!=.
di _b[ttrend]*71
regress LS_ES_NET ttrend
*predict XBLS_ES_NET if LS_ES_NET!=.
egen XBLS_ES_NET 	= mean(LS_ES_NET)
regress LS_I ttrend
predict XBLS_I if LS_I!=.
regress LS_ ttrend
predict XBLS_ if LS_!=.

regress LS_ES_0 ttrend
predict XBLS_ES_0 if LS_ES_0!=.
di _b[ttrend]*70
regress LS_ES_1 ttrend
predict XBLS_ES_1 if LS_ES_1!=.
di _b[ttrend]*70
regress LS_ES_NSF ttrend
predict XBLS_ES_NSF if LS_ES_NSF!=.
regress LS_ES_NSF_mean ttrend
predict XBLS_ES_NSF_mean if LS_ES_NSF_mean!=.
regress LS_ES_AI ttrend
predict XBLS_ES_AI if LS_ES_AI!=.
regress LS_ES_MP ttrend
predict XBLS_ES_MP if LS_ES_MP!=.

regress LS_ESI ttrend if year>=1975 & year<=2010
predict XBLS_ESI_75_10 if year>=1975 & year<=2010
regress LS_ES ttrend if year>=1975 & year<=2010
predict XBLS_ES_75_10 if year>=1975 & year<=2010

regress CS_ESI ttrend
predict XBCS_ESI if CS_ESI!=.
regress CS_ESI_IPP ttrend
predict XBCS_ESI_IPP if CS_ESI_IPP!=.
regress CS_ESI_nIPP ttrend
predict XBCS_ESI_nIPP if CS_ESI_nIPP!=.

regress CS_ESIx ttrend
predict XBCS_ESIx if CS_ESIx!=.
regress CS_ESIx_IPP ttrend
predict XBCS_ESIx_IPP if CS_ESIx_IPP!=.
regress CS_ESIx_nIPP ttrend
predict XBCS_ESIx_nIPP if CS_ESIx_nIPP!=.


// FIGURE 1(a)
twoway (line sI_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line sI_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line sI_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Share of Aggregate Investment") ylabel(0(0.1)0.6,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(6) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invshares_type.png", width(1400) height(1000) replace


// FIGURE 1(b)
twoway (line sY_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line sY_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line sY_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Share of GNP") ylabel(0(0.05)0.15,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(6) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invsharesY_type.png", width(1400) height(1000) replace


// FIGURE 2
twoway (line LS_ESI year, 			lcolor(blue)) || ///
	   (line XBLS_ESI year, 		lcolor(blue) lpattern(dash)) || ///
	   (line LS_ES year, 			lcolor(orange)) || ///
	   (line XBLS_ES year, 			lcolor(orange) lpattern(dash)), ///	   
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) ///
	   legend(symxsize(8) region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS_main.png", width(1400) height(1000) replace


// FIGURE 3(a)
twoway (line LS_ESI year, 			lcolor(blue)) || ///
	   (line XBLS_ESI year, 		lcolor(blue) lpattern(dash)) || ///
	   (line LS_ESS year, 			lcolor(magenta)) || ///
	   (line XBLS_ESS year if year>=1960 & year<=2017, 		lcolor(magenta) lpattern(dash)) || ///
	   (line LS_ES year, 			lcolor(orange)) || ///
	   (line XBLS_ES year, 			lcolor(orange) lpattern(dash)), ///	   
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) xline(1960, lcolor(gs12) lwidth(thick)) ///
	   legend(symxsize(8) region(lwidth(none) fcolor(none)) pos(6) ring(0) col(1) size(medium) order(1 "BEA LS" 5 "Pre-1999 Revision Accounting LS" 3 "Pre-2013 Revision Accounting LS"))
graph export "LS_main2.png", width(1400) height(1000) replace


gen LS_ESS_ES = LS_ESS - LS_ES
gen LS_ESI_ESS = LS_ESI - LS_ESS
gen LS_ESI_ES = LS_ESI - LS_ES

// FIGURE 3(B)
twoway (line LS_ESS_ES year, 			lcolor(green)) || ///
	   (line LS_ESI_ESS year, 			lcolor(pink)) || ///
	   (line LS_ESI_ES year, 			lcolor(cyan)), ///
	   scheme(s1color) ytitle("Labor Share Difference") ylabel(-0.028(0.004)0, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90))  xline(1960, lcolor(gs12) lwidth(thick)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(1) size(medium) order(1 "Software Effects" 2 "R&D Effects" 3 "Total Effects"))
graph export "LS_diff.png", width(1400) height(1000) replace


// FIGURE 4(a)
twoway (line LS_ES year, 				lcolor(orange)) || ///
	   (line XBLS_ES year, 				lcolor(orange) lpattern(dash)) || ///
	   (line LS_ES_NET year, 			lcolor(green) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0.58(0.02)0.68, axis(2) labsize(medium))) || ///
	   (line XBLS_ES_NET year, 			lcolor(green) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.5(0.02)0.6, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Pre-1999 Gross LS (left axis)" 3 "Pre-1999 Net LS (right axis)"))
graph export "net_LS_aug_pre1999.png", width(1400) height(1000) replace


// FIGURE 4(b)
twoway (line LS_ESI year, 				lcolor(blue)) || ///
	   (line XBLS_ESI year, 			lcolor(blue) lpattern(dash)) || ///
	   (line LS_ESI_NET year, 			lcolor(green) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0.58(0.02)0.68, axis(2) labsize(medium))) || ///
	   (line XBLS_ESI_NET year, 		lcolor(green) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.49(0.02)0.59, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Post-2013 Gross LS (left axis)" 3 "Post-2013 Net LS (right axis)"))
graph export "net_LS_aug_post2013.png", width(1400) height(1000) replace


// FIGURE 6(a)
twoway (line LS_ES_1 year, 				lcolor(blue)) || ///
	   (line LS_ES_NSF year, 			lcolor(red)) || ///
	   (line LS_ES_0 year, 				lcolor(green)) || ///
	   (line LS_ES_NSF_mean year, 		lcolor(yellow)) || ///
	   (line LS_ES_MP year, 			lcolor(gray)) || ///
	   (line LS_ES_AI year, 				lcolor(magenta)) || ///
	   (line XBLS_ES_1 year, 			lcolor(blue) lpattern(dash)) || ///
	   (line XBLS_ES_NSF year, 			lcolor(red) lpattern(dash)) || ///
	   (line XBLS_ES_0 year, 			lcolor(green) lpattern(dash)) || ///
	   (line XBLS_ES_NSF_mean year, 	lcolor(yellow) lpattern(dash)) || ///
	   (line XBLS_ES_MP year, 			lcolor(gray) lpattern(dash)) || ///
	   (line XBLS_ES_AI year, 			lcolor(magenta) lpattern(dash)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium)) xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(2) size(medium) ///
	   order(1 "{&chi}=1, BEA LS"  2 "{&chi}= NSF R&D Cost Structure" 3 "{&chi}=0" 4 "{&chi}=0.41, NSF R&D Cost Average" 5 "{&chi}=MP (2010)" 6 "{&chi}=Ambiguous Income Treatment" ))
graph export "LS_x.png", width(1400) height(1000) replace


// FIGURE 8(a)
twoway (line CS_ESI year, 				lcolor(blue)) || ///
	   (line XBCS_ESI year, 			lcolor(blue) lpattern(dash)) || ///
	   (line CS_ESI_nIPP year, 			lcolor(green) ylabel(0.4(0.02)0.52, axis(1) labsize(medium))) || ///
	   (line XBCS_ESI_nIPP year, 		lcolor(green) lpattern(dash)) || ///
	   (line CS_ESI_IPP year, 			lcolor(magenta) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0(0.02)0.12, axis(2) labsize(medium))) || ///
	   (line XBCS_ESI_IPP year, 		lcolor(magenta) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) xlabel(1947(3)2017, labsize(medium) angle(90)) xtitle("") ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA Capital Share (left axis)" 3 "Tangible Capital Share (left axis)" 5 "IPP Capital Share (right axis)" ))
graph export "CS_IPP_aug.png", width(1400) height(1000) replace


// FIGURE 8(b)
twoway (line CS_ESIx year, 				lcolor(blue)) || ///
	   (line XBCS_ESIx year, 			lcolor(blue) lpattern(dash)) || ///
	   (line CS_ESIx_nIPP year, 		lcolor(green) ylabel(0.4(0.02)0.52, axis(1) labsize(medium))) || ///
	   (line XBCS_ESIx_nIPP year, 		lcolor(green) lpattern(dash)) || ///
	   (line CS_ESIx_IPP year, 			lcolor(magenta) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0(0.02)0.12, axis(2) labsize(medium))) || ///
	   (line XBCS_ESIx_IPP year, 		lcolor(magenta) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) xlabel(1947(3)2017, labsize(medium) angle(90)) xtitle("") ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA Capital Share (left axis)" 3 "Tangible Capital Share (left axis)" 5 "IPP Capital Share (right axis)" ))
graph export "CS_IPP_x_aug.png", width(1400) height(1000) replace


