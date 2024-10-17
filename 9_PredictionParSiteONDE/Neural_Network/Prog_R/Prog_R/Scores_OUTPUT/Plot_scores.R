#---------------
# Scores boxplot
#---------------

library(ggplot2)
library(cowplot)

rm(list=ls())
seuil=""

input1<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Ridge_Lasso_Elastic_net/Résultats_locaux_HER_97/critere_2012_2016_FULL_moy_j30_new_meteo_all_caract_lambda_100_topti_RANDOM_HYDRO_ONLY.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input1<-input1[,-c(7:12)]
input2<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Knn/Résultats_locaux_HER_97/critere_2012_2016_FULL_j30_k_10_new_meteo_all_caract_RANDOM_HYDRO_ONLY.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input2<-input2[,-c(7:9)]
input3<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Neural_network/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_NEW_decay_0_01_RANDOM_HYDRO_ONLY.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input3<-input3[,-c(7:11)]
input4<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_RANDOM_HYDRO_ONLY.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input4<-input4[,-c(7:11)]
# input5<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_moy_j30_new_meteo_all_caract_test1.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input5<-input5[,-7]
# input6<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Random_forest/Résultats_locaux_HER_97/critere_seuils_opti_test_2012_2016_FULL_j10_new_meteo_all_caract.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# input7<-read.table("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/critere_2012_2016_FULL_Modele_simple_all_data.csv", sep=";", header = T, quote="", stringsAsFactors=F)

#----------------------------------------------------------------------------------------------
# INPUT 1
full_input<-data.frame()
full_input[1:nrow(input1),1] = "LASSO"
full_input=cbind(full_input,input1)
# colnames(full_input)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
colnames(full_input)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")

#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
# INPUT 2
data_add <- data.frame()
data_add[1:nrow(input2),1] = "Knn"
data_add=cbind(data_add,input2)
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")
full_input=rbind(full_input,data_add)

#-----------------------------------------------
#-----------------------------------------------
# INPUT 3
data_add <- data.frame()
data_add[1:nrow(input3),1] = "ANN" # 
data_add=cbind(data_add,input3)
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")
full_input=rbind(full_input,data_add)

#-----------------------------------------------
#-----------------------------------------------
# INPUT 4
data_add <- data.frame()
data_add[1:nrow(input4),1] = "RF" #
data_add=cbind(data_add,input4)
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score")
full_input=rbind(full_input,data_add)

#-----------------------------------------------
#-----------------------------------------------
# # INPUT 5
# data_add <- data.frame()
# data_add[1:nrow(input5),1]= "RF_moy30" # "j5_ROC"
# data_add=cbind(data_add,input5)
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# # INPUT 6
# data_add <- data.frame()
# data_add[1:nrow(input6),1]= "RF_j10" # "j5_ROC"
# data_add=cbind(data_add,input6)
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)

# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 7
# data_add <- data.frame()
# data_add[1:nrow(input7),1]="M_naif" # "j2_ROC" "j2_TM" "S_Tair"
# data_add=cbind(data_add,input7)
# colnames(data_add)<-c("Code","POD","FAR","AUC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)

# #-----------------------------------------------
# #-----------------------------------------------
# # INPUT 4
# data_add <- data.frame()
# data_add[1:nrow(input4),1]="j1"  #  "j1_ROC""j1_TM""S_ETP"
# # data_add=cbind(data_add,input4[,1:6])
# # data_add=cbind(data_add,input4[,9:10])
# # data_add=cbind(data_add,input4[,8])
# 
# data_add=cbind(data_add,input4)
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# # INPUT 3
# data_add <- data.frame()
# data_add[1:nrow(input3),1]="j0" #  "j0_ROC""j0_TM""S_PRCP"
# 
# # data_add=cbind(data_add,input3[,1:6])
# # data_add=cbind(data_add,input3[,9:10])
# # data_add=cbind(data_add,input3[,8])
# 
# data_add=cbind(data_add,input3)
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 8
# data_add <- data.frame()
# data_add[1:nrow(input8),1]="S_MET"
# # data_add=cbind(data_add,input8[,1:6])
# # data_add=cbind(data_add,input8[,9:10])
# # data_add=cbind(data_add,input8[,8])
# 
# data_add=cbind(data_add,input8)
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
#-----------------------------------------------
#-----------------------------------------------
# INPUT 9
# data_add <- data.frame()
# data_add[1:nrow(input9),1]="A_MET"
# # data_add=cbind(data_add,input9[,1:6])
# # data_add=cbind(data_add,input9[,9:10])
# # data_add=cbind(data_add,input9[,8])
# 
# data_add=cbind(data_add,input9)
# colnames(data_add)<-c("Code","POD","FAR","ACC","Prec","Recall","F1.Score","Year","Param") #,"AUC")
# full_input=rbind(full_input,data_add)
#-----------------------------------------------

# Quantile <- as.factor(full_input[,1])
# Frequence <- full_input[,2]

a <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,2])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))

b <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,3])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))

# Si ACCURACY
# c <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,4])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))
# Si Area under the curve
c <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,4])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

d <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,5])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

e <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,6])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

f <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,7])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

# plot_grid(a, b, c, d, e, f, labels=c("POD", "FAR", "ACC", "PREC", "Recall", "F1.score"), ncol = 2, nrow = 3)

ggdraw() +
  draw_plot(a, 0, .5, .33, .5) +
  draw_plot(b, .33, 0.5, .33, .5) +
  draw_plot(c, .66, 0.5, .33, .5) +
  draw_plot(d, 0, 0, .33, 0.5) +
  draw_plot(e, .33, 0, .33, 0.5) +
  draw_plot(f, .66, 0, .33, 0.5) +
  draw_plot_label(c("POD", "FAR", "AUC", "PREC", "Recall", "F1.score"), c(0.165, 0.5, 0.82, 0.165, 0.5, 0.82), c(0.99, 0.99,0.99, 0.49, 0.49, 0.49), size = 10)

dev.print(png, filename = paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Graphiques_comparatifs_test_moy30_RANDOM.png", sep=""), width=15 , height=7, units="in", res = 500)
dev.off()
