


file_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv"
tab_ = read.table(file_, sep =",", dec = ".", header = T)

paste0(2012:2022,"-",5:9,"_",unique(tab_$HER2))

combinations <- expand.grid(Year = 2012:2022, Number = 5:9, HER2 = unique(tab_$HER2))
ref_ <- paste0(combinations$Year, "-", combinations$Number, "_", combinations$HER2)

val_tab_ <- paste0(year(tab_$Date),"-",month(tab_$Date),"_",tab_$HER2)

setdiff(ref_,val_tab_)
setdiff(val_tab_,ref_)




file_excl = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/30_PresentMesures_HERh_FltOndeAtStart_JctHER89et92_ValidAnSecInterHum_2012_2022_20231221/DebitsComplets_From20120101_To20221231/MatInputModel_CampOndeExcl_ByHERDates__2012_2022_Observes_Weight_merge.csv"
tab_excl = read.table(file_excl, sep =";", dec = ".", header = T)

val_tab_excl <- paste0(year(tab_excl$Date),"-",month(tab_excl$Date),"_",tab_excl$HER2)

setdiff(val_tab_,val_tab_excl)
setdiff(val_tab_excl,val_tab_)


setdiff(ref_,val_tab_excl)
setdiff(val_tab_excl,val_tab_)


setdiff(setdiff(val_tab_,val_tab_excl),setdiff(ref_,val_tab_excl))



























file_ = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/MatInputModel_ByHERDates__2012_2022_Observes_Weight_merge.csv"
tab_ = read.table(file_, sep =",", dec = ".", header = T)

combinations <- expand.grid(Year = 2012:2022, Number = 5:9, HER2 = unique(tab_$HER2))
ref_ <- paste0(combinations$Year, "-", combinations$Number, "_", combinations$HER2)

val_tab_ <- paste0(year(tab_$Date),"-",month(tab_$Date),"_",tab_$HER2)

setdiff(ref_,val_tab_)
setdiff(val_tab_,ref_)


file_excl = "/home/tjaouen/Documents/Output/ChangementClimatique2019/EtudeFrance/1_MatricesInputModeles_ParHERDates/22_PresentMesures_HERh_FltOndeAtStart_JctHERcorrHER1_ValidLOYO_2012_2022_20230919/DebitsComplets_From20120101_To20221231/MatInputModel_CampOndeExcl_ByHERDates__2012_2022_Observes_Weight_merge.csv"
tab_excl = read.table(file_excl, sep =";", dec = ".", header = T)

val_tab_excl <- paste0(year(tab_excl$Date),"-",month(tab_excl$Date),"_",tab_excl$HER2)

setdiff(val_tab_,val_tab_excl)
setdiff(val_tab_excl,val_tab_)


setdiff(ref_,val_tab_excl)
setdiff(val_tab_excl,val_tab_)







