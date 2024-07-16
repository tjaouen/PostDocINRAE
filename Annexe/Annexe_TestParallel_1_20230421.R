# Charger les packages doParallel et foreach
library(doParallel)
library(foreach)

# Configurer le cluster doParallel avec 2 travailleurs
cl <- makeCluster(2)
registerDoParallel(cl)

# Créer une matrice de résultats de 3x3 remplie de zéros
results_list <- foreach(i = 1:3, .combine = "rbind", .verbose = T) %:% foreach(j = 1:3, .combine = "rbind", .verbose = T) %dopar% {
  
  print("i")
  print(i)
  print("j")
  print(j)
  
  # Calculer le carré du nombre correspondant à l'indice (i, j)
  x <- i*2+j*2
  square <- x
  
  # Retourner le carré calculé
  return(list(i,j,square))
}

# Convertir la liste en une matrice de 3x3
results <- matrix(results_list, nrow = 3, ncol = 3, byrow = TRUE)

# Afficher la matrice de résultats
print(results)

# Arrêter le cluster doParallel
stopCluster(cl)


# library(doParallel)
# registerDoParallel(cores = 8)
# result <- foreach( A =rep(c(1,2,3),2), B = rep(c(10, 20), each=3), 
#                    .combine='rbind') %dopar% { list(A,B,A*B) }


results_list <- foreach(i = 1:3, .combine = "rbind", .verbose = T) %:%
  foreach(j = 1:3, .combine = "rbind", .verbose = T) %dopar%{
  #foreach(k = 1:3, .combine = "rbind", .verbose = T) %dopar% {
    
    print("i")
    print(i)
    print("j")
    print(j)
    # print("k")
    # print(k)
    
    # Calculer le carré du nombre correspondant à l'indice (i, j)
    x <- i*2+j*2
    square <- x
    
    # Retourner le carré calculé
    return(list(i,j,square))
    #return(list(i,j,k,square))
  }





library(foreach)
library(data.table)

# Créer une grille de toutes les combinaisons possibles de i et j
grid <- expand.grid(i = 1:3, j = 1:3)

# Itérer sur chaque combinaison de i et j et créer un data frame pour chaque itération
df_list <- foreach(idx = 1:nrow(grid), .combine = "list") %dopar% {
  i <- grid$i[idx]
  j <- grid$j[idx]
  list(x = i, y = j, z = i*2+j)
}

# Combinez les data frames dans une seule data frame en utilisant la fonction rbindlist() du package data.table
result_df <- rbindlist(df_list)



sim_n = 10
test <- foreach (i =1:sim_n) %dopar% {
  # Here I'm doing sth. different in reality, so take this just as an example
  sim_power = runif(8, 1, 10)
  sim_rank = runif(8, 1, 10)
  sim_mean = runif(8, 1, 10)
  sim_base = runif(8, 1, 10)
  
  return(list(sim_power, sim_rank, sim_mean, sim_base))
}

library(data.table)

sim_power <- rbindlist(lapply(test,function(x){x[[1]]}))
sim_rank <- rbindlist(lapply(test,function(x){x[[2]]}))
sim_mean <- rbindlist(lapply(test,function(x){x[[3]]}))
sim_base <- rbindlist(lapply(test,function(x){x[[4]]}))



test = foreach (i =1:sim_n) %dopar%
  {
    # Here I'm doing sth. different in reality, so take this just as an example
    sim_power = runif(8, 1, 10)
    sim_rank = runif(8, 1, 10)
    sim_mean = runif(8, 1, 10)
    sim_base = runif(8, 1, 10)
    
    return(list(sim_power, sim_rank, sim_mean, sim_base))
  }



test = foreach (i =1:sim_n) %dopar%
{
  # Here I'm doing sth. different in reality, so take this just as an example
  sim_power = runif(8, 1, 10)
  sim_rank = runif(8, 1, 10)
  sim_mean = runif(8, 1, 10)
  sim_base = runif(8, 1, 10)
  
  return(list(sim_power, sim_rank, sim_mean, sim_base))
}

library(data.table)

sim_power <- rbindlist(lapply(test,function(x){x[[1]]}))
sim_rank <- rbindlist(lapply(test,function(x){x[[2]]}))
sim_mean <- rbindlist(lapply(test,function(x){x[[3]]}))
sim_base <- rbindlist(lapply(test,function(x){x[[4]]}))



# Convertir chaque sous-liste en vecteur
vec_list <- lapply(test, function(x) unlist(x))

# Créer une data frame à partir des vecteurs
result_df <- data.frame(matrix(unlist(vec_list), ncol=length(test[[1]][[1]]), byrow=T))

# Nommer les colonnes de la data frame
colnames(result_df) <- c("sim_power", "sim_rank", "sim_mean", "sim_base")




library(foreach)
library(data.table)

# Données d'entrée : une liste de data frames
df_list <- list(
  data.frame(id = 1:3, value = c(2, 4, 6)),
  data.frame(id = 4:6, value = c(8, 10, 12)),
  data.frame(id = 7:9, value = c(14, 16, 18))
)

# Itérer sur chaque data frame dans la liste, appliquer une fonction et retourner un data frame
result_list <- foreach(df = df_list, .combine = "list") %dopar% {
  # Appliquer la fonction en créant une nouvelle colonne
  df$new_value <- df$value * 2
  
  # Retourner le data frame avec la nouvelle colonne
  return(df)
}

# Combinez tous les data frames résultants en un seul data frame
result_df <- rbindlist(result_list)



# Créer une data frame
df <- data.frame(a = 1:3, b = 4:6, c = 7:9)

# Convertir la data frame en un vecteur d'une seule ligne
vec <- as.vector(unlist(df, recursive = FALSE))

# Afficher le vecteur
print(vec)











library(foreach)
library(data.table)

# Créer une grille de toutes les combinaisons possibles de i et j
grid <- expand.grid(i = 1:3, j = 1:3)

# Itérer sur chaque combinaison de i et j et créer un data frame pour chaque itération
df_list <- foreach(idx = 1:nrow(grid), .combine = "rbind") %dopar% {
  i <- grid$i[idx]
  j <- grid$j[idx]
  data.frame(x = i, y = j, z = i*2+j)
}

# Combinez les data frames dans une seule data frame en utilisant la fonction rbindlist() du package data.table
result_df <- rbindlist(df_list)






