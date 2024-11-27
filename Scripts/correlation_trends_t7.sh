#!/bin/bash

# --- This is for testing the full algorithm for correlation between 1 reanalysis and many models 
# in the folder. The goal is to get reasonable correlation from timcor and other.
# Starting with remaped models and reanalysis interpolated on the model's grid.
# Data is being saved to NetCDF files on each step to make it easier to check all steps,
# what should be removed further.
# ---

# EXECUTE THIS ONLY IN DIRECTORY YOU UNDERSTAND

# Current directory:
# E:/Climate/t7

# --- preparing reanalysis

reanalysis="ERA5_t2m_1_2022_C_model_grid.nc"

# cdo selyear,1961/1990 "${reanalysis}" "${reanalysis%.nc}_6190.nc"
# cdo ymonmean "${reanalysis%.nc}_6190.nc" "${reanalysis%.nc}_6190_clim.nc"
# cdo selyear,1940/2014 "${reanalysis}" "${reanalysis%.nc}_year.nc"
# cdo ymonsub "${reanalysis%.nc}_year.nc" "${reanalysis%.nc}_6190_clim.nc" "${reanalysis%.nc}_year_anom.nc"

# # setting coordinates
# cdo sellonlatbox,30,60,47,60 "${reanalysis%.nc}_year_anom.nc" "${reanalysis%.nc}_year_anom_box.nc"
# # calculating yearly mean data
# cdo yearmean "${reanalysis%.nc}_year_anom_box.nc" "${reanalysis%.nc}_year_anom_box_ymean.nc"
cdo trend "${reanalysis%.nc}_year_anom_box_ymean.nc" "trend1_${reanalysis%.nc}_year_anom_box_ymean.nc" "trend2_${reanalysis%.nc}_year_anom_box_ymean.nc"

cdo fldmean "trend1_${reanalysis%.nc}_year_anom_box_ymean.nc" "fldmean_trend1_${reanalysis%.nc}_year_anom_box_ymean.nc"
cdo fldmean "trend2_${reanalysis%.nc}_year_anom_box_ymean.nc" "fldmean_trend2_${reanalysis%.nc}_year_anom_box_ymean.nc"

# --- preparing models

# Input file name structure sample: tas_Amon_UKESM1-0-LL_ssp585_r1i1p1f2_185001-210012_r360x180_remap.nc
for file in tas_Amon_*_remap.nc; do
    cdo -b f64 addc,-273.15 "${file}" "${file%.nc}_C.nc"

    cdo -f nc -remapbil,r360x180 "${file%.nc}_C.nc" "${file%.nc}_C_regular.nc"

    cdo settaxis,1858-04-15,00:00:00,1mon "${file%.nc}_C_regular.nc" "${file%.nc}_C_regular_axis.nc"
    
    cdo selyear,1961/1990 "${file%.nc}_C_regular_axis.nc" "${file%.nc}_C_regular_axis_6190.nc"

    cdo ymonmean "${file%.nc}_C_regular_axis_6190.nc" "${file%.nc}_C_regular_axis_6190_clim.nc"

    cdo selyear,1940/2014 "${file%.nc}_C_regular_axis.nc" "${file%.nc}_C_regular_axis_year.nc"

    cdo ymonsub "${file%.nc}_C_regular_axis_year.nc" "${file%.nc}_C_regular_axis_6190_clim.nc" "${file%.nc}_C_regular_axis_year_anom.nc"
    # setting coordinates for model
    cdo sellonlatbox,30,60,47,60 "${file%.nc}_C_regular_axis_year_anom.nc" "${file%.nc}_C_regular_axis_year_anom_box.nc"

    cdo yearmean "${file%.nc}_C_regular_axis_year_anom_box.nc" "${file%.nc}_C_regular_axis_year_anom_box_ymean.nc"
    # computting trend (trend can be plotted as y(time) = trend1 + trend2 * time)
    cdo trend "${file%.nc}_C_regular_axis_year_anom_box_ymean.nc" "trend1_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc" "trend2_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc"
    # mean trend in region
    cdo fldmean "trend1_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc" "fldmean_trend1_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc"
    cdo fldmean "trend2_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc" "fldmean_trend2_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc"

done

# --- correlations inside selected region and after yearmean

for file in tas_Amon_*_remap_C_regular_axis_year_anom_box_ymean.nc; do
    cdo timcor "${file}" "${reanalysis%.nc}_year_anom_box_ymean.nc" "timcor_${file}"

    cdo fldcor "${file}" "${reanalysis%.nc}_year_anom_box_ymean.nc" "fldcor_${file}"

    cdo timmean "fldcor_${file}" "timmean_fldcor_${file}"

done

# -- removing steps between

for file in tas_Amon_*_remap.nc; do
    rm "${file%.nc}_C.nc"
    rm "${file%.nc}_C_regular.nc"
    rm "${file%.nc}_C_regular_axis.nc"

    rm "${file%.nc}_C_regular_axis_6190.nc"
    rm "${file%.nc}_C_regular_axis_6190_clim.nc"

    rm "${file%.nc}_C_regular_axis_year.nc"
    rm "${file%.nc}_C_regular_axis_year_anom.nc"
    rm "${file%.nc}_C_regular_axis_year_anom_box.nc"
    # rm "${file%.nc}_C_regular_axis_year_anom_box_ymean.nc"
    
    rm "trend2_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc"
    rm "trend1_${file%.nc}_C_regular_axis_year_anom_box_ymean.nc"

done

# --- Results for: tas_Amon_UKESM1-0-LL_ssp585_r1i1p1f2_185001-210012_r360x180_remap.nc ---
# (timcor and timmean)
# nikitx@DESKTOP-SCO7VFH:/mnt/e/Climate/t7$ cdo info timcor*UKE*
#     -1 :       Date     Time   Level Gridsize    Miss :     Minimum        Mean     Maximum : Parameter ID
#      1 : 2014-06-30 00:00:00       0      403       0 :   -0.081835    0.054357     0.26132 : -1
# cdo    info: Processed 403 values from 1 variable over 1 timestep [0.03s 44MB].
# nikitx@DESKTOP-SCO7VFH:/mnt/e/Climate/t7$ cdo info timmean*UK*
#     -1 :       Date     Time   Level Gridsize    Miss :     Minimum        Mean     Maximum : Parameter ID
#      1 : 1977-06-30 00:00:00       0        1       0 :                0.052351             : -1
# cdo    info: Processed 1 value from 1 variable over 1 timestep [0.01s 44MB].
# ---

# --- COMMENTS ---
# timcor is worse than in t6 (it was 0.18787 -- 0.27853 -- 0.36284)
# timmean is better (was 0.028273)
# ---