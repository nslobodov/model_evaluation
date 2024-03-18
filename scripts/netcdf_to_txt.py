# -*- coding: utf-8 -*-
"""
Created on Sat Mar 16 20:30:31 2024

@author: Nikita
"""

import xarray as xr
import os


# Path to the directory containing the NetCDF files
directory_path = 'E:/Climate/timmean/'

# Get a list of all NetCDF files in the directory
file_list = [os.path.join(directory_path, file) for file in os.listdir(directory_path) if file.endswith('.nc')]

# Create an empty dictionary
tas_values = {}

# Iterate through each file and extract the 'tas' variable values
for file in file_list:
    ds = xr.open_dataset(file, decode_times=False)
    tas_value = ds['tas'].item()  # Extracting the scalar value
    tas_values[os.path.basename(file.split('_')[4])] = tas_value  # Using the file name as the key

# Print the resulting dictionary
# print(tas_values)

with open('output.txt', 'w') as file:
    for key, value in tas_values.items():
        file.write(f'{key}: {value}\n')

