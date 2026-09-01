
#RICHIAMO DEI PACCHETTI

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(ggridges)
#la sandra metteva anche RStoolbox per la classificazione non supervisionata. Serve? a me la fa comunque


#IMPORTAZIONE E PREPARAZIONE BANDE

#Definizione della working directory

setwd("C:/Users/elena/Downloads") #sistemare l'indirizzo che non sarà questo alla fine

#Importazione delle delle bande di Sentinel2 per i 4 anni presi in esame
#Rast(), del pacchetto terra, crea oggetti SpatRaster

b2018b210m <- rast("T17RQK_20181030T155529_B02_10m.jp2")  
b2018b310m <- rast("T17RQK_20181030T155529_B03_10m.jp2")
b2018b410m <- rast("T17RQK_20181030T155529_B04_10m.jp2")
b2018b810m <- rast("T17RQK_20181030T155529_B08_10m.jp2")

b2019b210m <- rast("T17RQK_20191003T160511_B02_10m.jp2")
b2019b310m <- rast("T17RQK_20191003T160511_B03_10m.jp2")
b2019b410m <- rast("T17RQK_20191003T160511_B04_10m.jp2")
b2019b810m <- rast("T17RQK_20191003T160511_B08_10m.jp2")

b2021b210m <- rast("T17RQK_20211027T160509_B02_10m.jp2")
b2021b310m <- rast("T17RQK_20211027T160509_B03_10m.jp2")
b2021b410m <- rast("T17RQK_20211027T160509_B04_10m.jp2")
b2021b810m <- rast("T17RQK_20211027T160509_B08_10m.jp2")

b2023b210m <- rast("T17RQK_20231029T155521_B02_10m.jp2")
b2023b310m <- rast("T17RQK_20231029T155521_B03_10m.jp2")
b2023b410m <- rast("T17RQK_20231029T155521_B04_10m.jp2")
b2023b810m <- rast("T17RQK_20231029T155521_B08_10m.jp2")

#Concatenamento delle bande dei singoli anni in stack

bahamas18_10m <- c(b2018b210m, b2018b310m, b2018b410m, b2018b810m)
bahamas19_10m <- c(b2019b210m, b2019b310m, b2019b410m, b2019b810m)
bahamas21_10m <- c(b2021b210m, b2021b310m, b2021b410m, b2021b810m)



#Definisco l'area di interesse con la funzione ext() del pacchetto terra. 
#Negli argomenti sono indicate le coordinate UTM in questo ordine: xmin, xmax, ymin, ymax
aoi <- ext(735514, 767529, 2941644, 2954746)

#Ritaglio dell'area di interesse dalle immagini originali con la funzione crop() del pacchetto terra

b18_10m <- crop(bahamas18_10m, aoi)
b19_10m <- crop(bahamas19_10m, aoi)
b21_10m <- crop(bahamas21_10m, aoi)
b23_10m <- crop(bahamas23_10m, aoi)


#par(mfrow=c(3,1))
#plot(b18_10m[[4]]) 
#plot(b19_10m[[4]])
#plot(b21_10m[[4]])
#si vede già che la riflettanza nel NIR è diminuita


#VISUALIZZAZIONE DATI

#Vsualizzazione a colori naturali con im.plotRGB() e r = rosso, g = verde, b = blu

im.plotRGB(b18_10m, 3, 2, 1)
im.plotRGB(b19_10m, 3, 2, 1)
im.plotRGB(b21_10m, 3, 2, 1)

#Visualizzazione a falsi colori: r = NIR, g = rosso, b = verde

im.plotRGB(b18_10m, 4, 3, 2)
im.plotRGB(b19_10m, 4, 3, 2)
im.plotRGB(b21_10m, 4, 3, 2)


#------------------------------------------------------------------

#NDVI(Normalized Difference Vegetation Index)

ndvi18 <- im.ndvi(b18_10m, 4, 3)
ndvi19 <- im.ndvi(b19_10m, 4, 3)
ndvi21 <- im.ndvi(b21_10m, 4, 3)
ndvi23 <- im.ndvi(b23_10m, 4, 3)

ndvi <- c(ndvi18, ndvi19, ndvi21, ndvi23)

#visualizzazione ndvi con palette inferno di viridis
plot(ndvi, col = inferno(100))


#Ridgeline plot dei valori di ndvi

names(ndvi) =c("NDVI 2018", "NDVI 2019", "NDVI 2021", "NDVI 2023") #Assegna i nomi alle immagini nell'oggetto ndvi
im.ridgeline(ndvi, scale=2, palette="viridis") #potrei dire qualcosa sulla funzione im.ridgeline?

#-------------------------------------------------------------------
#LO SCATTERPLOT CHE PERò NON SO NEANCHE IO SE METTERLO
#pairs(ndvi)                                                                                # creazione matrice scatterplot 
#plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2018", ylab="NDVI 2019", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
#abline(0, 1, col="red") 

#il fatto che ci sia incluso anche un pezzo di mare sballa i risultati?

#cfr = c(ndvi18, ndvi21)
#pairs(cfr)                                                                                # creazione matrice scatterplot 
#plot(cfr[[1]], cfr[[2]], xlab="NDVI 2018", ylab="NDVI 2021", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
#abline(0, 1, col="red") 
#quindi il 2021 ha comunque NDVI più basso, però non in maniera pronunciata come nel primo confronto
#---------------------------------------------------------------------------------------------------


#Differenze di ndvi tra 2018-2019, 2019-2021, 2018-2021

d_ndvi18_19 <- ndvi[[2]] - ndvi[[1]]
plot(d_ndvi18_19, col = inferno(100))


d_ndvi19_21 <- ndvi[[3]] - ndvi[[2]]
plot(d_ndvi19_21, col = inferno(100))
#qui dal grafico non si capisce bene perché i valori sono molto vicini allo 0
#bisognerebbe guardare la distribuzione dei pixel

d_ndvi18_21 <- ndvi[[3]] - ndvi[[1]]
plot(d_ndvi18_21, col = inferno(100))


#----------------------------------------------------
#NDMI (Normalized Difference Moisture Index)

#intanto richiamo bande che non ho ancora importato, e prendo 11 20m e 8A 20m. Al massimo correggere in seguito

ndmi18 <- (b18_20m[[1]]-b18_20m[[2]])/(b18_20m[[1]]+b18_20m[[2]]) #sistemare poi i riferimenti alle bande
ndmi19 <- (b19_20m[[1]]-b19_20m[[2]])/(b19_20m[[1]]+b19_20m[[2]])
ndmi21 <- (b21_20m[[1]]-b21_20m[[2]])/(b21_20m[[1]]+b21_20m[[2]])
ndmi <- c(ndmi18, ndmi19, ndmi21)
plot(ndmi)

#differenza di ndmi tra 2018 e 2021
d_ndmi18_21 <- ndmi[[3]] - ndmi[[1]]
plot(d_ndmi18_21, col = inferno(100))

#aggiunger ridgeline?
names(ndmi) <- c("NDMI 2018", "NDMI 2019", "NDMI 2021")
im.ridgeline(ndmi, scale=2, palette="viridis")


#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------
#=============================================================================================================

#CLASSIFICAZIONE

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


#https://ebird.org/species/bnhnut2?continue
#https://shelterboxcanada.org/where-we-work/bahamas/hurricane-dorian/
#https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/ndmi/       ndmi
#https://www.sciencedirect.com/science/article/pii/S235293852300126X     paper su analisi post dorian




