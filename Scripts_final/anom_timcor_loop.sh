#!/bin/bash

# Enable job control to run processes in parallel
set -m

# Loop through files and process them in parallel
for file in tas_Amon_*_remap.nc; do
  (
    # Combine addc and remapbil into one command to reduce I/O
    #cdo -f nc -remapbil,r360x180 -addc,-273.15 "${file}" "${file%.nc}_C_regular.nc"
    
    # Set the time axis
    #cdo settaxis,1852-08-12,00:00:00,1mon "${file%.nc}_C_regular.nc" "${file%.nc}_C_regular_axis.nc"
    
    # Select the years 1961/1990 and calculate the monthly mean in one step
    #cdo ymonmean -selyear,1961/1990 "${file%.nc}_C_regular_axis.nc" "${file%.nc}_C_regular_axis_6190_clim.nc"
    
    # Select the years 1940/2014
    #cdo selyear,1940/2014 "${file%.nc}_C_regular_axis.nc" "${file%.nc}_C_regular_axis_year.nc"
    
    # Subtract the monthly mean climatology to get anomalies
    #cdo ymonsub "${file%.nc}_C_regular_axis_year.nc" "${file%.nc}_C_regular_axis_6190_clim.nc" "${file%.nc}_C_regular_axis_year_anom.nc"
    
    # Select a geographical subset of the data
    #cdo sellonlatbox,30,60,47,60 "${file%.nc}_C_regular_axis_year_anom.nc" "${file%.nc}_C_regular_axis_year_anom_box.nc"
    
    # Calculate temporal correlation
    cdo timcor "${file%.nc}_C_regular_axis_year_anom_box.nc" ERA5_t2m_1_2022_C_model_grid_year_anom_box.nc "timcor_${file%.nc}_C_regular_axis_year_anom_box.nc"
    
    # Calculate field correlation
    cdo fldcor "${file%.nc}_C_regular_axis_year_anom_box.nc" ERA5_t2m_1_2022_C_model_grid_year_anom_box.nc "fldcor_${file%.nc}_C_regular_axis_year_anom_box.nc"
    
    # Calculate time mean
    cdo timmean "fldcor_${file%.nc}_C_regular_axis_year_anom_box.nc" "timmean_fldcor_${file%.nc}_C_regular_axis_year_anom_box.nc"
  ) &
done
wait
for file in tas_Amon_*_remap.nc; do
  (
    rm "${file%.nc}_C_regular.nc"
    rm "${file%.nc}_C_regular_axis.nc"
    rm "${file%.nc}_C_regular_axis_6190_clim.nc"
    rm "${file%.nc}_C_regular_axis_year.nc"
    rm "${file%.nc}_C_regular_axis_year_anom.nc"
  ) &
done
wait
