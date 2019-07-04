/***************************************************************
THIS PROGRAM GENERATES MAIN FIGURES IN "LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.
CREATED BY DONGYA KOH, 6/30/2018
***************************************************************/

clear
clear matrix
set more off,permanently


// SET A PATH TO A FOLDER WHERE DATA FILE IS STORED
cd ""


*-------------------------------------------------------------------------------  
*------------------------------------------------------------------------------- 

* IMPORT MAIN DATA
import excel "IPP_USLS_DATA.xlsx", sheet("Data") cellrange(A1:BL117) firstrow clear
drop if year<1947 | year>2016

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
egen IP_ESI 	= rsum(IP_EQ_Nres  IP_EQ_Res  IP_ST_Nres  IP_ST_Res  IP_IPP)
egen IG_ESI 	= rsum(IG_EQ_Nres  IG_ST_Nres  IG_ST_Res  IG_IPP)


/*********** POST-2013 ************/
gen UCI_ESI_aug 	= RI + CP + NI + GE + (Tax - Sub - Exc_Tax - Sale_Tax) + BCTP + SDis
gen UI_ESI_aug  	= UCI_ESI_aug + CFC + CE
gen theta_ESI_aug 	= (UCI_ESI_aug + CFC) / UI_ESI_aug
gen AI_ESI_aug  	= PI + Exc_Tax + Sale_Tax
gen ACI_ESI_aug  	= theta_ESI_aug * AI_ESI_aug
gen YKP_ESI_aug    	= UCI_ESI_aug + CFC + ACI_ESI_aug
gen r_ESI 			= (YKP_ESI_aug - CFC) / KP_ESI
gen YKD_ESI 		= (r_ESI + dep_CD)*CD
gen YKG_ESI 		= (r_ESI + dep_KG_ESI)*KG_ESI
gen YK_ESI_aug		= YKP_ESI_aug + YKD_ESI + YKG_ESI
gen GNP_ESI_aug 	= GNP + YKD_ESI + YKG_ESI
gen LS_ESI_aug		= 1 - YK_ESI_aug / GNP_ESI_aug
gen YK_ESI_aug_NET  = YKP_ESI_aug + YKD_ESI + YKG_ESI - DEP_ESI
gen GNP_ESI_aug_NET = GNP + YKD_ESI + YKG_ESI - DEP_ESI
gen LS_ESI_aug_NET	= 1 - YK_ESI_aug_NET / GNP_ESI_aug_NET


/*********** PRE-1999 ************/
gen I_ES_aug 		= IP_IPP - I_NP_RD + DEP_NP_RD + DEP_KG_IPP
gen UCI_ES_aug 		= RI + CP + NI + GE + (Tax - Sub - Exc_Tax - Sale_Tax) + BCTP + SDis
gen UI_ES_aug  		= UCI_ES_aug + CFC + CE
gen theta_ES_aug 	= (UCI_ES_aug + CFC - I_ES_aug) / (UI_ES_aug - I_ES_aug)
gen AI_ES_aug  		= PI + Exc_Tax + Sale_Tax
gen ACI_ES_aug  	= theta_ES_aug * AI_ES_aug
gen YKP_ES_aug    	= UCI_ES_aug + CFC + ACI_ES_aug
gen r_ES 			= (YKP_ES_aug - CFC) / (KP_ES)
gen YKD_ES 			= (r_ES + dep_CD)*CD
gen YKG_ES 			= (r_ES + dep_KG_ES)*KG_ES
gen YK_ES_aug     	= YKP_ES_aug + YKD_ES + YKG_ES - I_ES_aug
gen GNP_ES_aug 		= GNP + YKD_ES + YKG_ES - I_ES_aug
gen LS_ES_aug		= 1 - YK_ES_aug / GNP_ES_aug
gen YK_ES_aug_NET  	= YKP_ES_aug + YKD_ES + YKG_ES - I_ES_aug - DEP_ES
gen GNP_ES_aug_NET 	= GNP + YKD_ES + YKG_ES - I_ES_aug - DEP_ES
gen LS_ES_aug_NET	= 1 - YK_ES_aug_NET / GNP_ES_aug_NET


/*********** PRE-2013 ************/
gen I_ESS_aug 		= IP_RD + IP_Ent - I_NP_RD + DEP_NP_RD + DEP_KG_RD
gen UCI_ESS_aug 	= RI + CP + NI + GE + (Tax - Sub - Exc_Tax - Sale_Tax) + BCTP + SDis
gen UI_ESS_aug  	= UCI_ESS_aug + CFC + CE
gen theta_ESS_aug 	= (UCI_ESS_aug + CFC - I_ESS_aug) / (UI_ESS_aug - I_ESS_aug)
gen AI_ESS_aug  	= PI + Exc_Tax + Sale_Tax
gen ACI_ESS_aug  	= theta_ESS_aug * AI_ESS_aug
gen YKP_ESS_aug    	= UCI_ESS_aug + CFC + ACI_ESS_aug
gen r_ESS 			= (YKP_ESS_aug - CFC) / (KP_ESS)
gen YKD_ESS 		= (r_ESS + dep_CD)*CD
gen YKG_ESS 		= (r_ESS + dep_KG_ESS)*KG_ESS
gen YK_ESS_aug     	= YKP_ESS_aug + YKD_ESS + YKG_ESS - I_ESS_aug
gen GNP_ESS_aug 	= GNP + YKD_ESS + YKG_ESS - I_ESS_aug
gen LS_ESS_aug		= 1 - YK_ESS_aug / GNP_ESS_aug
gen YK_ESS_aug_NET  = YKP_ESS_aug + YKD_ESS + YKG_ESS - I_ESS_aug - DEP_ESS
gen GNP_ESS_aug_NET = GNP + YKD_ESS + YKG_ESS - I_ESS_aug - DEP_ESS
gen LS_ESS_aug_NET	= 1 - YK_ESS_aug_NET / GNP_ESS_aug_NET



