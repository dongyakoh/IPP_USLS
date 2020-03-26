/***************************************************************
THIS PROGRAM GENERATES FIGURES IN THE APPENDIX OF 
"LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
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
* IMPORT VINTAGE DATA AND SAVE
import excel "IPP_USLS_DATA.xlsx", sheet("NA_Vintage") cellrange(A1:F91) firstrow clear
drop if year<1929 | year>2018
save vintage.dta, replace


* IMPORT MAIN DATA
import excel "IPP_USLS_DATA.xlsx", sheet("NA_Aggregate") cellrange(A1:BM119) firstrow clear

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

gen sI_EQ 		= I_EQ/I_ESI
gen sI_ST 		= I_ST/I_ESI
gen sI_IPP 		= I_IPP/I_ESI
gen sI_Soft 	= I_Soft/I_ESI
gen sI_RD 		= I_RD/I_ESI
gen sI_Ent 		= I_Ent/I_ESI

gen sY_EQ 		= I_EQ/GDP
gen sY_ST 		= I_ST/GDP
gen sY_IPP 		= I_IPP/GDP
gen sY_Soft 	= I_Soft/GDP
gen sY_RD 		= I_RD/GDP
gen sY_Ent 		= I_Ent/GDP



/*********** POST-2013 ************/
gen LS_ESI 		= CE/(GDP - Tax + Sub - PI)


/*********** PRE-1999 ************/
gen Delta_ES 	= IP_IPP - I_NP_RD + DEP_NP_RD + DEP_KG_IPP
gen LS_ES 		= CE/(GDP - Tax + Sub - PI - Delta_ES)


/*********** PRE-2013 ************/
gen Delta_ESS 	= IP_RD + IP_Ent - I_NP_RD + DEP_NP_RD + DEP_KG_RD
gen LS_ESS 		= CE/(GDP - Tax + Sub - PI - Delta_ESS)





drop if year<1929
****************************************************
* INVESTMENT LEVEL
****************************************************	
twoway (line I_ST  year, 	lcolor(magenta) lpattern(shortdash) lwidth(medthick)) ///
	   (line I_EQ  year, 	lcolor(green) lpattern(dash) lwidth(medthick)) ///
       (line I_IPP year, 	lcolor(black) lpattern(solid) lwidth(medthick)), ///
	   scheme(s1color)  ytitle("Billions of USD, Nominal") ylabel(,labsize(medium)) xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) size(medium) rows(1) pos(12) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "inv_type_1901_2018.png", width(1400) height(1000) replace


twoway (line sI_ST  year, 	lcolor(magenta) lpattern(shortdash) lwidth(medthick)) ///
	   (line sI_EQ  year, 	lcolor(green) lpattern(dash) lwidth(medthick)) ///
       (line sI_IPP year, 	lcolor(black) lpattern(solid) lwidth(medthick)), ///
	   scheme(s1color)  ytitle("Share of Aggregate Investment") ylabel(0(0.1)0.9,labsize(medium)) xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) size(medium) rows(1) pos(12) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invshares_type_1901_2018.png", width(1400) height(1000) replace


****************************************************
* INVESTMENT SHARE
****************************************************
twoway (line I_Soft year, 	lcolor(dkgreen) lpattern(solid) lwidth(medthick)) ///
	   (line I_RD year, 	lcolor(pink) lpattern(dash) lwidth(medthick)) ///
	   (line I_Ent year, 	lcolor(cyan) lpattern(shortdash) lwidth(medthick)), ///
	   scheme(s1color) ytitle("Billions of USD, Nominal") xtitle("") ylabel(, labsize(medium)) xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) row(1) ring(0) size(medium) order(1 "Software" 2 "R&D" 3 "Artistic Originals"))  
graph export "inv_IPPtype_1901_2018.png", width(1400) height(1000) replace


twoway (line sI_Soft year, 	lcolor(dkgreen) lpattern(solid) lwidth(medthick)) ///
	   (line sI_RD year, 	lcolor(pink) lpattern(dash) lwidth(medthick)) ///
	   (line sI_Ent year, 	lcolor(cyan) lpattern(shortdash) lwidth(medthick)), ///
	   scheme(s1color) ytitle("Share of Aggregate Investment") xtitle("") ylabel(0(0.02)0.16, labsize(medium)) xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) row(1) ring(0) size(medium) order(1 "Software" 2 "R&D" 3 "Artistic Originals"))  
graph export "invshares_IPPtype_1901_2018.png", width(1400) height(1000) replace


****************************************************
* INVESTMENT SHARE OF GDP
****************************************************	
twoway (line sY_ST  year, lcolor(magenta) lpattern(shortdash) lwidth(medthick)) ///
	   (line sY_EQ  year, lcolor(green) lpattern(dash) lwidth(medthick)) ///
       (line sY_IPP year, lcolor(black) lpattern(solid) lwidth(medthick)), ///
	   scheme(s1color)  ytitle("Share of GDP") ylabel(0(0.03)0.18,labsize(medium)) xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) size(medium) rows(1) pos(12) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invsharesY_type_1929_2018.png", width(1400) height(1000) replace


