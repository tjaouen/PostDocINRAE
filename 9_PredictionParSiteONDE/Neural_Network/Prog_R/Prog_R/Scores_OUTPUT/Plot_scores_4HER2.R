#---------------
# Scores boxplot
#---------------

library(ggplot2)
library(cowplot)

rm(list=ls())
seuil=""
# ANN
input1<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/ANN_0_1_HER_38_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input2<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/ANN_0_2_HER_58_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input3<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/ANN_0_01_HER_85_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input4<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/ANN_0_0001_HER_105_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# RF
input5<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/RF_HER_38_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input6<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/RF_HER_58_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input7<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/RF_HER_85_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input8<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/RF_HER_105_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# LASSO
input9<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/LASSO_HER_38_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input10<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/LASSO_HER_58_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input11<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/LASSO_HER_85_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input12<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/LASSO_HER_105_RANDOM_FINAL.csv", sep=";", header = T, quote="", stringsAsFactors=F)
# BENCHMARK MODEL
input13<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/critere_2012_2016_FULL_Modele_benchmark_38.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input14<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/critere_2012_2016_FULL_Modele_benchmark_58.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input15<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/critere_2012_2016_FULL_Modele_benchmark_85.csv", sep=";", header = T, quote="", stringsAsFactors=F)
input16<-read.table("C:/Users/aurelien.beaufort/Documents/Article/Article 2/Figures/Results Cross-validation/critere_2012_2016_FULL_Modele_benchmark_105.csv", sep=";", header = T, quote="", stringsAsFactors=F)

#----------------------------------------------------------------------------------------------
# INPUT 1
full_input<-data.frame()
full_input[1:nrow(input1),1] = "ANN"
full_input[1:nrow(input1),2] = "38"
full_input=cbind(full_input,input1[,c(1,2,6)])
#----------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------
# INPUT 2
data_add <- data.frame()
data_add[1:nrow(input2),1] = "ANN"
data_add[1:nrow(input2),2] = "58"
data_add=cbind(data_add,input2)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
#-----------------------------------------------
#-----------------------------------------------
# INPUT 3
data_add <- data.frame()
data_add[1:nrow(input3),1] = "ANN" # 
data_add[1:nrow(input3),2] = "85"
data_add=cbind(data_add,input3)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
#-----------------------------------------------
#-----------------------------------------------
# INPUT 4
data_add <- data.frame()
data_add[1:nrow(input4),1] = "ANN" # 
data_add[1:nrow(input4),2] = "105"
data_add=cbind(data_add,input4)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
#-----------------------------------------------
#-----------------------------------------------
# INPUT 5
data_add <- data.frame()
data_add[1:nrow(input5),1]= "RF" #
data_add[1:nrow(input5),2] = "38"
data_add=cbind(data_add,input5)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 6
data_add <- data.frame()
data_add[1:nrow(input6),1]= "RF" #
data_add[1:nrow(input6),2] = "58"
data_add=cbind(data_add,input6)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# #-----------------------------------------------
# INPUT 7
data_add <- data.frame()
data_add[1:nrow(input7),1]= "RF" #
data_add[1:nrow(input7),2] = "85"
data_add=cbind(data_add,input7)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 8
data_add <- data.frame()
data_add[1:nrow(input8),1]= "RF" #
data_add[1:nrow(input8),2] = "105"
data_add=cbind(data_add,input8)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 9
data_add <- data.frame()
data_add[1:nrow(input9),1]= "LASSO" #
data_add[1:nrow(input9),2] = "38"
data_add=cbind(data_add,input9)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 10
data_add <- data.frame()
data_add[1:nrow(input10),1]= "LASSO" #
data_add[1:nrow(input10),2] = "58"
data_add=cbind(data_add,input10)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 11
data_add <- data.frame()
data_add[1:nrow(input11),1]= "LASSO" #
data_add[1:nrow(input11),2] = "85"
data_add=cbind(data_add,input11)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 12
data_add <- data.frame()
data_add[1:nrow(input12),1]= "LASSO" #
data_add[1:nrow(input12),2] = "105"
data_add=cbind(data_add,input12)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 13
data_add <- data.frame()
data_add[1:nrow(input13),1]= "BM" #
data_add[1:nrow(input13),2] = "38"
data_add=cbind(data_add,input13)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 14
data_add <- data.frame()
data_add[1:nrow(input14),1]= "BM" #
data_add[1:nrow(input14),2] = "58"
data_add=cbind(data_add,input14)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 15
data_add <- data.frame()
data_add[1:nrow(input15),1]= "BM" #
data_add[1:nrow(input15),2] = "85"
data_add=cbind(data_add,input15)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------
# INPUT 16
data_add <- data.frame()
data_add[1:nrow(input16),1]= "BM" #
data_add[1:nrow(input16),2] = "105"
data_add=cbind(data_add,input16)
full_input=rbind(full_input,data_add[,c(1,2,3,4,8)])
# #-----------------------------------------------

a <- ggplot(data = full_input, aes(x = as.factor(full_input[,2]), y = full_input[,3])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))

b <- ggplot(data = full_input, aes(x = as.factor(full_input[,2]), y = full_input[,4])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))

c <- ggplot(data = full_input, aes(x = as.factor(full_input[,2]), y = full_input[,5])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
  scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

# Si ACCURACY
# c <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,4])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 100)) + theme(legend.position='none', axis.text=element_text(size=8))
# Si Area under the curve
# c <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,6])) + geom_boxplot(aes(fill = factor(full_input[,2]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))
# 
# d <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,7])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))
# 
# e <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,6])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))
# 
# f <- ggplot(data = full_input, aes(x = as.factor(full_input[,1]), y = full_input[,7])) + geom_boxplot(aes(fill = factor(full_input[,1]))) + scale_x_discrete(name ="") +
#   scale_y_continuous(name ="%", limits=c(0, 1)) + theme(legend.position='none', axis.text=element_text(size=8))

# plot_grid(a, b, c, d, e, f, labels=c("POD", "FAR", "ACC", "PREC", "Recall", "F1.score"), ncol = 2, nrow = 3)
# 
# ggdraw() +
#   draw_plot(a, 0, .5, .33, .5) +
#   draw_plot(b, .33, 0.5, .33, .5) +
#   draw_plot(c, .66, 0.5, .33, .5) +
#   draw_plot(d, 0, 0, .33, 0.5) +
#   draw_plot(e, .33, 0, .33, 0.5) +
#   draw_plot(f, .66, 0, .33, 0.5) +
#   draw_plot_label(c("POD", "FAR", "AUC", "PREC", "Recall", "F1.score"), c(0.165, 0.5, 0.82, 0.165, 0.5, 0.82), c(0.99, 0.99,0.99, 0.49, 0.49, 0.49), size = 10)
# 
# dev.print(png, filename = paste("C:/Users/aurelien.beaufort/Documents/Neural_Network/OUTPUT/Graph_critères/Graphiques_comparatifs_test_moy30_RANDOM.png", sep=""), width=15 , height=7, units="in", res = 500)
# dev.off()

ggdraw() +
  draw_plot(a, 0, 0, .33, 1) +
  draw_plot(b, .33, 0, .33, 1) +
  draw_plot(c, .66, 0, .33, 1) +
  draw_plot_label(c("POD", "FAR", "F.score"), c(0.165, 0.5, 0.82), c(0.99, 0.99,0.99), size = 10)
