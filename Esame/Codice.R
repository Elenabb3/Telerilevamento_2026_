#=======================
#RICHIAMO DEI PACCHETTI
#=======================

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(ggridges)
library(patchwork)


#IMPORTAZIONE E PREPARAZIONE BANDE

#Definizione della working directory

setwd("C:/Users/elena/Desktop")

#Importazione delle delle bande di Sentinel2 per i 3 anni presi in esame
#rast(), del pacchetto terra, crea oggetti SpatRaster

or2018_b2 <- rast("T17RQK_20181030T155529_B02_10m.jp2")  
or2018_b3 <- rast("T17RQK_20181030T155529_B03_10m.jp2")
or2018_b4 <- rast("T17RQK_20181030T155529_B04_10m.jp2")
or2018_b8 <- rast("T17RQK_20181030T155529_B08_10m.jp2")

or2019_b2 <- rast("T17RQK_20191003T160511_B02_10m.jp2")
or2019_b3 <- rast("T17RQK_20191003T160511_B03_10m.jp2")
or2019_b4 <- rast("T17RQK_20191003T160511_B04_10m.jp2")
or2019_b8 <- rast("T17RQK_20191003T160511_B08_10m.jp2")

or2021_b2 <- rast("T17RQK_20211027T160509_B02_10m.jp2")
or2021_b3 <- rast("T17RQK_20211027T160509_B03_10m.jp2")
or2021_b4 <- rast("T17RQK_20211027T160509_B04_10m.jp2")
or2021_b8 <- rast("T17RQK_20211027T160509_B08_10m.jp2")

#Concatenamento delle bande in stack

or2018 <- c(or2018_b2, or2018_b3, or2018_b4, or2018_b8)
or2019 <- c(or2019_b2, or2019_b3, or2019_b4, or2019_b8)
or2021 <- c(or2021_b2, or2021_b3, or2021_b4, or2021_b8)


#importo anche la banda 11 a risoluzione 20m, servirà più tardi per calcolare l'NDMI
or2018_b11 <- rast("T17RQK_20181030T155529_B11_20m.jp2")
or2019_b11 <- rast("T17RQK_20191003T160511_B11_20m.jp2")
or2021_b11 <- rast("T17RQK_20211027T160509_B11_20m.jp2")


#Definisco l'area di interesse con la funzione ext() del pacchetto terra. 
#Negli argomenti sono indicate le coordinate UTM in questo ordine: xmin, xmax, ymin, ymax

#area ampia
#aoi <- ext(735514, 767529, 2941644, 2954746)

#area ristretta
aoi <- ext(754809, 763308, 2946037, 2953282)


#Ritaglio dell'area di interesse dalle immagini originali con la funzione crop() del pacchetto terra

oct18 <- crop(or2018, aoi)
oct19 <- crop(or2019, aoi)
oct21 <- crop(or2021, aoi)


#ritaglio della banda 11
oct18b11 <- crop(or2018_b11 , aoi)
oct19b11 <- crop(or2019_b11 , aoi)
oct21b11 <- crop(or2021_b11 , aoi)
#b2023b11 <- crop(b2023b11, aoi)


#VISUALIZZAZIONE DATI

#Vsualizzazione a colori naturali con im.plotRGB() e r = rosso, g = verde, b = blu


#se uso la funzione di terra invece che di imagery il multiframe non mi da problemi
par(mfrow=c(1,3))  
plotRGB(oct18, 3, 2, 1, stretch ="lin")
plotRGB(oct19, 3, 2, 1, stretch ="lin")
plotRGB(oct21, 3, 2, 1, stretch ="lin")


png("imgprova.png", width = 800, height = 600, res=100)     # dettagli output 

par(mfrow=c(1,3))
im.plotRGB(oct18, 3, 2, 1)
im.plotRGB(oct19, 3, 2, 1)
im.plotRGB(oct21, 3, 2, 1)

dev.off() 

#Visualizzazione a falsi colori: r = NIR, g = rosso, b = verde

plotRGB(oct18, 4, 3, 2, stretch ="lin", main = "NIR 2018")
plotRGB(oct19, 4, 3, 2, stretch ="lin", main = "NIR 2019")
plotRGB(oct21, 4, 3, 2, stretch ="lin", main = "NIR 2021")

#------------------------------------------------------------------

#NDVI(Normalized Difference Vegetation Index)

#Calcolo ndvi con funzione im.ndvi() di imageRy
ndvi18 <- im.ndvi(oct18, 4, 3)
ndvi19 <- im.ndvi(oct19, 4, 3)
ndvi21 <- im.ndvi(oct21, 4, 3)

