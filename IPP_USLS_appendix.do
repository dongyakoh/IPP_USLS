/***************************************************************
THIS PROGRAM GENERATES FIGURES IN THE APPENDIX OF 
"LABOR SHARE DECLINE AND INTELLECTUAL PROPERTY PRODUCTS CAPITAL"
BY DONGYA KOH, RAUL SANTAEULALIA-LLOPIS, AND YU ZHENG.
CREATED BY DONGYA KOH, 6/30/2018
***************************************************************/

clear
clear matrix
set more off,permanently


cd "C:\Users\Don Koh\Dropbox\My_Documents\IPP\Data\IPP_USLS_Data_Codes" 	// FOLDER WHERE GRAPHS ARE STORED


*-------------------------------------------------------------------------------  
*-------------------------------------------------------------------------------  
* IMPORT VINTAGE DATA AND SAVE
import excel "IPP_USLS_VINTAGE.xlsx", sheet("vintage_data") cellrange(A1:Q117) firstrow clear
drop if year<1947 | year>2016
save vintage.dta, replace


* IMPORT MAIN DATA
import excel "IPP_USLS_DATA.xlsx", sheet("Data") cellrange(A1:BL117) firstrow clear

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

gen sY_EQ 		= I_EQ/GNP
gen sY_ST 		= I_ST/GNP
gen sY_IPP 		= I_IPP/GNP
gen sY_Soft 	= I_Soft/GNP
gen sY_RD 		= I_RD/GNP
gen sY_Ent 		= I_Ent/GNP


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




******************************************
* 	HISTORICAL PERSPECTIVE: FROM 1929 TO 2016
******************************************
twoway (line sI_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line sI_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line sI_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Share of Aggregate Investment") ylabel(0(0.1)0.8,labsize(medsmall)) xtitle("") xlabel(1901(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(6) ring(1) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invshares_1901_2016_type.png", width(1400) height(1000) replace


drop if year<1929
regress LS_ESI_aug ttrend if year>=1929 & year<=2016
predict XBLS_ESI_aug if LS_ESI_aug!=.
regress LS_ESS_aug ttrend if year>=1929 & year<=2016
predict XBLS_ESS_aug if LS_ESS_aug!=.
regress LS_ES_aug ttrend if year>=1929 & year<=2016
predict XBLS_ES_aug if LS_ES_aug!=.
di _b[ttrend]*70
twoway (line LS_ESI_aug year, 			lcolor(blue)) || ///
	   (line XBLS_ESI_aug year, 		lcolor(blue) lpattern(dash)) || ///
	   (line LS_ESS_aug year, 			lcolor(magenta)) || ///
	   (line XBLS_ESS_aug year, 		lcolor(magenta) lpattern(dash)) || ///	   
	   (line LS_ES_aug year, 			lcolor(orange)) || ///
	   (line XBLS_ES_aug year, 			lcolor(orange) lpattern(dash)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medsmall) angle(90)) ///
	   xtitle("") xlabel(1929(3)2016, labsize(medsmall) angle(90)) ///
	   legend(pos(11) ring(0) col(1) size(medsmall) order(1 "BEA LS" 5 "Pre-1999 Revision Accounting LS" 3 "Pre-2013 Revision Accounting LS"))
graph export "LS_1929_2016_aug.png", width(1400) height(1000) replace




