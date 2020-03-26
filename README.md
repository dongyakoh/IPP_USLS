# IPP USLS
Data files and STATA codes for "Labor Share Decline and Intellectual Property Products Capital" 
by Dongya Koh, Raul Santaeulalia-Llopis, and Yu Zheng.
Created by Dongya Koh on March 26, 2020.

This directory contains the following contents:


In "USLS" folder
1. “IPP_USLS_DATA.xlsx" in a spread sheet format contains all the variables used in the paper retrieved from the BEA on Sep. 25, 2019.
2. “corrado_et_al.dta" in a Stata dataset format contains all the intangible data provided by Corrado et. al (2009).
3. "IPP_USLS_main.do" in a Stata do-file format imports data from "IPP_USLS_DATA.xlsx," and computes US labor share and main figures in the paper.
4. "IPP_USLS_sector.do" in a Stata do-file format imports data from "IPP_USLS_CORP_DATA.xlsx," and generates figures for the section on institutional sectors (Section 3).
5. "IPP_USLS_intangible.do"  in a Stata do-file format imports data from “corrado_et_al.dta" and plots figures with broader intangible capital (Section 3).
6. "IPP_USLS_chi.do" in a Stata do-file format generates labor share with different values for chi (Section 5). 
7. "plot_chi_contour.py" in a python code format that generates Figure 8 (b) in the paper using the simulated labor share with different values of chi generated from "IPP_USLS_chi.do."
8. "IPP_USLS_appendix.do" in a Stata do-file format generates figures in the Appendix. 
9. "raw_data" folder contains all the NIPA tables and FAT tables that we use for the paper, retrieved on Sep. 25, 2019.


In "International" folder
1. "CAN" folder contains national accounts data for Canada and a do-file that generates figures in the paper and appendix.
2. "DNK" folder contains national accounts data for Denmark and a do-file that generates figures in the paper and appendix.
3. "FRA" folder contains national accounts data for France and a do-file that generates figures in the paper and appendix.
4. "JPN" folder contains national accounts data for Japan and a do-file that generates figures in the paper and appendix.
5. "SWE" folder contains national accounts data for Sweden and a do-file that generates figures in the paper and appendix.


