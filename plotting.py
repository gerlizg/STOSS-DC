# -*- coding: utf-8 -*-
"""
Created on Mon Apr 22 16:25:51 2024

@author: Principal
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

#--------------------------------
#Configurations of the graphs
#--------------------------------
font = {'family' : "Times New Roman",
       'weight' : 'normal',
       'size'   : 30  }

plt.rc('font', **font)
plt.rc('legend',fontsize=30) # using a size in points
plt.rcParams['lines.linewidth'] = 4
plt.rcParams['lines.linestyle'] = '-'
plt.rcParams["figure.figsize"] = [24, 16]
plt.rcParams["figure.autolayout"] = True


#--------------------------------
#Reading the file from matlab
#--------------------------------
data = pd.read_excel(r'hysteresis_data.xlsx')
data = data.astype('float32')

data = data.iloc[:,:]
data = data.astype('float32').values

x = data[:,1]
y = data[:,0]
plt.plot(x, y, color = "#00777b")

'''
#--------------------------------
#Plotting
#--------------------------------
fig, ax = plt.subplots()
cmap = plt.get_cmap('magma')
reversed_map = cmap.reversed() 
im = ax.imshow(data, cmap = reversed_map)
fig.colorbar(im, ax=ax, orientation="horizontal", location='bottom',  pad=0.04)

# We want to show all ticks...
ax.set_xticks(np.arange(len(percents)))
ax.set_yticks(np.arange(len(iteration_names)))
# ... and label them with the respective list entries
ax.set_xticklabels(percents)
ax.set_yticklabels(iteration_names)

# Turn spines off and create white grid.
for edge, spine in ax.spines.items():
    spine.set_visible(False)
        
# Rotate the tick labels and set their alignment.
plt.setp(ax.get_xticklabels(), rotation=45, ha="right",
         rotation_mode="anchor")

# Loop over data dimensions and create text annotations.
for i in range(len(iteration_names)):
    for j in range(len(percents)):
        text = ax.text(j, i, data[i, j],
                       ha="center", va="center", color="b")

ax.set_title("Cation diffusion evolution of Li+ ions in a Hybrane polymer")
fig.tight_layout()
plt.savefig('diffusion of lithiums ions'+ '.png')    
plt.show()
'''
