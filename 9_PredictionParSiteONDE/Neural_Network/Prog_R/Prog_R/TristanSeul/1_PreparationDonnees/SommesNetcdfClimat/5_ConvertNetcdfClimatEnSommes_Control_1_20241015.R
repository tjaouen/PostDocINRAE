library(ncdf4)

nc_prtotAdjust_historical_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231.nc")
nc_prtotAdjust_historical_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J10Jj.nc")

prtotAdjust_historical_Jj <- ncvar_get(nc_prtotAdjust_historical_Jj,"prtotAdjust")
prtotAdjust_historical_J10Jj <- ncvar_get(nc_prtotAdjust_historical_J10Jj,"prtotAdjust")


dim(prtotAdjust_historical_Jj)
dim(prtotAdjust_historical_J10Jj)

prtotAdjust_historical_Jj[58,22,18234:18244]
prtotAdjust_historical_J10Jj[58,22,18234:18244]

sum(prtotAdjust_historical_Jj[58,22,18234:18244])




nc_prtotAdjust_rcp26_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")
nc_prtotAdjust_rcp26_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")

prtotAdjust_rcp26_Jj <- ncvar_get(nc_prtotAdjust_rcp26_Jj,"prtotAdjust")
prtotAdjust_rcp26_J10Jj <- ncvar_get(nc_prtotAdjust_rcp26_J10Jj,"prtotAdjust")

dim(prtotAdjust_rcp26_Jj)
dim(prtotAdjust_rcp26_J10Jj)

prtotAdjust_rcp26_Jj[58,22,18234:18244]
prtotAdjust_rcp26_J10Jj[58,22,18234:18244]


prtotAdjust_rcp26_Jj[58,22,18243]
prtotAdjust_rcp26_J10Jj[58,22,18243]


# sum(prtotAdjust_rcp26_Jj[58,22,18234:18244])

nc_prtotAdjust_rcp26_Jj$var$prtotAdjust
nc_prtotAdjust_rcp26_J10Jj$var$prtotAdjust



nc_prtotAdjust_rcp26_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175.nc")
nc_prtotAdjust_rcp26_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")

prtotAdjust_rcp26_Jj <- ncvar_get(nc_prtotAdjust_rcp26_Jj,"prtotAdjust")
prtotAdjust_rcp26_J10Jj <- ncvar_get(nc_prtotAdjust_rcp26_J10Jj,"prtotAdjust")





### tasAdjust ###
nc_tasAdjust_historical_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231.nc")
nc_tasAdjust_rcp26_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")
nc_tasAdjust_rcp45_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")
nc_tasAdjust_rcp85_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")
tasAdjust_historical_Jj <- ncvar_get(nc_tasAdjust_historical_Jj,"tasAdjust")
tasAdjust_rcp26_Jj <- ncvar_get(nc_tasAdjust_rcp26_Jj,"tasAdjust")
tasAdjust_rcp45_Jj <- ncvar_get(nc_tasAdjust_rcp45_Jj,"tasAdjust")
tasAdjust_rcp85_Jj <- ncvar_get(nc_tasAdjust_rcp85_Jj,"tasAdjust")

nc_tasAdjust_historical_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J10Jj.nc")
nc_tasAdjust_rcp26_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")
nc_tasAdjust_rcp45_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")
nc_tasAdjust_rcp85_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")
tasAdjust_historical_Jj <- ncvar_get(nc_tasAdjust_historical_J10Jj,"tasAdjust")
tasAdjust_rcp26_J10Jj <- ncvar_get(nc_tasAdjust_rcp26_J10Jj,"tasAdjust")
tasAdjust_rcp45_J10Jj <- ncvar_get(nc_tasAdjust_rcp45_J10Jj,"tasAdjust")
tasAdjust_rcp85_J10Jj <- ncvar_get(nc_tasAdjust_rcp85_J10Jj,"tasAdjust")

nc_tasAdjust_historical_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J20Jj.nc")
nc_tasAdjust_rcp26_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J20Jj.nc")
nc_tasAdjust_rcp45_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J20Jj.nc")
nc_tasAdjust_rcp85_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J20Jj.nc")
tasAdjust_historical_J20Jj <- ncvar_get(nc_tasAdjust_historical_J20Jj,"tasAdjust")
tasAdjust_rcp26_J20Jj <- ncvar_get(nc_tasAdjust_rcp26_J20Jj,"tasAdjust")
tasAdjust_rcp45_J20Jj <- ncvar_get(nc_tasAdjust_rcp45_J20Jj,"tasAdjust")
tasAdjust_rcp85_J20Jj <- ncvar_get(nc_tasAdjust_rcp85_J20Jj,"tasAdjust")

