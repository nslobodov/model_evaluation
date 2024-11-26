close all
clear all
clc
%
path1='E:\CMIP6_tas_remap\';
var_type={'tas'};
%
model(1)={'ACCESS-CM2'}; ens(1)={'r1i1p1f1'};
model(2)={'ACCESS-ESM1-5'}; ens(2)={'r1i1p1f1'};
model(3)={'AWI-CM-1-1-MR'}; ens(3)={'r1i1p1f1'};
model(4)={'BCC-CSM2-MR'}; ens(4)={'r1i1p1f1'};
model(5)={'CAMS-CSM1-0'}; ens(5)={'r1i1p1f1'};
model(6)={'CanESM5'}; ens(6)={'r1i1p1f1'};
model(7)={'CESM2'}; ens(7)={'r1i1p1f1'};
model(8)={'CESM2-WACCM'}; ens(8)={'r1i1p1f1'};
model(9)={'CNRM-CM6-1'}; ens(9)={'r1i1p1f2'};
model(10)={'CNRM-CM6-1-HR'}; ens(10)={'r1i1p1f2'};
model(11)={'CNRM-ESM2-1'}; ens(11)={'r1i1p1f2'};
model(12)={'FGOALS-f3-L'}; ens(12)={'r1i1p1f1'};
model(13)={'FGOALS-g3'}; ens(13)={'r1i1p1f1'};
model(14)={'GFDL-CM4'}; ens(14)={'r1i1p1f1'};
model(15)={'HadGEM3-GC31-LL'}; ens(15)={'r1i1p1f3'};
model(16)={'INM-CM4-8'}; ens(16)={'r1i1p1f1'};
model(17)={'INM-CM5-0'}; ens(17)={'r1i1p1f1'};
model(18)={'IPSL-CM6A-LR'}; ens(18)={'r1i1p1f1'};
model(19)={'MIROC6'}; ens(19)={'r1i1p1f1'};
model(20)={'MIROC-ES2L'}; ens(20)={'r1i1p1f2'};
model(21)={'MPI-ESM1-2-HR'}; ens(21)={'r1i1p1f1'};
model(22)={'MPI-ESM1-2-LR'}; ens(22)={'r1i1p1f1'}; %!
model(23)={'MRI-ESM2-0'}; ens(23)={'r1i1p1f1'};
model(24)={'NESM3'}; ens(24)={'r1i1p1f1'};
model(25)={'NorESM2-LM'}; ens(25)={'r1i1p1f1'}; %!
model(26)={'NorESM2-MM'}; ens(26)={'r1i1p1f1'};
model(27)={'UKESM1-0-LL'}; ens(27)={'r1i1p1f2'};
model(28)={'CanESM5-CanOE'}; ens(28)={'r1i1p2f1'};
model(29)={'IITM-ESM'}; ens(29)={'r1i1p1f1'};% +yy ssp
model(30)={'CMCC-ESM2'}; ens(30)={'r1i1p1f1'};
model(31)={'EC-Earth3'}; ens(31)={'r1i1p1f1'};%
model(32)={'FIO-ESM-2-0'}; ens(32)={'r1i1p1f1'};
model(33)={'GFDL-ESM4'}; ens(33)={'r1i1p1f1'};%
model(34)={'GISS-E2-1-G'}; ens(34)={'r1i1p1f2'};%
model(35)={'KIOST-ESM'}; ens(35)={'r1i1p1f1'};
model(36)={'KACE-1-0-G'}; ens(36)={'r1i1p1f1'};
model(37)={'MCM-UA-1-0'}; ens(37)={'r1i1p1f2'};
model(38)={'TaiESM1'}; ens(38)={'r1i1p1f1'};
%
% historical+ssp245
for mod=1:size(model,2)
    ncid=netcdf.open(['',path1,deblank(cell2mat(var_type)),'_Amon_',deblank(cell2mat(model(mod))),'_ssp245_',deblank(cell2mat(ens(mod))),'_185001-210012_r360x180_remap.nc'],'NOWRITE'); 
    a=single(netcdf.getVar(ncid,netcdf.inqVarID(ncid,deblank(cell2mat(var_type))))); % чтение переменой
    if i==1
        x=single(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'lon'))); x=squeeze(x(:,1));
        y=single(netcdf.getVar(ncid,netcdf.inqVarID(ncid,'lat'))); y=squeeze(y(1:180,1));
    end
    tas(mod,:,:,:)=a; clear a
    netcdf.close(ncid)
    mod/size(model,2)
end





