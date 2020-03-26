/***************************************************************
THIS PROGRAM GENERATES x VALUES FOR FIGURE 8(b) 
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
import excel "IPP_USLS_DATA.xlsx", sheet("NA_Aggregate") cellrange(A1:BM119) firstrow clear
drop if year<1929
replace IP_IPP 	= IP_Soft + IP_RD + IP_Ent
egen I_EQ 		= rsum(IP_EQ_Nres 	IG_EQ_Nres	IP_EQ_Res)
egen I_ST 		= rsum(IP_ST_Nres 	IG_ST_Nres	IP_ST_Res IG_ST_Res)
egen I_IPP 		= rsum(IP_IPP 		IG_IPP)
gen LS_ESI 		= CE/(GDP - Tax + Sub - PI)
gen LS_ES 		= CE/(GDP - Tax + Sub - PI - I_IPP)

gen tt 			= _n
save ls_for_chi.dta, replace


// SET LEVELS AND TRENDS OF CHI FOR EXPERIMENTS
drop _all
local level_u	= 1
local level_l	= 0
local level_n	= 100
local slope_u	= 0.006
local slope_l	= -0.001
local slope_n	= 100
local nobs 		= `level_n' * `slope_n'

set obs `nobs'
gen tt 			= _n
merge 1:1 tt using ls_for_chi.dta, nogen keepusing(I_IPP LS_ESI GDP SDis CE PI Tax Sub)



*******************************************************
// LS WITH DIFFERENT LEVELS AND TRENDS OF CHI
gen chi_inv_level 	= .
gen chi_inv_slope 	= .
gen ls_trend 		= .
gen ls_trend_ciu95 	= .
gen ls_trend_cil95 	= .
gen ls_trend_ciu99 	= .
gen ls_trend_cil99 	= .
local k = 1
forvalues i = 1(1)`level_n'{
forvalues j = 1(1)`slope_n'{
	local 	alpha 	= `level_l' + (`i'-1)*(`level_u'-`level_l')/(`level_n'-1)
	local 	beta 	= `slope_l' + (`j'-1)*(`slope_u'-`slope_l')/(`slope_n'-1)
	gen 	chi_inv_`k' 	= `alpha' + `beta'*(tt-1) if tt<91
	gen LS_`k' 		= (CE +  chi_inv_`k'*I_IPP) / (GDP - Tax + Sub - PI)
	replace chi_inv_level 	= `alpha' in `k'
	replace chi_inv_slope 	= `beta' in `k'
	gen ln_LS_`k' = ln(LS_`k')
	reg ln_LS_`k' tt if tt<91
	predict XBLS_`k'
	replace chi_inv_`k' = 1 if chi_inv_`k'>1
	replace chi_inv_`k' = 0 if chi_inv_`k'<0
	sum chi_inv_`k'
	replace ls_trend 		= _b[tt] in `k' 
	replace ls_trend_ciu95 	= (_b[tt] + invttail(e(df_r),0.025)*_se[tt]) in `k' 
	replace ls_trend_cil95 	= (_b[tt] - invttail(e(df_r),0.025)*_se[tt]) in `k' 
	replace ls_trend_ciu99 	= (_b[tt] + invttail(e(df_r),0.005)*_se[tt]) in `k' 
	replace ls_trend_cil99 	= (_b[tt] - invttail(e(df_r),0.005)*_se[tt]) in `k' 
	drop chi_inv_`k' ln_LS_`k' LS_`k' XBLS_`k'
	local ++k
}
}
save ls_chi.dta, replace


// EXPORT THE EXPERIMENTED DATA
use ls_chi.dta, clear
export delimited tt chi_inv_level chi_inv_slope ls_trend ls_trend_ciu95 ls_trend_cil95 ls_trend_ciu99 ls_trend_cil99 using "chi_values.csv", nolabel datafmt replace