//////////////////////////////////////////////////////////////
////////			    ALTERNATIVE X 				  ////////
//////////////////////////////////////////////////////////////

gen x3 = 0.38
gen x4 = 0.5
gen I_ratio 	= I_IPP/GNP_ESI_aug
gen LS_ES1_aug 	= 1 - (YK_ESI_aug / GNP_ESI_aug) + I_ratio
gen LS_ES2_aug 	= 1 - (YK_ESI_aug / GNP_ESI_aug) + (1-x3)*I_ratio
gen LS_ES3_aug 	= 1 - (YK_ESI_aug / GNP_ESI_aug) + (1-x4)*I_ratio
gen LS_ES4_aug 	= 1 - (YK_ESI_aug / GNP_ESI_aug)


//////////////////////////////////////////////////////////////
////////			    CAPITAL SHARE				  ////////
//////////////////////////////////////////////////////////////

// CAPITAL SHARE OF IPP AND TANGIBLES (POST-2013)
gen CS_ESI_aug 		= YK_ESI_aug/GNP_ESI_aug
gen CS_ESI_IPP_aug 	= I_IPP/GNP_ESI_aug
gen CS_ESI_nIPP_aug = (YK_ESI_aug - I_IPP)/GNP_ESI_aug


// CAPITAL SHARE OF IPP AND TANGIBLES (PRE-1999)
gen CS_ESIx_aug 		= (YK_ESI_aug / GNP_ESI_aug) - (1-x3)*I_ratio
gen CS_ESIx_IPP_aug 	= x3*I_ratio
gen CS_ESIx_nIPP_aug 	= (YK_ESI_aug / GNP_ESI_aug) - I_ratio

*-------------------------------------------------------------------------------  
*-------------------------------------------------------------------------------  
* PLOT GRAPHS

drop if year<1947 | year>2016

regress LS_ESI_aug ttrend if year>=1947 & year<=2016
predict XBLS_ESI_aug if LS_ESI_aug!=.
regress LS_ESI_aug_NET ttrend if year>=1947 & year<=2016
*predict XBLS_ESI_aug_NET if LS_ESI_aug_NET!=.
egen XBLS_ESI_aug_NET = mean(LS_ESI_aug_NET)
regress LS_ESS_aug ttrend if year>=1947 & year<=2016
predict XBLS_ESS_aug if LS_ESS_aug!=.
regress LS_ES_aug ttrend if year>=1947 & year<=2016
predict XBLS_ES_aug if LS_ES_aug!=.
regress LS_ES_aug_NET ttrend if year>=1947 & year<=2016
*predict XBLS_ES_aug_NET if LS_ES_aug_NET!=.
egen XBLS_ES_aug_NET 	= mean(LS_ES_aug_NET)

regress LS_ES1_aug ttrend if year>=1947 & year<=2016
predict XBLS_ES1_aug if LS_ES1_aug!=.
di _b[ttrend]*70
regress LS_ES2_aug ttrend if year>=1947 & year<=2016
predict XBLS_ES2_aug if LS_ES2_aug!=.
di _b[ttrend]*70
regress LS_ES3_aug ttrend if year>=1947 & year<=2016
predict XBLS_ES3_aug if LS_ES3_aug!=.
di _b[ttrend]*70
regress LS_ES4_aug ttrend if year>=1947 & year<=2016
predict XBLS_ES4_aug if LS_ES4_aug!=.
di _b[ttrend]*70

regress CS_ESI_aug ttrend if year>=1947 & year<=2016
predict XBCS_ESI_aug if CS_ESI_aug!=.
regress CS_ESI_IPP_aug ttrend if year>=1947 & year<=2016
predict XBCS_ESI_IPP_aug if CS_ESI_IPP_aug!=.
regress CS_ESI_nIPP_aug ttrend if year>=1947 & year<=2016
predict XBCS_ESI_nIPP_aug if CS_ESI_nIPP_aug!=.

regress CS_ESIx_aug ttrend if year>=1947 & year<=2016
predict XBCS_ESIx_aug if CS_ESIx_aug!=.
regress CS_ESIx_IPP_aug ttrend if year>=1947 & year<=2016
predict XBCS_ESIx_IPP_aug if CS_ESIx_IPP_aug!=.
regress CS_ESIx_nIPP_aug ttrend if year>=1947 & year<=2016
predict XBCS_ESIx_nIPP_aug if CS_ESIx_nIPP_aug!=.