ndvi <- c(ndvi18, ndvi19, ndvi21)

#visualizzazione ndvi con palette inferno di viridis
plot(ndvi, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI")

#però vorrei poter modificare i titoletti. Vedo che negli altri esami non hanno fatto la stack ma li hanno plottati  separati

names(ndvi) <- c("2018", "2019", "2021")
plot(ndvi, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE))
#posso fare così e rinominare, oppure

plot(ndvi18, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2018")
plot(ndvi19, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2019")
plot(ndvi21, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2021")
#qui l'unica cosa migliore è che i grafici sono più distanziati e quindi barre e coordinate non sono eccessivamente vicine. BOH?

#aver fatto lo stack prima ha comunque senso, perché mi permette di usare i valori totali  di ndvi per definire la scala
#visualizzarle con la stessa scala è bello, però allo stesso tempo rende più difficile capire quali sono i valori massimi di ndvi dei singoli plot
#è un problema?


#Ridgeline plot dei valori di ndvi

names(ndvi) =c("NDVI 2018", "NDVI 2019", "NDVI 2021") #Assegna i nomi alle immagini nell'oggetto ndvi
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
plot(d_ndvi18_19, col = viridis(100)) #giusto perchè nel 2019 è più basso qunidi vengono valori negativi

d_ndvi19_21 <- ndvi[[3]] - ndvi[[2]]
plot(d_ndvi19_21, col = inferno(100))
#qui dal grafico non si capisce bene perché i valori sono molto vicini allo 0
#bisognerebbe guardare la distribuzione dei pixel

d_ndvi18_21 <- ndvi[[3]] - ndvi[[1]]
plot(d_ndvi18_21, col = inferno(100))

#c'è sempre il problema delle scale


#----------------------------------------------------
#NDMI (Normalized Difference Moisture Index)

#ricampionamento della banda 8 per portarla a risoluzione 20m

oct18b8_20m <- resample(oct18[[4]], oct18b11, method = "average")
oct19b8_20m <- resample(oct19[[4]], oct19b11, method = "average")
oct21b8_20m <- resample(oct21[[4]], oct21b11, method = "average")
#b2023b8_20m <- resample(b23_10m[[4]], b2023b11, method = "average")


ndmi18 <- (oct18b8_20m - oct18b11)/(oct18b8_20m + oct18b11)
ndmi19 <- (oct19b8_20m - oct19b11)/(oct19b8_20m + oct19b11)
ndmi21 <- (oct21b8_20m - oct21b11)/(oct21b8_20m + oct21b11)
#ndmi23 <- (b2023b8_20m-b2023b11)/(b2023b8_20m+b2023b11)
ndmi <- c(ndmi18, ndmi19, ndmi21)
plot(ndmi, col = mako(100)) 


#differenza di ndmi tra 2018 e 2021
d_ndmi18_21 <- ndmi[[3]] - ndmi[[1]]
plot(d_ndmi18_21, col = inferno(100))
#non capisco come interpretare i segni


#lo scatterplot mi conferma che è sostanzialemnte diminuito
ndmi18_21 <- c(ndmi18, ndmi21)
pairs(ndmi18_21)                                                                                # creazione matrice scatterplot 
plot(ndmi18_21[[1]], ndmi18_21[[2]], xlab="NDMI 2018", ylab="NDMI 2021", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red") 



#aggiunger ridgeline?
names(ndmi) <- c("NDMI 2018", "NDMI 2019", "NDMI 2021")
im.ridgeline(ndmi, scale=2, palette="viridis")

#direi che l'area rimane in stress idrico importante anche nel 2021, anche se si riprende rispetto al 23
#nel post uragano lo stress idrico per la vegetazione è maggiore, anche per quella che si sta riprendendo
#però, l'ndmi è influenzato anche dalla copertura no? questo non sballa i risultati?






#-------------------------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------------------------
#=============================================================================================================

#CLASSIFICAZIONE IN BASE ALL'NDVI

#classificazione non supervisionata

#par(mfrow=c(3,1))
#im.classify(ndvi18, num_clusters = 4, do_plot = TRUE)
#im.classify(ndvi19, num_clusters = 4, do_plot = TRUE)
#im.classify(ndvi21, num_clusters = 4, do_plot = TRUE)

#potrebbe funzionare tbh. Non saprei con quanti cluster però. O forse è meglio se decido io le categorie di ndvi?
#in quel caso mi serve un criterio secondo cui definirle




#CLASSIFICAZIONE SUPERVISIONATA

#divido così le classi
#<0.2 -> no veg/acqua. 0.2-0.4 -> veg scarsa e/o stressata. 0.4 - 0.7 -> veg in salute. >0.7 -> veg particolarmente densa/florida

cat <- matrix(c(
  -Inf, 0.2,  1,
  0.2, 0.4,  2,
  0.4, 0.7,  3,
  0.7, Inf,  4
), ncol = 3, byrow = TRUE)

ndvi_classi <- classify(ndvi, rcl = cat)

plot(ndvi_classi)



#altra classificazione
#< -0.1 -> acqua/nuvole. -0.1/0.2 -> suolo/no veg. 0.2-0.4 -> scarsa/stressata. >0.4 salute

cat <- matrix(c(
  -Inf, 0.2,  1,
  0.2, 0.4,  2,
  0.4, Inf,  3
), ncol = 3, byrow = TRUE)

classi <- classify(ndvi, rcl = cat)
plot(classi, col=c("grey", "yellow", "darkgreen"))


#i colori fanno cacare, però la classificazione funziona, direi. 
#non mi piace molto che classifichi acqua e suolo nella stessa categoria.
#non avendo mare è un po' meno fastidioso, però è ok se i fiumi figurano come suolo perso?
#potrei anche valutare di mettere 0.3 invece di 0.4 tra le soglie, però non saprei




#PERCENTUALI


freq_18 <- freq(classi[[1]])
perc_18 <- freq_18$count * 100 / ncell(classi)

freq_19 <- freq(classi[[2]])
perc_19 <- freq_19$count * 100 / ncell(classi)

freq_21 <- freq(classi[[3]])
perc_21 <- freq_21$count * 100 / ncell(classi)

#freq_23 <- freq(classi[[4]])
#perc_23 <- freq_23$count * 100 / ncell(classi)

perc_18
perc_19
perc_21
#perc_23

#metto in una tabella

tabout <- data.frame(
  class=c("No veg", "Vegetazione scarsa/stressata", "Vegetazione abbondante"),
  perc18=c(1.7, 62.4, 35.8),
  perc19=c(6.9, 90.0, 3.1),
  perc21=c(4.8, 91.7, 3.5)
)

tabout


#grafici a barre con le percentuali
#da sistemare per bene l'assegnazione dei colori ecc...




#p1 <- ggplot(tabout, aes(x=class, y=perc18, color=class)) +
  geom_bar(stat="identity", fill="white")

#p2 <- ggplot(tabout, aes(x=class, y=perc19, color=class)) +
  geom_bar(stat="identity", fill="white")

#p3 <- ggplot(tabout, aes(x=class, y=perc21, color=class)) +
  geom_bar(stat="identity", fill="white")



colori = c("grey", "yellow", "darkgreen")
#-> per assegnare i colori del grafico, che però sostituirò con una palette
#e quindi lì guardare script sandra per come assegnare i colori


p18 <- ggplot(tabout, aes(x = class, y = perc18, fill = class)) +
  geom_bar(stat = "identity") +
  ylim(0,100) +
  labs(title = "2018",
       x = "Classe",
       y = "Copertura (%)") +
  scale_fill_manual(values = colori) +
  theme_minimal() +
  theme(legend.position = "none")


p19 <- ggplot(tabout, aes(x = class, y = perc19, fill = class)) +
  geom_bar(stat = "identity") +
  ylim(0,100) +
  labs(title = "2019",
       x = "Classe",
       y = "Copertura (%)") +
  scale_fill_manual(values = colori) +
  theme_minimal() +
  theme(legend.position = "none")


p21 <- ggplot(tabout, aes(x = class, y = perc21, fill = class)) +
  geom_bar(stat = "identity") +
  ylim(0,100) +
  labs(title = "2021",
       x = "Classe",
       y = "Copertura (%)") +
  scale_fill_manual(values = colori) +
  theme_minimal() +
  theme(legend.position = "none")


p18 + p19 + p21







#https://ebird.org/species/bnhnut2?continue
#https://shelterboxcanada.org/where-we-work/bahamas/hurricane-dorian/
#https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/ndmi/       ndmi
#https://www.sciencedirect.com/science/article/pii/S235293852300126X     paper su analisi post dorian

#https://support.zendesk.com/hc/it/articles/4408846544922-Formattazione-del-testo-con-Markdown da togliere, guida markdown

#FINE=================================================================


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






