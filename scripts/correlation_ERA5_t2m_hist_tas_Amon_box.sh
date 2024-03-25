#!/bin/bash

# --- This is for testing the full algorithm for correlation between 1 reanalysis and many models ---
# in folder. The goal is to get reasonable correlation from timcor and others.
# Starting with remaped models and reanalysis which interpolated
# on the model's grid.
# Data is being saved to NetCDF files on each step.
# ---

# cdo -b f64 addc,-273.15   <-- like in ERA5 reanalysis it was done before this

# --- preparing reanalysis
# E:\Climate\t4\ERA5_t2m_1_2022_C_model_grid.nc
reanalysis="ERA5_t2m_1_2022_C_model_grid.nc"

cdo selyear,1961/1990 "${reanalysis}" "${reanalysis%.nc}_6190.nc"
cdo ymonmean "${reanalysis%.nc}_6190.nc" "${reanalysis%.nc}_6190_clim.nc"
cdo selyear,1940/2014 "${reanalysis}" "${reanalysis%.nc}_year.nc"
cdo ymonsub "${reanalysis%.nc}_year.nc" "${reanalysis%.nc}_6190_clim.nc" "${reanalysis%.nc}_year_anom.nc"

# setting coordinates
cdo sellonlatbox,30,60,47,60 "${reanalysis%.nc}_year_anom.nc" "${reanalysis%.nc}_year_anom_box.nc"

# --- preparing models
for file in tas_Amon_*_remap.nc; do
    cdo -b f64 addc,-273.15 "${file}" "${file%.nc}_C.nc"

    cdo -f nc -remapbil,r360x180 "${file%.nc}_C.nc" "${file%.nc}_C_regular.nc"

    cdo settaxis,1852-08-12,00:00:00,1mon "${file%.nc}_C_regular.nc" "${file%.nc}_C_regular_axis.nc"

    cdo selyear,1961/1990 "${file%.nc}_C_regular_axis.nc" "${file%.nc}_C_regular_axis_6190.nc"

    cdo ymonmean "${file%.nc}_C_regular_axis_6190.nc" "${file%.nc}_C_regular_axis_6190_clim.nc"

    cdo selyear,1940/2014 "${file%.nc}_C_regular_axis.nc" "${file%.nc}_C_regular_axis_year.nc"

    cdo ymonsub "${file%.nc}_C_regular_axis_year.nc" "${file%.nc}_C_regular_axis_6190_clim.nc" "${file%.nc}_C_regular_axis_year_anom.nc"

    # setting coordinates for model
    cdo sellonlatbox,30,60,47,60 "${file%.nc}_C_regular_axis_year_anom.nc" "${file%.nc}_C_regular_axis_year_anom_box.nc"
done

# --- correlations inside selected region
for file_box in tas_Amon_*remap_C_regular_axis_year_anom_box.nc; do
    echo $file_box
    cdo timcor "${file_box}" ERA5_t2m_1_2022_C_model_grid_year_anom_box.nc "timcor_${file_box}"

    cdo fldcor "${file_box}" ERA5_t2m_1_2022_C_model_grid_year_anom_box.nc "fldcor_${file_box}"

    cdo timmean "fldcor_${file_box}" "timmean_fldcor_${file_box}"
done

# --- Results for tas_Amon_UKESM1-0-LL_ssp585_r1i1p1f2_185001-210012_r360x180_remap.nc (timmean and timcor) ---
# nikitx@DESKTOP-SCO7VFH:/mnt/e/Climate/t4$ cdo info timm*
#     -1 :       Date     Time   Level Gridsize    Miss :     Minimum        Mean     Maximum : Parameter ID
#      1 : 1977-06-26 12:23:14       0        1       0 :               -0.010627             : -1
# cdo    info: Processed 1 value from 1 variable over 1 timestep [0.01s 44MB].
# nikitx@DESKTOP-SCO7VFH:/mnt/e/Climate/t4$ cdo info timcor*
#     -1 :       Date     Time   Level Gridsize    Miss :     Minimum        Mean     Maximum : Parameter ID
#      1 : 2014-12-12 00:00:00       0      403       0 :  0.00064315    0.028965    0.070284 : -1
# cdo    info: Processed 403 values from 1 variable over 1 timestep [0.01s 44MB].
# ---