twoway (line sY_Soft year, lcolor(dkgreen) lpattern(solid) lwidth(medthick)) ///
	   (line sY_RD year, lcolor(pink) lpattern(dash) lwidth(medthick)) ///
	   (line sY_Ent year, lcolor(cyan) lpattern(shortdash) lwidth(medthick)), ///
	   scheme(s1color) ytitle("Share of GDP") xtitle("") ylabel(0(0.01)0.04, labsize(medium)) xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(12) row(1) ring(0) size(medium) order(1 "Software" 2 "R&D" 3 "Artistic Originals"))  
graph export "invsharesY_IPPtype_1929_2018.png", width(1400) height(1000) replace



****************************************************
* VINTAGE LS
****************************************************	   
merge 1:1 year using vintage.dta
*gen LS_2013_vintage		= CEA_20130228/(GDPA_20130328 - TAXA_20130228 + SUBA_20130328)
*gen LS_1999_vintage 	= CEA_20130228/(GDPA_19990331 - TAXA_20130228 + SUBA_20130328)
gen LS_2013_vintage		= CE/(GDPA_20130328 - Tax + Sub - PI)
gen LS_1999_vintage 	= CE/(GDPA_19990331 - Tax + Sub - PI)

egen mean_LS_ESS 			= mean(LS_ESS)
egen mean_LS_ES 			= mean(LS_ES)
egen mean_LS_2013_vintage 	= mean(LS_2013_vintage)
egen mean_LS_1999_vintage 	= mean(LS_1999_vintage)

gen LS_2013_vintage_norm 	= LS_2013_vintage - (mean_LS_2013_vintage - mean_LS_ESS)
gen LS_1999_vintage_norm	= LS_1999_vintage - (mean_LS_1999_vintage - mean_LS_ES)
regress LS_2013_vintage_norm ttrend if year<=2013
predict XBLS_2013_vintage if LS_2013_vintage_norm!=.
regress LS_1999_vintage_norm ttrend if year<=1999
predict XBLS_1999_vintage if LS_1999_vintage_norm!=.

regress LS_ESS ttrend if year<=2018
predict XBLS_ESS if LS_ESS!=.
regress LS_ES ttrend if year<=2018
predict XBLS_ES if LS_ES!=.

