HER_eliminees_J2000 <- c("10", "21", "22", "24", "27", "34", "35", "36", "57", "59", "61", "65", "67", "68",
                         "77", "78", "93", "94", "103", "108", "118", "0", "31+33+39", "69+96",
                         "66", "64", "117", "112", "56", "62", "38", "40", "105", "17", "25", "107",
                         "55", "12", "53")

## Supprimer les colonnes HER dans les fichiers ##
# list_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProba_LearnBrut_ByHer/FDC_Projections/J2000_20231128/", recursive = T, full.names = T, include.dirs = F)
# for (l in list_){
# # for (l in list_[2:length(list_)]){
#   tab_ <- read.table(l, sep = ";", dec = ".", header = T)
#   colnames(tab_) <- gsub("^X", "", colnames(tab_))
#   tab_ <- tab_[, !colnames(tab_) %in% HER_eliminees_J2000]
#   write.table(tab_, l, sep = ";", dec = ".", row.names = F, quote = F)
# }



## Supprimer les fichiers comportant le nom de la HER dans leur nom ##
list_ <- list.files("/media/tjaouen/Ultra Touch/Backup/Main/Input/HYDRO/EtudeFrance/Tab_ChroniquesProbaParHER2_LearnBrut_ByHer/FDC_Projections/J2000_20231128/", recursive = T, full.names = T, include.dirs = F)
pattern <- paste0("HER",sort(as.numeric(HER_eliminees_J2000)),".txt")

for (file in list_) {
  print(file)
  if (any(grepl(paste(pattern, collapse = "|"), file))) {
    file.remove(file)
    print(paste("Fichier supprimé :", file))
  }
}