****************************************************
* INVESTMENT LEVEL
****************************************************	   
drop if year<1947
twoway (line I_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line I_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line I_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Billions of USD, Nominal") ylabel(,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(11) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "inv_type.png", width(1400) height(1000) replace


twoway (line I_Soft year, lcolor(green) lpattern(solid)) ///
	   (line I_RD year, lcolor(pink) lpattern(dash)) ///
	   (line I_Ent year, lcolor(cyan) lpattern(shortdash)), ///
	   scheme(s1color) ytitle("Billions of USD, Nominal") xtitle("") ylabel(, labsize(medsmall)) xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(pos(12) row(1) ring(0) size(medsmall) order(1 "Software" 2 "R&D" 3 "Artistic Originals"))  
graph export "inv_IPPtype.png", width(1400) height(1000) replace


****************************************************
* INVESTMENT SHARE
****************************************************	   
twoway (line sI_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line sI_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line sI_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Share of Aggregate Investment") ylabel(0(0.1)0.6,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(6) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invshares_type.png", width(1400) height(1000) replace


twoway (line sI_Soft year, lcolor(green) lpattern(solid)) ///
	   (line sI_RD year, lcolor(pink) lpattern(dash)) ///
	   (line sI_Ent year, lcolor(cyan) lpattern(shortdash)), ///
	   scheme(s1color) ytitle("Share of Aggregate Investment") xtitle("") ylabel(0(0.02)0.16, labsize(medsmall)) xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(pos(12) row(1) ring(0) size(medsmall) order(1 "Software" 2 "R&D" 3 "Artistic Originals"))  
graph export "invshares_IPPtype.png", width(1400) height(1000) replace


****************************************************
* INVESTMENT SHARE OF GNP
****************************************************	   
twoway (line sY_ST  year, lcolor(lime) lpattern(shortdash)) ///
	   (line sY_EQ  year, lcolor(ebblue) lpattern(dash)) ///
       (line sY_IPP year, lcolor(black) lpattern(solid)), ///
	   scheme(s1color)  ytitle("Share of GNP") ylabel(0(0.05)0.15,labsize(medsmall)) xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(size(medsmall) rows(1) pos(6) ring(0) order(1 "Structures" 2 "Equipment" 3 "IPP" ))
graph export "invsharesY_type.png", width(1400) height(1000) replace


twoway (line sY_Soft year, lcolor(green) lpattern(solid)) ///
	   (line sY_RD year, lcolor(pink) lpattern(dash)) ///
	   (line sY_Ent year, lcolor(cyan) lpattern(shortdash)), ///
	   scheme(s1color) ytitle("Share of GNP") xtitle("") ylabel(0(0.01)0.04, labsize(medsmall)) xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(pos(12) row(1) ring(0) size(medsmall) order(1 "Software" 2 "R&D" 3 "Artistic Originals"))  
graph export "invsharesY_IPPtype.png", width(1400) height(1000) replace




****************************************************
* VINTAGE LS
****************************************************	   
merge 1:1 year using vintage.dta
gen LS_2013_DG 			= LS_20130926*GNPA_20130328/(GNPA_20130328 + YKD_ESS + YKG_ESS)
gen LS_1999_DG 			= LS_19990930*GNPA_19990331/(GNPA_19990331 + YKD_ES + YKG_ES)
egen mean_LS_ESS_aug 	= mean(LS_ESS_aug)
egen mean_LS_ES_aug 	= mean(LS_ES_aug)
egen mean_LS_2013_DG 	= mean(LS_2013_DG)
egen mean_LS_1999_DG 	= mean(LS_1999_DG)

gen LS_2013_DG_norm 	= LS_2013_DG - (mean_LS_2013_DG - mean_LS_ESS_aug)
gen LS_1999_DG_norm		= LS_1999_DG - (mean_LS_1999_DG - mean_LS_ES_aug)
regress LS_2013_DG_norm ttrend if year<=2016
predict XBLS_2013_DG if LS_2013_DG_norm!=.
regress LS_1999_DG_norm ttrend if year<=2016
predict XBLS_1999_DG if LS_1999_DG_norm!=.

drop XBLS_ESS_aug XBLS_ES_aug
regress LS_ESS_aug ttrend if year<=2016
predict XBLS_ESS_aug if LS_ESS_aug!=.
regress LS_ES_aug ttrend if year<=2016
predict XBLS_ES_aug if LS_ES_aug!=.

twoway (line LS_ESS_aug year, 			lcolor(magenta)) || ///
	   (line XBLS_ESS_aug year, 		lcolor(magenta) lpattern(dash)) || ///
	   (line LS_2013_DG_norm year, 		lcolor(green)) || ///
	   (line XBLS_2013_DG year, 		lcolor(green) lpattern(dash)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medsmall) angle(90)) ///
	   xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(pos(11) ring(0) col(1) size(medsmall) order(1 "Counterfactual Accounting LS" 3 "Vintage LS"))
graph export "LS_aug_2013vintage.png", width(1400) height(1000) replace

twoway (line LS_ES_aug year, 			lcolor(orange)) || ///
	   (line XBLS_ES_aug year, 		lcolor(orange) lpattern(dash)) || ///
	   (line LS_1999_DG_norm year, 		lcolor(cyan)) || ///
	   (line XBLS_1999_DG year, 		lcolor(cyan) lpattern(dash)), ///
	   scheme(s1color) ytitle("Labor Share") ylabel(0.48(0.02)0.58, labsize(medsmall) angle(90)) ///
	   xtitle("") xlabel(1947(3)2016, labsize(medsmall) angle(90)) ///
	   legend(pos(11) ring(0) col(1) size(medsmall) order(1 "Counterfactual Accounting LS" 3 "Vintage LS"))
graph export "LS_aug_1999vintage.png", width(1400) height(1000) replace