twoway (line LS_ESS year, 					lcolor(magenta) lwidth(medthick)) || ///
	   (line XBLS_ESS year, 				lcolor(magenta) lpattern(dash) lwidth(medthick)) || ///
	   (line LS_2013_vintage_norm year, 	lcolor(midgreen) lwidth(medthick)) || ///
	   (line XBLS_2013_vintage year, 		lcolor(midgreen) lpattern(dash) lwidth(medthick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.55(0.05)0.8, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Counterfactual Pre-SNA08 LS" 3 "Pre-SNA08 Vintage LS"))
graph export "LS_aug_2013vintage.png", width(1400) height(1000) replace

twoway (line LS_ES year, 					lcolor(orange) lwidth(medthick)) || ///
	   (line XBLS_ES year, 					lcolor(orange) lpattern(dash) lwidth(medthick)) || ///
	   (line LS_1999_vintage_norm year, 	lcolor(purple) lwidth(medthick)) || ///
	   (line XBLS_1999_vintage year, 		lcolor(purple) lpattern(dash) lwidth(medthick)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.55(0.05)0.8, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1929(3)2018, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Counterfactual Pre-SNA93 LS" 3 "Pre-SNA93 Vintage LS"))
graph export "LS_aug_1999vintage.png", width(1400) height(1000) replace




****************************************************
* AUGMENTED LS
****************************************************	
drop if year<1947
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
gen LS_ESI_aug	= 1 - YK_ESI / GNP_ESI
gen YK_ESI_NET  = YK_ESI - DEP_ESI
gen GNP_ESI_NET = GNP - DEP_ESI
gen LS_ESI_NET	= 1 - YK_ESI_NET / GNP_ESI_NET


/*********** PRE-1999 ************/
gen r_ES 		= (YKP_ESI - CFC) / KP_ES
gen YKD_ES 		= (r_ES + dep_CD)*CD
gen YKG_ES 		= r_ES*KG_ES
gen YK_ES     	= YKP_ESI + YKD_ES + YKG_ES - Delta_ES
gen GNP_ES 		= GNP + YKD_ES + YKG_ES - Delta_ES
gen LS_ES_aug	= 1 - YK_ES / GNP_ES
gen YK_ES_NET  	= YK_ESI - Delta_ES - DEP_ES
gen GNP_ES_NET 	= GNP - Delta_ES - DEP_ES
gen LS_ES_NET	= 1 - YK_ES_NET / GNP_ES_NET


/*********** PRE-2013 ************/
gen r_ESS 		= (YKP_ESI - CFC) / KP_ESS
gen YKD_ESS 	= (r_ESS + dep_CD)*CD
gen YKG_ESS 	= r_ESS*KG_ESS
gen YK_ESS     	= YKP_ESI + YKD_ESS + YKG_ESS - Delta_ESS
gen GNP_ESS 	= GNP + YKD_ESS + YKG_ESS - Delta_ESS
gen LS_ESS_aug	= 1 - YK_ESS / GNP_ESS
gen YK_ESS_NET  = YK_ESI - Delta_ESS - DEP_ESS
gen GNP_ESS_NET = GNP - Delta_ESS - DEP_ESS
gen LS_ESS_NET	= 1 - YK_ESS_NET / GNP_ESS_NET


regress LS_ESI_aug ttrend
predict XBLS_ESI_aug
regress LS_ESS_aug ttrend
predict XBLS_ESS_aug
regress LS_ES_aug ttrend
predict XBLS_ES_aug
regress LS_ESI_NET year if year>=1929 & year<=2018
predict XBLS_ESI_NET if LS_ESI_NET!=.
*egen XBLS_ESI_NET = mean(LS_ESI_NET)
regress LS_ES_NET year if year>=1929 & year<=2018
predict XBLS_ES_NET if LS_ES_NET!=.
*egen XBLS_ES_NET 	= mean(LS_ES_NET)

// PLOT FIGURES
twoway (line LS_ESI_aug year, 			lcolor(blue) lwidth(medthick)) || ///
	   (line XBLS_ESI_aug year, 		lcolor(blue) lpattern(dash) lwidth(medthick)) || ///
	   (line LS_ES_aug year, 			lcolor(orange) lwidth(medthick)) || ///
	   (line XBLS_ES_aug year, 			lcolor(orange) lpattern(dash) lwidth(medthick)), ///	   
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2018, labsize(medium) angle(90)) ///
	   legend(symxsize(8) region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS"))
graph export "LS_aug0.png", width(1400) height(1000) replace


twoway (line LS_ESI_aug year, 			lcolor(blue) lwidth(medthick)) || ///
	   (line XBLS_ESI_aug year, 		lcolor(blue) lpattern(dash) lwidth(medthick)) || ///
	   (line LS_ESS_aug year, 			lcolor(magenta) lwidth(medthick)) || ///
	   (line XBLS_ESS_aug year if year>=1960 & year<=2017, 		lcolor(magenta) lpattern(dash) lwidth(medthick)) || ///
	   (line LS_ES_aug year, 			lcolor(orange) lwidth(medthick)) || ///
	   (line XBLS_ES_aug year, 			lcolor(orange) lpattern(dash) lwidth(medthick)), ///	   
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2018, labsize(medium) angle(90)) xline(1960, lcolor(gs12) lwidth(thick)) ///
	   legend(symxsize(8) region(lwidth(none) fcolor(none)) pos(6) ring(0) col(1) size(medium) order(1 "BEA LS" 5 "Pre-1999 Revision Accounting LS" 3 "Pre-2013 Revision Accounting LS"))
graph export "LS_aug1.png", width(1400) height(1000) replace


twoway (line LS_ES_aug year, 				lcolor(orange)) || ///
	   (line XBLS_ES_aug year, 				lcolor(orange) lpattern(dash)) || ///
	   (line LS_ES_NET year, 			lcolor(green) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0.58(0.02)0.68, axis(2) labsize(medium))) || ///
	   (line XBLS_ES_NET year, 			lcolor(green) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.5(0.02)0.6, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Pre-1999 Gross LS (left axis)" 3 "Pre-1999 Net LS (right axis)"))
graph export "net_LS_aug_pre1999.png", width(1400) height(1000) replace


twoway (line LS_ESI year, 				lcolor(blue)) || ///
	   (line XBLS_ESI year, 			lcolor(blue) lpattern(dash)) || ///
	   (line LS_ESI_NET year, 			lcolor(green) yaxis(2) ytitle(, axis(2) size(medium)) ylabel(0.58(0.02)0.68, axis(2) labsize(medium))) || ///
	   (line XBLS_ESI_NET year, 		lcolor(green) lpattern(dash) yaxis(2)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.49(0.02)0.59, labsize(medium) angle(90)) ///
	   xtitle("") xlabel(1947(3)2017, labsize(medium) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(11) ring(0) col(1) size(medium) order(1 "Post-2013 Gross LS (left axis)" 3 "Post-2013 Net LS (right axis)"))
graph export "net_LS_aug_post2013.png", width(1400) height(1000) replace
