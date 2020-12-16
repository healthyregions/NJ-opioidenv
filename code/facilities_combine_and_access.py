import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
import math

dfs = []
fnames = ['nj_art_galleries_geocoded.csv', 'nj_cultural_centers_geocoded.csv', 'nj_museums_geocoded.csv', \
              'nj_naloxone_pharmacies_geocoded.csv', 'nj_syringe_exchange_geocoded.csv']
colnames = ['Art Gallery', 'Cultural Center', 'Museum', 'Naloxone Pharmacy', 'Syringe Exchange Program']
for fname, colname in zip(fnames, colnames):
    df = pd.read_csv("data_raw/" + fname)
    df['Category'] = colname
    dfs.append(df)

df_final = pd.concat(dfs, axis = 1)

#access code go here...