twoway (line LS_ESI_aug year, 			lcolor(blue)) || ///
	   (line XBLS_ESI_aug year, 		lcolor(blue) lpattern(dash)) || ///
	   (line LS_ESS_aug year, 			lcolor(magenta)) || ///
	   (line XBLS_ESS_aug year, 		lcolor(magenta) lpattern(dash)) || ///
	   (line LS_ES_aug year, 			lcolor(orange)) || ///
	   (line XBLS_ES_aug year, 			lcolor(orange) lpattern(dash)), ///	   
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2016, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA LS" 5 "Pre-1999 Revision Accounting LS" 3 "Pre-2013 Revision Accounting LS"))
graph export "LS_aug.png", width(1400) height(1000) replace


twoway (line LS_ES_aug year, 				lcolor(orange)) || ///
	   (line XBLS_ES_aug year, 				lcolor(orange) lpattern(dash)) || ///
	   (line LS_ES_aug_NET year, 			lcolor(green) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0.58(0.02)0.68, axis(2) labsize(medium))) || ///
	   (line XBLS_ES_aug_NET year, 			lcolor(green) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.5(0.02)0.6, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2016, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Pre-1999 Gross LS (left axis)" 3 "Pre-1999 Net LS (right axis)"))
graph export "net_LS_aug_pre1999.png", width(1400) height(1000) replace


twoway (line LS_ESI_aug year, 				lcolor(blue)) || ///
	   (line XBLS_ESI_aug year, 			lcolor(blue) lpattern(dash)) || ///
	   (line LS_ESI_aug_NET year, 			lcolor(green) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0.56(0.02)0.66, axis(2) labsize(medium))) || ///
	   (line XBLS_ESI_aug_NET year, 		lcolor(green) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2016, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Post-2013 Gross LS (left axis)" 3 "Post-2013 Net LS (right axis)"))
graph export "net_LS_aug_post2013.png", width(1400) height(1000) replace


twoway (line LS_ES1 year, 				lcolor(green)) || ///
	   (line LS_ES2 year, 				lcolor(orange)) || ///
	   (line LS_ES3 year, 				lcolor(magenta)) || ///
	   (line LS_ES4 year, 				lcolor(blue)) || ///
	   (line XBLS_ES1 year, 			lcolor(green) lpattern(dash)) || ///
	   (line XBLS_ES2 year, 			lcolor(orange) lpattern(dash)) || ///
	   (line XBLS_ES3 year, 			lcolor(magenta) lpattern(dash)) || ///
	   (line XBLS_ES4 year, 			lcolor(blue) lpattern(dash)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium)) xtitle("") xlabel(1947(3)2016, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(4 "{&chi}=1, BEA LS" 2 "{&chi}=0.38, R&D Cost Structure" 3 "{&chi}=0.5, McGrattan & Prescott (2010)" 1 "{&chi}=0" ))
graph export "LS_x.png", width(1400) height(1000) replace


twoway (line CS_ESI_aug year, 				lcolor(blue)) || ///
	   (line XBCS_ESI_aug year, 			lcolor(blue) lpattern(dash)) || ///
	   (line CS_ESI_nIPP_aug year, 			lcolor(green) ylabel(0.4(0.02)0.52, axis(1) labsize(medium))) || ///
	   (line XBCS_ESI_nIPP_aug year, 		lcolor(green) lpattern(dash)) || ///
	   (line CS_ESI_IPP_aug year, 			lcolor(magenta) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0(0.02)0.12, axis(2) labsize(medium))) || ///
	   (line XBCS_ESI_IPP_aug year, 		lcolor(magenta) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) xlabel(1947(3)2016, labsize(medium) angle(90)) xtitle("") ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA Capital Share (left axis)" 3 "Tangible Capital Share (left axis)" 5 "IPP Capital Share (right axis)" ))
graph export "CS_IPP_aug.png", width(1400) height(1000) replace


twoway (line CS_ESIx_aug year, 				lcolor(blue)) || ///
	   (line XBCS_ESIx_aug year, 			lcolor(blue) lpattern(dash)) || ///
	   (line CS_ESIx_nIPP_aug year, 		lcolor(green) ylabel(0.4(0.02)0.52, axis(1) labsize(medium))) || ///
	   (line XBCS_ESIx_nIPP_aug year, 		lcolor(green) lpattern(dash)) || ///
	   (line CS_ESIx_IPP_aug year, 			lcolor(magenta) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0(0.02)0.12, axis(2) labsize(medium))) || ///
	   (line XBCS_ESIx_IPP_aug year, 		lcolor(magenta) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) xlabel(1947(3)2016, labsize(medium) angle(90)) xtitle("") ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA Capital Share (left axis)" 3 "Tangible Capital Share (left axis)" 5 "IPP Capital Share (right axis)" ))
graph export "CS_IPP_x_aug.png", width(1400) height(1000) replace

