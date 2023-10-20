install.packages("tidyverse")
install.packages("ggplot2")

library(tidyverse)
library(ggplot2)

path <- "/Users/lise/Desktop/TER_local/jaspar.genereg.net_download_data_2022_CORE_JASPAR2022_CORE_vertebrates_redundant_pfms_meme.txt"
jaspar_data_raw <- readLines(path)

#1.1
# Trouver les indices où chaque motif commence
motif_indices <- grep("^MOTIF", jaspar_data_raw)

# Extraire les motifs
motifs <- lapply(1:(length(motif_indices)-1), function(i) {
  jaspar_data_raw[motif_indices[i]:(motif_indices[i+1]-1)]
})

# Ajout du dernier motif
motifs <- c(motifs, list(jaspar_data_raw[motif_indices[length(motif_indices)]:length(jaspar_data_raw)]))

extract_motif_data <- function(motif_block) {
  motif_name <- sub("MOTIF ", "", motif_block[1])
  url <- motif_block[grep("^URL", motif_block)]
  matrix_indices <- grep("^[0-9]", motif_block)
  matrix_data <- as.matrix(sapply(motif_block[matrix_indices], function(row) {
    as.numeric(unlist(strsplit(row, " ")))
  }))
  
  list(
    name = motif_name,
    url = url,
    matrix = matrix_data
  )
}

jaspar_motifs_data <- lapply(motifs, extract_motif_data)


print(jaspar_motifs_data[[1]])


# Calcul de la longueur de chaque motif
motif_lengths <- sapply(jaspar_motifs_data, function(motif) nrow(motif$matrix))

# Visualisation
#library(ggplot2)
#ggplot(data.frame(Length = motif_lengths), aes(x = Length)) +
  #geom_histogram(fill = "skyblue", color = "black", binwidth = 1) +
  #ggtitle("Distribution de la longueur des motifs") +
  #xlab("Longueur du motif") +
  #ylab("Nombre de motifs")


#motif_freq <- table(motif_lengths)
#top5_motifs <- head(sort(motif_freq, decreasing = TRUE), 5)
#print(top5_motifs)

#barplot(top5_motifs, col = "skyblue", main = "Top 5 des motifs les plus fréquents", 
        #ylab = "Nombre de motifs", xlab = "Longueur du motif")


#1.2

lapply(jaspar_motifs_data[1:5], function(x) dim(x$matrix))
print(jaspar_motifs_data[[1]])


#1.3 reperage
print(motifs[[1]])
#1.4 modification de la matrice extract-fonction-data
extract_motif_data <- function(motif_block) {
  motif_name <- sub("MOTIF ", "", motif_block[1])
  url <- motif_block[grep("^URL", motif_block)]
  
  # Trouvez le début et la fin des données de la matrice 
  matrix_start <- which(grepl("letter-probability matrix:", motif_block)) + 1
  matrix_end <- which(grepl("^URL", motif_block)) - 1
  
  matrix_data <- as.matrix(sapply(motif_block[matrix_start:matrix_end], function(row) {
    as.numeric(unlist(strsplit(row, "\\s+")))
  }))
  
  list(
    name = motif_name,
    url = url,
    matrix = matrix_data
  )
}

# Reprocessez les données
jaspar_motifs_data <- lapply(motifs, extract_motif_data)
#affichage
print(jaspar_motifs_data[[1]])

#autre essai :
extract_motif_data <- function(motif_block) {
  motif_name <- sub("MOTIF ", "", motif_block[1])
  url <- motif_block[grep("^URL", motif_block)]
  
  # Trouvez le début et la fin des données de la matrice 
  matrix_start <- which(grepl("letter-probability matrix:", motif_block)) + 1
  matrix_end <- which(grepl("^URL", motif_block)) - 1
  
  matrix_data <- do.call(rbind, lapply(motif_block[matrix_start:matrix_end], function(row) {
    as.numeric(unlist(strsplit(row, "\\s+")))
  }))
  
  list(
    name = motif_name,
    url = url,
    matrix = matrix_data
  )
}

# Reprocessez les données
jaspar_motifs_data <- lapply(motifs, extract_motif_data)

print(jaspar_motifs_data[[1]])

#essai : 
extract_motif_data <- function(motif_block) {
  motif_name <- sub("MOTIF ", "", motif_block[1])
  url <- motif_block[grep("^URL", motif_block)]
  
  # Trouvez le début et la fin des données de la matrice 
  matrix_start <- which(grepl("letter-probability matrix:", motif_block)) + 1
  matrix_end <- which(grepl("^URL", motif_block)) - 1
  
  matrix_data <- do.call(rbind, lapply(motif_block[matrix_start:matrix_end], function(row) {
    as.numeric(unlist(strsplit(trimws(row), "\\s+")))
  }))
  
  list(
    name = motif_name,
    url = url,
    matrix = matrix_data
  )
}

# Reprocessez les données
jaspar_motifs_data <- lapply(motifs, extract_motif_data)

# Vérifiez à nouveau le premier élément
print(jaspar_motifs_data[[1]])

## données transformées maintenant passage a la visu pour voir les motifs : 

extract_motif_data <- function(motif_block) {
  motif_name <- sub("MOTIF ", "", motif_block[1])
  url <- motif_block[grep("^URL", motif_block)]
  
  # Trouvez le début et la fin des données de la matrice 
  matrix_start <- which(grepl("letter-probability matrix:", motif_block)) + 1
  matrix_end <- which(grepl("^URL", motif_block)) - 1
  
  matrix_data <- do.call(rbind, lapply(motif_block[matrix_start:matrix_end], function(row) {
    as.numeric(unlist(strsplit(row, "\\s+")))
  }))
  
  list(
    name = motif_name,
    url = url,
    matrix = matrix_data
  )
}

