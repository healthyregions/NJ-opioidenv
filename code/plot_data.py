#put this in the same folder as table file
#relative file path

import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import math
FNAME = 'mun_master.csv'

df = pd.read_csv(FNAME)

#Datatable general
print('\n\nDimension of table:', df.shape)
print('\n\t----- Number of NAs -----')
print(df.isna().sum())

#plot histograms
attrs = range(4, df.shape[1]) #attributes to plot: skip the first three columns
nrows = math.ceil(len(attrs)/5) #plot with five figs per line
fig, axes = plt.subplots(nrows, 5, figsize = (20, 4*nrows))
axes = axes.flatten()
j = 0
for attr in attrs:
    ax = axes[j]
    j += 1
    a = ax.hist(df.iloc[:, attr], bins = 30)
    a = ax.set_xlabel(str(df.columns[attr]))
plt.savefig('hists.png', dpi = 300)

#plot correlation 
corr = df.iloc[:, [3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]].corr() #selected rows
mask = np.triu(np.ones_like(corr, dtype=bool)) #Mask for the upper triangle
f, ax = plt.subplots(figsize=(11, 9)) # Set up the matplotlib figure
cmap = sns.diverging_palette(230, 20, as_cmap=True) # Custom diverging colormap
sns.heatmap(corr, mask=mask, cmap=cmap, vmax=.3, center=0, square=True, linewidths=.5, cbar_kws={"shrink": .5})# heatmap with the mask and correct aspect ratio
plt.savefig('heatmap.png', dpi = 300)
