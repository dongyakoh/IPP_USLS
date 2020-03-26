#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Feb 22 09:22:17 2020

@author: dkoh
"""

import csv
import numpy as np
import matplotlib.pyplot as plt

from PIL import Image

data = []

with open('chi_values.csv','r') as myFile:
    lines = csv.reader(myFile, delimiter=',')
    for line in lines:
        data.append(line)
#    print(data)
    
    
nslope = 100
nlevel = 100


X_level = np.zeros((nlevel,nslope))
Y_slope = np.zeros((nlevel,nslope))
Z_ls    = np.zeros((nlevel,nslope))
Z_ls_ciu95 = np.zeros((nlevel,nslope))
Z_ls_cil95 = np.zeros((nlevel,nslope))
Z_ls_ciu99 = np.zeros((nlevel,nslope))
Z_ls_cil99 = np.zeros((nlevel,nslope))



k = 1
for j in range(nslope):
    for i in range(nlevel):
        X_level[i,j] =float(data[k][1])
        Y_slope[i,j] = float(data[k][2])
        if data[k][3]=='':
            Z_ls[i,j]       = np.nan
            Z_ls_ciu95[i,j]   = np.nan
            Z_ls_cil95[i,j]   = np.nan
            Z_ls_ciu99[i,j]   = np.nan
            Z_ls_cil99[i,j]   = np.nan
        else:
            Z_ls[i,j] = float(data[k][3])
            Z_ls_ciu95[i,j] = float(data[k][4])
            Z_ls_cil95[i,j] = float(data[k][5])
            Z_ls_ciu99[i,j] = float(data[k][6])
            Z_ls_cil99[i,j] = float(data[k][7])

        k += 1



fs = 14

Y_slope = Y_slope*100


fig, ax = plt.subplots(figsize=(6,4),dpi = 200)
#fig, ax = plt.subplots()
CS1 = ax.contour(X_level, Y_slope, Z_ls,colors='k',levels=0,linewidths=3)
CS21 = ax.contour(X_level, Y_slope, Z_ls_ciu95,colors='k',levels=0,linestyles='dashed')
CS31 = ax.contour(X_level, Y_slope, Z_ls_cil95,colors='k',levels=0,linestyles='dashed')
CS22 = ax.contour(X_level, Y_slope, Z_ls_ciu99,colors='k',levels=0,linestyles='dotted')
CS32 = ax.contour(X_level, Y_slope, Z_ls_cil99,colors='k',levels=0,linestyles='dotted')

# MP (2010)
CS41 = ax.plot((0.5), (0), 'o', color='k', markersize=5)
plt.text(0.5, -0.01, 'MP',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'top'})

# SYZZ (2019)
#CS42 = ax.plot((0.75), (0), 'o', color='k', markersize=5)
#plt.text(0.79, -0.01, 'SYZZ',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'top'})

# LW (2016)
CS43 = ax.plot((0.373), (0.56), 'o', color='k', markersize=5)
CS44 = plt.errorbar((0.373), (0.56), color='k', xerr=0.092, capsize=5)
#CS44 = ax.axhline(y=0, xmin=0.281, xmax=0.465, color='k')
plt.text(0.373, 0.55, 'LW',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'top'})

CS45 = ax.plot((.678243), (-.0000339), 'o', color='k', markersize=5)
plt.text(0.75, -0.015, 'Amb. Rent',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'top'})

CS46 = ax.plot((.5777867), (0.0001843), 'o', color='k', markersize=5)
plt.text(.5777867, 0.01, 'NSF',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'bottom'})


plt.text(0.2, 0.05, 'Decreasing LS',{'color': 'k', 'fontsize': 14, 'fontweight':'bold', 'ha': 'center', 'va': 'top'})
plt.text(0.8, 0.4, 'Increasing LS',{'color': 'k', 'fontsize': 14, 'fontweight':'bold','ha': 'center', 'va': 'top'})

 
CS1.collections[1].set_label('Trendless LS')
CS21.collections[1].set_label('95% CI')
CS22.collections[1].set_label('99% CI')

plt.xlabel('Level of (1-$\chi$)', color = 'black', fontsize=fs)
plt.ylabel('A Linear Growth Rate of (1-$\chi$)', color = 'black', fontsize=fs)
plt.xticks(np.arange(0,1.1,0.1),color = 'black',fontsize = fs)
plt.yticks(np.arange(-0.1, 0.7, 0.1),color = 'black',fontsize = fs)
plt.grid()
ax.xaxis.grid(linestyle=':')
ax.yaxis.grid(linestyle=':')
plt.tight_layout()
plt.legend(loc='upper right')
fig_name = "ls_chi_contour.png"
plt.savefig(fig_name)


im = Image.open(fig_name)
im = im.convert('L')
new_fig_name = "gray_ls_chi_contour.png"
im.save(new_fig_name)


ss
###########################################
###########################################
fs = 10

fig, ax = plt.subplots()
CS1 = ax.contour(X_level, Y_slope, Z_ls,colors='k',levels=0,linewidths=3)
CS5 = ax.contourf(X_level, Y_slope, Z_ls,levels=100,cmap="afmhot")
CS21 = ax.contour(X_level, Y_slope, Z_ls_ciu95,colors='k',levels=0,linestyles='dashed')
CS31 = ax.contour(X_level, Y_slope, Z_ls_cil95,colors='k',levels=0,linestyles='dashed')
CS22 = ax.contour(X_level, Y_slope, Z_ls_ciu99,colors='k',levels=0,linestyles='dotted')
CS32 = ax.contour(X_level, Y_slope, Z_ls_cil99,colors='k',levels=0,linestyles='dotted')

# MP (2010)
CS41 = ax.plot((0.5), (0), 'o', color='white', markersize=5)
plt.text(0.5, -0.0001, 'MP',{'color': 'white', 'fontsize': 14, 'ha': 'center', 'va': 'top'})

# SYZZ (2019)
#CS42 = ax.plot((0.75), (0), 'o', color='k', markersize=5)
#plt.text(0.75, 0.0001, 'SYZZ',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'bottom'})

# LW (2016)
CS43 = ax.plot((0.373), (0.0056), 'o', color='k', markersize=5)
CS44 = plt.errorbar((0.373), (0.0056), color='k', xerr=0.092, capsize=5)
#CS44 = ax.axhline(y=0, xmin=0.281, xmax=0.465, color='k')
plt.text(0.373, 0.0055, 'LW',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'top'})

CS45 = ax.plot((.678243), (-.0000339), 'o', color='k', markersize=5)
plt.text(0.678243, -0.0001, 'KSZ',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'top'})
 
CS46 = ax.plot((.5777867), (0.0001843), 'o', color='k', markersize=5)
plt.text(.5777867, 0, 'NSF',{'color': 'k', 'fontsize': 14, 'ha': 'center', 'va': 'top'})

CS1.collections[1].set_label('Trendless LS')
CS21.collections[1].set_label('95% CI')
CS22.collections[1].set_label('99% CI')
#cmap = clr.LinearSegmentedColormap.from_list(')

plt.xlabel('Level of (1-$\chi$)', color = 'black', fontsize=fs)
plt.ylabel('Slope of (1-$\chi$)', color = 'black', fontsize=fs)
plt.xticks(np.arange(0,1.1,0.1),color = 'black',fontsize = fs)
plt.yticks(np.arange(-0.001, 0.007, 0.001),color = 'black',fontsize = fs)
plt.grid()
ax.xaxis.grid(linestyle=':')
ax.yaxis.grid(linestyle=':')
plt.tight_layout()
plt.legend(loc='upper right')
fig.colorbar(CS5, ax=ax)
fig_name = "ls_chi_contour.png"
plt.savefig(fig_name, dpi = 300)


im = Image.open(fig_name)
im = im.convert('L')
new_fig_name = "gray_ls_chi_contour.png"
im.save(new_fig_name)
