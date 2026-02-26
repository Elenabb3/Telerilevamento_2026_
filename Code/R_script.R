# first R script

#creazione di un vettore/array
vettore1 <- c(10,8,3,1,0)
vettore2 <- c(3,10,20,50,100)

plot(vettore2, vettore1, col="blue", pch=19, cex=2, xlab="pollution", ylab="numero di delfini")

#INSTALLAZIONE PACCHETTI
#CRAN: comprehensive R archive network, ci sono dentro tutti i pacchetti di R
#Pacchetto TERRA: per spatial analysis con vettori e raster
install.packages("terra")
library(terra) #richiama il pacchetto che ho già installato in precedenza

#voglio installare un altro pacchetto da github, perché lì c'è quello aggiornato dal prof
install.packages("devtools")
library(devtools)
install_github("ducciorocchini/imageRy")
library(imageRy) #mi da errore, risolvere con chatgpt
im.list() #restituisce la lista di immagini