# Reprocessez les données
jaspar_motifs_data <- lapply(motifs, extract_motif_data)

print(jaspar_motifs_data[[1]])

#eliminier la colonne NA qui nous gene 

jaspar_motifs_data <- lapply(jaspar_motifs_data, function(motif) {
  motif$matrix <- motif$matrix[,-1]
  return(motif)
})

# Vérifions que la correction a été effectuée correctement
print(jaspar_motifs_data[[1]])

# 1. Analyser la distribution des longueurs des motifs
motif_lengths <- sapply(jaspar_motifs_data, function(motif) nrow(motif$matrix))
ggplot(data.frame(Length = motif_lengths), aes(x = Length)) +
  geom_histogram(fill = "skyblue", color = "black", binwidth = 1) +
  ggtitle("Distribution de la longueur des motifs") +
  xlab("Longueur du motif") +
  ylab("Nombre de motifs")

# 2. Identifier les motifs les plus courants
avg_matrix <- Reduce('+', lapply(jaspar_motifs_data, function(m) m$matrix)) / length(jaspar_motifs_data)
colnames(avg_matrix) <- c("A", "T", "C", "G")

# Afficher la matrice moyenne
print(avg_matrix)

# 3. Créer un Heatmap des motifs
library(ComplexUpset)
library(reshape2)

avg_matrix_melted <- melt(avg_matrix)
colnames(avg_matrix_melted) <- c("Position", "Base", "Frequency")
ggplot(avg_matrix_melted, aes(x = Position, y = Base)) +
  geom_tile(aes(fill = Frequency), color = "white") +
  scale_fill_gradient(low = "white", high = "red") +
  theme_minimal() +
  labs(title = "Heatmap des motifs", x = "Position", y = "Base")

# 4. Identifier les motifs uniques
unique_motifs <- unique(sapply(jaspar_motifs_data, function(m) paste(m$matrix, collapse = "-")))
cat("Nombre de motifs uniques:", length(unique_motifs), "\n")


##autre étape : 
library(stringr)

# Fonction pour obtenir le motif consensus d'une matrice de motif
get_consensus <- function(matrix) {
  consensus <- apply(matrix, 1, function(row) {
    bases <- c("A", "C", "G", "T")
    bases[which.max(row)]
  })
  return(paste(consensus, collapse = FALSE))
}

# Appliquer cette fonction à chaque motif
jaspar_consensus <- sapply(jaspar_motifs_data, function(motif) get_consensus(motif$matrix))

# Afficher les premiers motifs consensus
head(jaspar_consensus)


motif_lengths <- sapply(jaspar_motifs_data, function(motif) nrow(motif$matrix))

library(ggplot2)
ggplot(data.frame(Length = motif_lengths), aes(x = Length)) +
  geom_histogram(fill = "skyblue", color = "black", binwidth = 1) +
  ggtitle("Distribution de la longueur des motifs") +
  xlab("Longueur du motif") +
  ylab("Nombre de motifs")


##graphique thermique
install.packages("reshape2")
library(reshape2)
library(ggplot2)

avg_matrix_melted <- melt(avg_matrix)
colnames(avg_matrix_melted) <- c("Position", "Base", "Frequency")
ggplot(avg_matrix_melted, aes(x = Position, y = Base)) +
  geom_tile(aes(fill = Frequency), color = "white") +
  scale_fill_gradient(low = "white", high = "blue") +
  theme_minimal() +
  labs(title = "Heatmap des motifs", x = "Position", y = "Base")


summary(motif_lengths)  # pour obtenir des statistiques descriptives

ggplot(data.frame(Length = motif_lengths), aes(x = Length)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  ggtitle("Distribution de la longueur des motifs") +
  xlab("Longueur du motif") +
  ylab("Nombre de motifs")


##autre visu : # Visualisation
library(ggplot2)
ggplot(data.frame(Length = motif_lengths), aes(x = Length)) +
  geom_histogram(fill = "skyblue", color = "black", binwidth = 1) +
  ggtitle("Distribution de la longueur des motifs") +
  xlab("Longueur du motif") +
  ylab("Nombre de motifs")


motif_freq <- table(motif_lengths)
top5_motifs <- head(sort(motif_freq, decreasing = TRUE), 5)
print(top5_motifs)

barplot(top5_motifs, col = "skyblue", main = "Top 5 des motifs les plus fréquents", 
        ylab = "Nombre de motifs", xlab = "Longueur du motif")

library(reshape2)
library(ggplot2)

avg_matrix_melted <- melt(avg_matrix)
colnames(avg_matrix_melted) <- c("Position", "Base", "Frequency")
ggplot(avg_matrix_melted, aes(x = Position, y = Base)) +
  geom_tile(aes(fill = Frequency), color = "white") +
  scale_fill_gradient(low = "white", high = "blue") +
  theme_minimal() +
  labs(title = "Heatmap des motifs", x = "Position", y = "Base")


# Calcul des fréquences de longueur de motif
motif_freq <- table(motif_lengths)
# Identification des 5 longueurs de motifs les plus fréquentes
top5_motifs <- head(sort(motif_freq, decreasing = TRUE), 5)

# Visualisation des 5 longueurs de motifs les plus fréquentes
barplot(top5_motifs, col = "skyblue", main = "Top 5 des motifs les plus fréquents", 
        ylab = "Nombre de motifs", xlab = "Longueur du motif")



