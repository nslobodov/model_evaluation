# Model evaluation
##Приложение. Материалы для курсовой работы 2 курса##

Evaluation of 38 CMIP6 models during the historical period (1940-2014) against ERA5 reanalysis.\
Values: 2m temperature (K) anomalies; total precipitation anomalies (mm) (reference period: 1961-1990).\
Region: East European Plain (Russian Plain); boundaries: 30°E - 60°E, 47°N - 60°N.\
The following two methods are used:
- Time correlation (cdo timcor) represents the compatibility at each grid point between model data and reanalysis data over the entire period.
- Field correlation (cdo fldcor) calculates the correlation value over the region for each timestep.
The average values through the time series were calculated (cdo timmean), on which the models were ranked.
