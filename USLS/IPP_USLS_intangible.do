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
// IMPORT DATA FROM CORRADO ET AL. 
import excel "IPP_USLS_DATA.xlsx", sheet("Corrado et al") cellrange(A1:K39) firstrow clear
save corrado_et_al.dta, replace


// IMPORT BEA DATA
import excel "IPP_USLS_DATA.xlsx", sheet("NA_Aggregate") cellrange(A1:BM119) firstrow clear
merge 1:1 year using corrado_et_al.dta, nogen

drop if year<1929

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
egen I_ESI_Nres = rsum(IP_EQ_Nres	IP_ST_Nres	IP_IPP		IG_EQ_Nres	IG_ST_Nres	IG_IPP)


// CORRADO ET AL MEASURES ARE AVAILABLE FROM 1977 TO 2014, AND ONLY FOR THE PRIVATE SECTOR.
// WE COMPARE THE PRIVATE SOFTWARE AND R&D MEASURES IN BEA WITH THOSE OF CORRADO FOR THE OVERLAPPING PERIOD.
gen IP_SFT_BEA 		= IP_Software
gen IP_RND_BEA 		= IP_RD
gen IP_ENT_BEA 		= IP_Ent
gen IP_SFTRND_BEA 	= (IP_Software + IP_RD)
gen IP_SFT_COR		= Software/1000
gen IP_RND_COR		= RND/1000
gen IP_SFTRND_COR 	= (Software + RND)/1000
gen ratio_SFTRND 	= IP_SFTRND_COR/IP_SFTRND_BEA


// COMPARE TOTAL PRIVATE INTANGIBLE IN CURRENT NA AND INTANGIBLE NOT IN CURRENT NA.
gen IP_NA_BEA 		= IP_SFT_BEA + IP_RND_BEA +	IP_ENT_BEA
gen IP_NONNA		= (NewFNI + Design +	Brand +	Training + OrganizationalK)/1000	if year>1976 & year<2015
gen IP_TOTAL		= IP_NA_BEA + IP_NONNA												if year>1976 & year<2015
gen ratio_IP_NA_IP_NONNA 	= IP_NA_BEA/IP_NONNA


// COMPARE TOTAL INTANGIBLE IN CURRENT NA AND INTANGIBLE NOT IN CURRENT NA.
gen I_NA_BEA 		= IP_NA_BEA + IG_IPP
gen I_NONNA  		= IP_NONNA
gen I_TOTAL  		= I_NA_BEA + I_NONNA
gen ratio_I_NA_IP_NONNA 	= I_NA_BEA/I_NONNA


twoway (line ratio_IP_NA_IP_NONNA		year if year>1976 & year<2015, 	lcolor(ltblue) lwidth(vvthick))               || ///
	   (line ratio_I_NA_IP_NONNA     	year if year>1976 & year<2015, 	lcolor(black)  lwidth(vvthick) ), ///
	   scheme(s1color) ytitle("") ylabel(0(.1)1, labsize(large)) xtitle("") xlabel(1977(2)2015, labsize(large) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(6) ring(0) col(1) size(large)  ///
	   order(1 "Ratio of IPP to Intangibles not in NA (Only private)" 2 "Ratio of IPP to Intangibles not in NA") )
graph export "Ratio_to_Private_Corrado.png", width(1400) height(1000) replace


ss
// IMPUTE THE BEA-CORRADO RATIO BACK IN 1929
regress ratio_I_NA_IP_NONNA year
predict xb_ratio_I_NA_IP_NONNA
gen	I_NONNA_IMP		= I_NA_BEA/xb_ratio_I_NA_IP_NONNA
gen I_TOTAL_IMP 	= I_NONNA_IMP + I_NA_BEA


/*********** SNA08 LS ************/
gen LS_ESI 			= CE/(GDP - Tax + Sub - PI)

/*********** PRE-SNA93 LS ************/
gen Delta_ES 	= IP_IPP - I_NP_RD + DEP_NP_RD + DEP_KG_IPP
gen LS_ES 		= CE/(GDP - Tax + Sub - PI - Delta_ES)

/*********** CORRADO LS ************/
gen LS_COR 		= CE/ (GDP - Tax + Sub - PI - Delta_ES + I_TOTAL_IMP)

gen tt = _n
gen ln_LS_COR = ln(LS_COR)
reg ln_LS_COR tt

regress LS_ESI year
predict XBLS_ESI
regress LS_ES year
predict XBLS_ES
regress LS_COR year
predict XBLS_COR
twoway (line   	LS_ESI 			year, 				lcolor(blue)   lwidth(vthick))               || ///
	   (line 	XBLS_ESI 		year, 				lcolor(blue)   lwidth(thick) lpattern(dash)) || ///
	   (line   	LS_ES 			year, 				lcolor(orange) lwidth(vthick))               || ///
	   (line 	XBLS_ES 		year, 				lcolor(orange) lwidth(thick) lpattern(dash)) || ///
	   (line   	LS_COR 			year, 				lcolor(black)  lwidth(vthick))               || ///
	   (line 	XBLS_COR 		year, 				lcolor(black)  lwidth(thick) lpattern(dash) ), ///
	   scheme(s1color) ytitle("") ylabel(0.55(0.05)0.75, labsize(large)) xtitle("") xlabel(1929(3)2019, labsize(large) angle(90)) ///
	   legend(region(lwidth(none) fcolor(none)) pos(8) ring(0) col(1) size(large)  ///
	   order(1 "BEA LS" 3 "Pre-1999 Revision Accounting LS" 5 "LS with Broader Intangible Investment") )
graph export "LS_corrado.png", width(1400) height(1000) replace
