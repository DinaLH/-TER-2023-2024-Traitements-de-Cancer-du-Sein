# Installer les packages si ce n'est pas déjà fait
if (!requireNamespace("data.table", quietly = TRUE)) {
  install.packages("data.table")
}

if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}

# Charger les bibliothèques
library(data.table)
library(tidyverse)
# Lire le fichier en utilisant fread (de data.table) pour une lecture plus rapide
chemin_fichier <- "~/Desktop/resultat_cancer.txt"  # Assurez-vous d'ajuster le chemin si nécessaire

# Lisez seulement les colonnes nécessaires
colonnes_necessaires <- c("motif_id", "motif_alt_id", "sequence_name", "p-value")
matrice_X_data_table <- fread(chemin_fichier, select = colonnes_necessaires)

head(matrice_X_data_table)


##Etudes analytiques de la matrice : 
#1)
summary(matrice_X_data_table$`p-value`)
#2)
ggplot(matrice_X_data_table, aes(`p-value`)) +
  geom_density(fill = "blue", alpha = 0.5) +
  labs(title = "Distribution des p-values", x = "P-value", y = "Densité") +
  theme_minimal()

#3) Nombre de motifs dans la matrice

matrice_X_data_table %>%
  distinct(motif_id) %>%
  nrow()

#4) motifs les plus fréquents 
matrice_X_data_table %>%
  group_by(motif_id) %>%
  tally(sort = TRUE)

#5) On observe la pvalue moyenne par motif : 
matrice_X_data_table %>%
  group_by(motif_id) %>%
  summarise(moyenne_pvalue = mean(`p-value`))

#6) On regarde à travers un heatmap une vue d'ensemble des motifs et de leur significativité
##par rapport aux séquences

#install.packages("heatmaply")

#library("heatmaply")

#matrice_heatmap <- matrice_X_data_table %>%
 # spread(motif_id, `p-value`, fill = NA) 

#heatmaply::heatmaply(matrice_heatmap, scale = "column")
#ce style de heatmap est intéréssat mais nécessite trop de ressources pour des grosses données 
#donc essayons de realiser une ACP sur R pour reduire les données : 

install.packages("pheatmap")
library(pheatmap)

# ACP
acp_result <- prcomp(matrice_X_data_table, scale. = TRUE)

#########
str(matrice_X_data_table)

set.seed(123)  
sample_data <- matrice_X_data_table[sample(.N, 100000)]  # échantillonnage de 100 000 lignes

sample_pvalues <- sample_data$`p-value`
acp_result <- prcomp(sample_pvalues, scale. = TRUE)
# Proportion de la variance expliquée
prop_varexp <- acp_result$sdev^2 / sum(acp_result$sdev^2)
prop_varexp

# Proportion de la variance expliquée par la première composante principale
prop_varexp[1]
# Histogramme des scores de la première composante principale
hist(acp_result$x[,1], main="Distribution des scores de la première composante principale", 
     xlab="Score de la première composante principale", col="skyblue", border="black")





