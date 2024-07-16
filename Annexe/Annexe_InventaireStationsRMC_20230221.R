


folder_ = paste0(folder_HYDRO_DataRMC_,"Debits/DebitsBruts/")

tab_ = data.frame()

for (i in list.files(folder_, full.names = T)){
  print(i)
  dat_ = get(load(i))
  row_ = data.frame(Code_h3 = dat_$Meta$code_h3,
                    Code_h2 = dat_$Meta$code_h2,
                    X = dat_$Meta$XYL93[1],
                    Y = dat_$Meta$XYL93[2],
                    Altitude = dat_$Meta$altitude,
                    Surface = dat_$Meta$surface)
  tab_ = rbind(tab_, row_)
  
}
write.table(tab_, paste0(folder_HYDRO_DataRMC_,"Stations/Inventaire_StationsHYDROdeRMC_HER1.csv"))


