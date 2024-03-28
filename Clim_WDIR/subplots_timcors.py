# -*- coding: utf-8 -*-
'''
Created on Sat Mar 16 22:03:32 2024

@author: Nikita
'''

from netCDF4 import Dataset
import matplotlib.pyplot as plt
import xarray as xr

# Создаем фигуру и массив подграфиков
fig, axs = plt.subplots(11, 2, figsize=(12, 12)) # 2 строки и 5 столбцов для 10 подграфиков

# Предполагаем, что у вас есть список путей к вашим файлам .nc
nc_files = ['E:/Climate/final/timcor_tas_Amon_UKESM1-0-LL_ssp585_r1i1p1f2_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc', 
            'E:/Climate/final/timcor_tas_Amon_ACCESS-CM2_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc', 
            'E:/Climate/final/timcor_tas_Amon_ACCESS-ESM1-5_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_AWI-CM-1-1-MR_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_AWI-CM-1-1-MR_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_CanESM5_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_CanESM5-CanOE_ssp585_r1i1p2f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_CESM2_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_CMCC-ESM2_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_CNRM-CM6-1_ssp585_r1i1p1f2_185001-210012_r360x180_remap_C_regular_axis_year_anom_box',
            'E:/Climate/final/timcor_tas_Amon_CNRM-ESM2-1_ssp585_r1i1p1f2_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_EC-Earth3_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_FIO-ESM-2-0_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_GFDL-ESM4_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_GISS-E2-1-G_ssp585_r1i1p1f2_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_IITM-ESM_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_KACE-1-0-G_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_KIOST-ESM_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_MCM-UA-1-0_ssp585_r1i1p1f2_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
            'E:/Climate/final/timcor_tas_Amon_NESM3_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
'E:/Climate/final/timcor_tas_Amon_NorESM2-MM_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc',
'E:/Climate/final/timcor_tas_Amon_TaiESM1_ssp585_r1i1p1f1_185001-210012_r360x180_remap_C_regular_axis_year_anom_box.nc']

for ax, nc_file in zip(axs.ravel(), nc_files):
    # Читаем данные из файла .nc
     ds = xr.open_dataset(nc_file, decode_times=False)
     
     # Выбираем переменную для визуализации, например 'tas'
     data = ds['tas'].isel(time=0) # предполагаем, что берем первый временной шаг
     
     # Визуализируем данные
     im = ax.pcolormesh(data['lon'], data['lat'], data, shading='auto')
     
     # Добавляем заголовок с названием файла или другой информацией
     ax.set_title(nc_file)
     ax.grid(color='black', linestyle='-', linewidth=0.5, alpha=0.2)
     ax.set_aspect(16/9)
# Устанавливаем интервал сетки через каждые 20 градусов
ax.set_xticks(range(int(data['lon'].min()), int(data['lon'].max()) + 1, 20))
ax.set_yticks(range(int(data['lat'].min()), int(data['lat'].max()) + 1, 20))

# Устанавливаем пропорции подграфика


# Добавляем общую шкалу цветов для всех подграфиков
fig.colorbar(im, ax=axs.ravel().tolist())

# Показываем график
plt.show()
