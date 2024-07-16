
library(ncdf4)

list_ = list.files("/media/tjaouen/Lexar/INRAE_Bckp/20231123/Input/HYDRO/EtudeFrance/Debits/DebitsProjections/NetcdfNotMerged_CorrLocPointsLH_20231123_Ncdf/GRSD_20231128/rcp26/", full.names = T)

tab_ = nc_open(list_[1])


