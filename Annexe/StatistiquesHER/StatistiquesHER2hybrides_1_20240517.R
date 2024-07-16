library(readxl)

### Caracteristiques HER 2 hybrides - Utilisation de l'aire des HER 2 ###
file_HER2off_desc_ = "/home/tjaouen/Documents/Input/HER/HER2hybrides/DescriptionHER2hybrides_R_1_20230405.xlsx"
tab_HER2off_desc_ = read_excel(file_HER2off_desc_)
tab_HER2off_desc_$Area_km2 = as.numeric(tab_HER2off_desc_$Area_km2)

# tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == )]
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 37)] = "37+54"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 54)] = "37+54"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+54")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "37+54")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 69)] = "69+96"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 96)] = "69+96"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "69+96")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 31)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 33)] = "31+33+39"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 39)] = "31+33+39"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "31+33+39")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 49)] = "49+90"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 90)] = "49+90"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "49+90")])

tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 89)] = "89+92"
tab_HER2off_desc_$CdHER2[which(tab_HER2off_desc_$CdHER2 == 92)] = "89+92"
tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")] = sum(tab_HER2off_desc_$Area_km2[which(tab_HER2off_desc_$CdHER2 == "89+92")])

dim(tab_HER2off_desc_)

tab_HER2off_sansDoublon_ <- tab_HER2off_desc_[!(duplicated(tab_HER2off_desc_$CdHER2)),c("CdHER2","Area_km2")]


HER_ <- c("2", "3", "5", "12", "13", "14", "17", "21", "22", "24", "25", "27", "28", "34", "35", "36",
          "38", "40", "41", "43", "44", "50", "51", "52", "53", "55", "56", "57", "58", "59", "61", 
          "62", "63", "64", "65", "66", "67", "68", "70", "71", "73", "74", "75", "76", "77", "78",
          "79", "81", "84", "85", "86", "87", "91", "93", "94", "97", "98", "99", "101", "103", "104",
          "105", "106", "107", "108", "112", "113", "117", "118", "120", "31+33+39", "37+54", "69+96",
          "89+92", "49+90")

tab_HER2off_sansDoublon_$CdHER2[which(!(tab_HER2off_sansDoublon_$CdHER2 %in% HER_))]

tab_HER2off_sansDoublon_ <- tab_HER2off_sansDoublon_[which(!(tab_HER2off_sansDoublon_$CdHER2 %in% c("10","18","19","20"))),]
dim(tab_HER2off_sansDoublon_)
median(tab_HER2off_sansDoublon_$Area_km2)
length(which(tab_HER2off_sansDoublon_$Area_km2 > 10000))

