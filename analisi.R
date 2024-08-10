#imports
library(ggplot2)
library(dplyr)
library(tidyr)

#setwd to current folder
setwd("path/to/folder/")

#read data
maggio <- read.csv("path/to/folder//output_clean.csv")
luglio <- read.csv("path/to/folder/output_clean.csv")

#merge data
data <- rbind(maggio, luglio)

#tweak
# data <- maggio
# data <- luglio

#CLEANING
#keep only duplicates where Codice is a number in duplicates
duplicates <- duplicates[duplicates$Codice %in% as.numeric(duplicates$Codice),]
#remove duplicates from data
data <- data[!data$Codice %in% duplicates$Codice,]
#remove rows that have Punti.TOT NA
data <- data[!is.na(data$Punti.TOT),]
#if codice ends with ".0", remove the ".0"
data$Codice <- gsub("\\.0$", "", data$Codice)

#### VARIABILI
posti <- 14823

#calcola punteggio minimo
punteggio_minimo <- sort(data$Punti.TOT, decreasing = T)[posti]

#crea istogramma con classi di ampiezza 2,5 con ggplot2
# ggplot(data, aes(x=Punti.TOT)) +
#   geom_histogram(
#     breaks = seq(20, 90, by = 2),
#     aes(y = ..count..),
#     fill = "blue",
#     colour = "black"
#   ) + 
#   scale_x_continuous(breaks = seq(20, 90, by = 2)) +
#   #rotate 90 degrees the x axis labels
#   theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
# 
#   #add title and labels
#   labs(
#     title = "Distribuzione dei punteggi",
#     x = "Punteggio",
#     y = "Numero di partecipanti"
#   ) + 
#   
#   #add cutoff at punteggio minimo
#   geom_vline(xintercept = punteggio_minimo, color = "red")

#cumulative distribution plot
ggplot(data, aes(x=Punti.TOT)) +
  stat_ecdf(geom = "step") +
  geom_vline(xintercept = punteggio_minimo, color = "red") +
  labs(
    title = "Distribuzione cumulativa dei punteggi luglio",
    x = "Punteggio",
    y = "Percentuale di partecipanti"
  )


print(paste("Numero record:", nrow(data)))
print(paste("Posti considerati: ", posti))
print(paste("Punteggio minimo: ", punteggio_minimo))

#ordering
data <- data[order(data$Punti.TOT, data$Punti.3, data$Punti.4, data$Punti.5, data$Punti.2, data$Punti.1, decreasing = T),]

#add row with progressive numbering starting from 1
data$Progressivo <- 1:nrow(data)

#if codice is from maggio dataset, add "maggio" to column "Sessione", else add "luglio"
data$Sessione <- ifelse(data$Codice %in% maggio$Codice, "maggio", "luglio")

#how many have sessione == "luglio"
print(paste("Numero partecipanti luglio:", nrow(data[data$Sessione == "luglio",])))

#filter by luglio
data <- data[data$Sessione == "maggio",]

#get punteggio minimo
punteggio_minimo <- sort(data$Punti.TOT, decreasing = T)[posti]
punteggio_minimo

write.csv(data, "path/to/folder/maggio_luglio.csv", row.names = F)
