library(terra)
library(imageRy)
library(viridis)
library(viridisLite)
library(ggplot2)
library(ggridges)


setwd("C:/Users/elena/Downloads")

b2018b210m <- rast("T17RQK_20180928T160511_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
b2018b310m <- rast("T17RQK_20180928T160511_B03_10m.jp2")
b2018b410m <- rast("T17RQK_20180928T160511_B04_10m.jp2")
b2018b810m <- rast("T17RQK_20180928T160511_B08_10m.jp2")

bahamas18_10m <- c(b2018b210m, b2018b310m, b2018b410m, b2018b810m)

b2019b210m <- rast("T17RQK_20191003T160511_B02_10m.jp2")
b2019b310m <- rast("T17RQK_20191003T160511_B03_10m.jp2")
b2019b410m <- rast("T17RQK_20191003T160511_B04_10m.jp2")
b2019b810m <- rast("T17RQK_20191003T160511_B08_10m.jp2")

bahamas19_10m <- c(b2019b210m, b2019b310m, b2019b410m, b2019b810m)

b2021b210m <- rast("T17RQK_20211027T160509_B02_10m.jp2")
b2021b310m <- rast("T17RQK_20211027T160509_B03_10m.jp2")
b2021b410m <- rast("T17RQK_20211027T160509_B04_10m.jp2")
b2021b810m <- rast("T17RQK_20211027T160509_B08_10m.jp2")

bahamas21_10m <- c(b2021b210m, b2021b310m, b2021b410m, b2021b810m)


####e poi eventualmente aggiungere anche 2023



aoi <- ext(746355, 767184, 2944088, 2951892) #xmin, xmax, ymin, ymax   675632  5102177  681748  5099278

b18_10m <- crop(bahamas18_10m, aoi)
b19_10m <- crop(bahamas19_10m, aoi)
b21_10m <- crop(bahamas21_10m, aoi)


par(mfrow=c(3,1))
plot(b18_10m[[4]]) 
plot(b19_10m[[4]])
plot(b21_10m[[4]])
#si vede già che la riflettanza nel NIR è diminuita


im.plotRGB(b18_10m, 3, 2, 1)
im.plotRGB(b19_10m, 3, 2, 1)
im.plotRGB(b21_10m, 3, 2, 1)


im.plotRGB(b18_10m, 4, 3, 2)
im.plotRGB(b19_10m, 4, 3, 2)
im.plotRGB(b21_10m, 4, 3, 2)

ndvi18 <- im.ndvi(b18_10m, 4, 3)
ndvi19 <- im.ndvi(b19_10m, 4, 3)
ndvi21 <- im.ndvi(b21_10m, 4, 3)

ndvi <- c(ndvi18, ndvi19, ndvi21)
plot(ndvi, col = inferno(100))


names(ndvi) =c("NDVI 2018", "NDVI 2019", "NDVI 2021") # Per assegnare i nomi alle due immagini del vettore
# Applicazione della funzione im.ridgeline del pacchetto imageRy
im.ridgeline(ndvi, scale=2, palette="viridis")
#che gioia si vede effettivamente la differenza molto  bene

pairs(ndvi)                                                                                # creazione matrice scatterplot 
plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2018", ylab="NDVI 2019", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red") 

#il fatto che ci sia incluso anche un pezzo di mare sballa i risultati?

cfr = c(ndvi18, ndvi21)
pairs(cfr)                                                                                # creazione matrice scatterplot 
plot(cfr[[1]], cfr[[2]], xlab="NDVI 2018", ylab="NDVI 2021", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red") 
#quindi il 2021 ha comunque NDVI più basso, però non in maniera pronunciata come nel primo confronto

#il fatto che ci sia incluso anche un pezzo di mare sballa i risultati?




d_ndvi <- ndvi[[2]] - ndvi[[1]]
plot(d_ndvi, col = inferno(100))


d_ndvi1821 <- ndvi[[3]] - ndvi[[1]]
plot(d_ndvi1821, col = inferno(100))
#qui dal grafico non si capisce bene perché i valori sono molto vicini allo 0
#bisognerebbe guardare la distribuzione dei pixel





#classificazione non supervisionata

par(mfrow=c(2,1))
im.classify(ndvi18, num_clusters = 4, do_plot = TRUE)
im.classify(ndvi19, num_clusters = 4, do_plot = TRUE)

#potrebbe funzionare tbh. Non saprei con quanti cluster però. O forse è meglio se decido io le categorie di ndvi?
#in quel caso mi serve un criterio secondo cui definirle






####
##ORA PROVO A FARE NDMI

#Sentinel-2 NDMI = (B08 - B11) / (B08 + B11)

#provo importando bande 8A e 11 con risoluzione 20m


b2018b8A20m <- rast("T17RQK_20180928T160511_B8A_20m.jp2") 
b2018b1120m <- rast("T17RQK_20180928T160511_B11_20m.jp2")

b2018b420m <- rast("T17RQK_20180928T160511_B04_20m.jp2")


b2021b8A20m <- rast("T17RQK_20211027T160509_B8A_20m.jp2") 
b2021b1120m <- rast("T17RQK_20211027T160509_B11_20m.jp2")

b2021b420m <- rast("T17RQK_20211027T160509_B04_20m.jp2")



b18_20m <- c(b2018b8A20m, b2018b1120m, b2018b420m)
b21_20m <- c(b2021b8A20m, b2021b1120m, b2021b420m)

b18_20m <- crop(b18_20m, aoi)
b21_20m <- crop(b21_20m, aoi)



ndmi18 <- (b18_20m[[1]]-b18_20m[[2]])/(b18_20m[[1]]+b18_20m[[2]])
ndmi21 <- (b21_20m[[1]]-b21_20m[[2]])/(b21_20m[[1]]+b21_20m[[2]])
ndmi <- c(ndmi18, ndmi21)
plot(ndmi)

#i valori sono notevolmente più bassi nel 2021, 
#quindi anche se la vegetazione si è un po' ripresa, c'è stress idrico importante 



xndvi18 <- im.ndvi(b18_20m, 1, 3)
xndvi21 <- im.ndvi(b21_20m, 1, 3)
xndvi = c(xndvi18, xndvi21)

par(mfrow=c(2,2))
plot(xndvi18)
plot(xndvi21)
plot(ndvi18)
plot(ndvi21)

#confronto tra NDVI classico e quello con 8A

par(mfrow=c(2,1))

names(ndvi) =c("NDVI 2018", "NDVI 2021") # Per assegnare i nomi alle due immagini del vettore
# Applicazione della funzione im.ridgeline del pacchetto imageRy
p1 <- im.ridgeline(ndvi, scale=2, palette="viridis")
#che gioia si vede effettivamente la differenza molto  bene

names(xndvi) =c("xNDVI 2018", "xNDVI 2021") # Per assegnare i nomi alle due immagini del vettore
# Applicazione della funzione im.ridgeline del pacchetto imageRy
p2 <- im.ridgeline(xndvi, scale=2, palette="viridis")
#che gioia si vede effettivamente la differenza molto  bene

p1/p2

#boh allora gli ndvi sono praticamente uguali
#però non sono comunque sicura che ndmi vada bene anche con 8A perché non mi fido di chat



