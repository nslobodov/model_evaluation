# model_evaluation
материалы для курсовой работы 2 курса;
25 CMIP6 models evaluation in historical period (1940-2014) against ERA5 reanalysis.;
Value : 2m temperature 30 years anomaly (reference period 1961-1990);
Region : Eastern European plain (Russian plain), boundaries : 30°E - 60°E, 47°N - 60°N;
The following methods were used : 
- time correlation (cdo timcor) - represents compatibilty in each grid point between model data and reanalysis data over the whole period
- field correlation (cdo fldcor) - calculates correlation value over the region for each timestep. After this I calculated average value through time series (cdo timmean) on which models were evaluated.