nc_tasAdjust_historical_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J30Jj.nc")
nc_tasAdjust_rcp26_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J30Jj.nc")
nc_tasAdjust_rcp45_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J30Jj.nc")
nc_tasAdjust_rcp85_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/tasAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J30Jj.nc")
tasAdjust_historical_J30Jj <- ncvar_get(nc_evspsblpotAdjust_historical_J30Jj,"tasAdjust")
tasAdjust_rcp26_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp26_J30Jj,"tasAdjust")
tasAdjust_rcp45_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp45_J30Jj,"tasAdjust")
tasAdjust_rcp85_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp85_J30Jj,"tasAdjust")


### evspsblpotAdjust ###
nc_evspsblpotAdjust_historical_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_Hg0175.nc")
nc_evspsblpotAdjust_rcp26_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175.nc")
nc_evspsblpotAdjust_rcp45_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175.nc")
nc_evspsblpotAdjust_rcp85_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175.nc")
evspsblpotAdjust_historical_Jj <- ncvar_get(nc_evspsblpotAdjust_historical_Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp26_Jj <- ncvar_get(nc_evspsblpotAdjust_rcp26_Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp45_Jj <- ncvar_get(nc_evspsblpotAdjust_rcp45_Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp85_Jj <- ncvar_get(nc_evspsblpotAdjust_rcp85_Jj,"evspsblpotAdjust")

nc_evspsblpotAdjust_historical_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_Hg0175_J10Jj.nc")
nc_evspsblpotAdjust_rcp26_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J10Jj.nc")
nc_evspsblpotAdjust_rcp45_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J10Jj.nc")
nc_evspsblpotAdjust_rcp85_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J10Jj.nc")
evspsblpotAdjust_historical_Jj <- ncvar_get(nc_evspsblpotAdjust_historical_J10Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp26_J10Jj <- ncvar_get(nc_evspsblpotAdjust_rcp26_J10Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp45_J10Jj <- ncvar_get(nc_evspsblpotAdjust_rcp45_J10Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp85_J10Jj <- ncvar_get(nc_evspsblpotAdjust_rcp85_J10Jj,"evspsblpotAdjust")

nc_evspsblpotAdjust_historical_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_Hg0175_J20Jj.nc")
nc_evspsblpotAdjust_rcp26_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J20Jj.nc")
nc_evspsblpotAdjust_rcp45_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J20Jj.nc")
nc_evspsblpotAdjust_rcp85_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J20Jj.nc")
evspsblpotAdjust_historical_J20Jj <- ncvar_get(nc_evspsblpotAdjust_historical_J20Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp26_J20Jj <- ncvar_get(nc_evspsblpotAdjust_rcp26_J20Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp45_J20Jj <- ncvar_get(nc_evspsblpotAdjust_rcp45_J20Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp85_J20Jj <- ncvar_get(nc_evspsblpotAdjust_rcp85_J20Jj,"evspsblpotAdjust")

nc_evspsblpotAdjust_historical_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_Hg0175_J30Jj.nc")
nc_evspsblpotAdjust_rcp26_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J30Jj.nc")
nc_evspsblpotAdjust_rcp45_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J30Jj.nc")
nc_evspsblpotAdjust_rcp85_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/evspsblpotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_Hg0175_J30Jj.nc")
evspsblpotAdjust_historical_J30Jj <- ncvar_get(nc_evspsblpotAdjust_historical_J30Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp26_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp26_J30Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp45_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp45_J30Jj,"evspsblpotAdjust")
evspsblpotAdjust_rcp85_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp85_J30Jj,"evspsblpotAdjust")


### prtotAdjust ###
nc_prtotAdjust_historical_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231.nc")
nc_prtotAdjust_rcp26_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")
nc_prtotAdjust_rcp45_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")
nc_prtotAdjust_rcp85_Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231.nc")
prtotAdjust_historical_Jj <- ncvar_get(nc_prtotAdjust_historical_Jj,"prtotAdjust")
prtotAdjust_rcp26_Jj <- ncvar_get(nc_prtotAdjust_rcp26_Jj,"prtotAdjust")
prtotAdjust_rcp45_Jj <- ncvar_get(nc_prtotAdjust_rcp45_Jj,"prtotAdjust")
prtotAdjust_rcp85_Jj <- ncvar_get(nc_prtotAdjust_rcp85_Jj,"prtotAdjust")

nc_prtotAdjust_historical_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J10Jj.nc")
nc_prtotAdjust_rcp26_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")
nc_prtotAdjust_rcp45_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")
nc_prtotAdjust_rcp85_J10Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J10Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J10Jj.nc")
prtotAdjust_historical_Jj <- ncvar_get(nc_prtotAdjust_historical_J10Jj,"prtotAdjust")
prtotAdjust_rcp26_J10Jj <- ncvar_get(nc_prtotAdjust_rcp26_J10Jj,"prtotAdjust")
prtotAdjust_rcp45_J10Jj <- ncvar_get(nc_prtotAdjust_rcp45_J10Jj,"prtotAdjust")
prtotAdjust_rcp85_J10Jj <- ncvar_get(nc_prtotAdjust_rcp85_J10Jj,"prtotAdjust")

nc_prtotAdjust_historical_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J20Jj.nc")
nc_prtotAdjust_rcp26_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J20Jj.nc")
nc_prtotAdjust_rcp45_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J20Jj.nc")
nc_prtotAdjust_rcp85_J20Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J20Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J20Jj.nc")
prtotAdjust_historical_J20Jj <- ncvar_get(nc_prtotAdjust_historical_J20Jj,"prtotAdjust")
prtotAdjust_rcp26_J20Jj <- ncvar_get(nc_prtotAdjust_rcp26_J20Jj,"prtotAdjust")
prtotAdjust_rcp45_J20Jj <- ncvar_get(nc_prtotAdjust_rcp45_J20Jj,"prtotAdjust")
prtotAdjust_rcp85_J20Jj <- ncvar_get(nc_prtotAdjust_rcp85_J20Jj,"prtotAdjust")

nc_prtotAdjust_historical_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_historical_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_19500101-20051231_J30Jj.nc")
nc_prtotAdjust_rcp26_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp26_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J30Jj.nc")
nc_prtotAdjust_rcp45_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp45_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J30Jj.nc")
nc_prtotAdjust_rcp85_J30Jj <- nc_open("/media/tjaouen/Ultra Touch/Backup/Main/Input/Climat/Projections_Explore2/J30Jj/prtotAdjust_France_MPI-M-MPI-ESM-LR_rcp85_r1i1p1_CLMcom-CCLM4-8-17_v1_MF-ADAMONT-SAFRAN-1980-2011_day_20060101-21001231_J30Jj.nc")
prtotAdjust_historical_J30Jj <- ncvar_get(nc_evspsblpotAdjust_historical_J30Jj,"prtotAdjust")
prtotAdjust_rcp26_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp26_J30Jj,"prtotAdjust")
prtotAdjust_rcp45_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp45_J30Jj,"prtotAdjust")
prtotAdjust_rcp85_J30Jj <- ncvar_get(nc_evspsblpotAdjust_rcp85_J30Jj,"prtotAdjust")




prtotAdjust_rcp26_Jj

### tasAdjust ###

# J10
mean(tasAdjust_historical_Jj[58,22,18234:18244])
mean(tasAdjust_rcp26_Jj[58,22,18234:18244])
mean(tasAdjust_rcp45_Jj[58,22,18234:18244])
mean(tasAdjust_rcp85_Jj[58,22,18234:18244])

tasAdjust_historical_J10Jj[58,22,18234:18244]
tasAdjust_rcp26_J10Jj[58,22,18234:18244]
tasAdjust_rcp45_J10Jj[58,22,18234:18244]
tasAdjust_rcp85_J10Jj[58,22,18234:18244]

# J20
mean(tasAdjust_historical_Jj[58,22,18224:18244])
mean(tasAdjust_rcp26_Jj[58,22,18224:18244])
mean(tasAdjust_rcp45_Jj[58,22,18224:18244])
mean(tasAdjust_rcp85_Jj[58,22,18224:18244])

tasAdjust_historical_J20Jj[58,22,18224:18244]
tasAdjust_rcp26_J20Jj[58,22,18224:18244]
tasAdjust_rcp45_J20Jj[58,22,18224:18244]
tasAdjust_rcp85_J20Jj[58,22,18224:18244]

# J30
mean(tasAdjust_historical_Jj[58,22,18214:18244])
mean(tasAdjust_rcp26_Jj[58,22,18214:18244])
mean(tasAdjust_rcp45_Jj[58,22,18214:18244])
mean(tasAdjust_rcp85_Jj[58,22,18214:18244])

tasAdjust_historical_J30Jj[58,22,18214:18244]
tasAdjust_rcp26_J30Jj[58,22,18214:18244]
tasAdjust_rcp45_J30Jj[58,22,18214:18244]
tasAdjust_rcp85_J30Jj[58,22,18214:18244]


### evspsblpotAdjust ###

# J10
mean(evspsblpotAdjust_historical_Jj[58,22,18234:18244])
mean(evspsblpotAdjust_rcp26_Jj[58,22,18234:18244])
mean(evspsblpotAdjust_rcp45_Jj[58,22,18234:18244])
mean(evspsblpotAdjust_rcp85_Jj[58,22,18234:18244])

evspsblpotAdjust_historical_J10Jj[58,22,18234:18244]
evspsblpotAdjust_rcp26_J10Jj[58,22,18234:18244]
evspsblpotAdjust_rcp45_J10Jj[58,22,18234:18244]
evspsblpotAdjust_rcp85_J10Jj[58,22,18234:18244]

# J20
mean(evspsblpotAdjust_historical_Jj[58,22,18224:18244])
mean(evspsblpotAdjust_rcp26_Jj[58,22,18224:18244])
mean(evspsblpotAdjust_rcp45_Jj[58,22,18224:18244])
mean(evspsblpotAdjust_rcp85_Jj[58,22,18224:18244])

evspsblpotAdjust_historical_J20Jj[58,22,18224:18244]
evspsblpotAdjust_rcp26_J20Jj[58,22,18224:18244]
evspsblpotAdjust_rcp45_J20Jj[58,22,18224:18244]
evspsblpotAdjust_rcp85_J20Jj[58,22,18224:18244]

# J30
mean(evspsblpotAdjust_historical_Jj[58,22,18214:18244])
mean(evspsblpotAdjust_rcp26_Jj[58,22,18214:18244])
mean(evspsblpotAdjust_rcp45_Jj[58,22,18214:18244])
mean(evspsblpotAdjust_rcp85_Jj[58,22,18214:18244])

evspsblpotAdjust_historical_J30Jj[58,22,18214:18244]
evspsblpotAdjust_rcp26_J30Jj[58,22,18214:18244]
evspsblpotAdjust_rcp45_J30Jj[58,22,18214:18244]
evspsblpotAdjust_rcp85_J30Jj[58,22,18214:18244]



### prtotAdjust ###

# J10
mean(prtotAdjust_historical_Jj[58,22,18234:18244])
mean(prtotAdjust_rcp26_Jj[58,22,18234:18244])
mean(prtotAdjust_rcp45_Jj[58,22,18234:18244])
mean(prtotAdjust_rcp85_Jj[58,22,18234:18244])

prtotAdjust_historical_J10Jj[58,22,18234:18244]
prtotAdjust_rcp26_J10Jj[58,22,18234:18244]
prtotAdjust_rcp45_J10Jj[58,22,18234:18244]
prtotAdjust_rcp85_J10Jj[58,22,18234:18244]

# J20
mean(prtotAdjust_historical_Jj[58,22,18224:18244])
mean(prtotAdjust_rcp26_Jj[58,22,18224:18244])
mean(prtotAdjust_rcp45_Jj[58,22,18224:18244])
mean(prtotAdjust_rcp85_Jj[58,22,18224:18244])

prtotAdjust_historical_J20Jj[58,22,18224:18244]
prtotAdjust_rcp26_J20Jj[58,22,18224:18244]
prtotAdjust_rcp45_J20Jj[58,22,18224:18244]
prtotAdjust_rcp85_J20Jj[58,22,18224:18244]

# J30
mean(prtotAdjust_historical_Jj[58,22,18214:18244])
mean(prtotAdjust_rcp26_Jj[58,22,18214:18244])
mean(prtotAdjust_rcp45_Jj[58,22,18214:18244])
mean(prtotAdjust_rcp85_Jj[58,22,18214:18244])

prtotAdjust_historical_J30Jj[58,22,18214:18244]
prtotAdjust_rcp26_J30Jj[58,22,18214:18244]
prtotAdjust_rcp45_J30Jj[58,22,18214:18244]
prtotAdjust_rcp85_J30Jj[58,22,18214:18244]




