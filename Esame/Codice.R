#=======================
#RICHIAMO DEI PACCHETTI
#=======================

library(terra)      # Visualizzazione e manipolazione di raster spaziali
library(imageRy)    # Calcolo dell'ndvi, creazione ridgeline plots
library(viridis)    # Palette chiare e adatte per il daltonismo
library(ggplot2)    # Creazione di barplot
library(ggridges)   # Creazione di ridgeline plots - ma ho usato la funzione di imagery, serve comunque?
library(patchwork)  # Visualizzazione e affiancamento di grafici

#====================================
#IMPORTAZIONE E PREPARAZIONE IMMAGINI
#===================================

#Definizione della working directory
setwd("C:/Users/elena/Desktop/Telesame")

#Importazione delle delle bande di Sentinel-2
#con rast(), pacchetto terra, crea oggetti SpatRaster
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

#Concatenamento delle bande in vettori
or2018 <- c(or2018_b2, or2018_b3, or2018_b4, or2018_b8)
or2019 <- c(or2019_b2, or2019_b3, or2019_b4, or2019_b8)
or2021 <- c(or2021_b2, or2021_b3, or2021_b4, or2021_b8)

#Importazione della banda 11 a risoluzione 20m, servirà più tardi per calcolare l'NDMI
or2018_b11 <- rast("T17RQK_20181030T155529_B11_20m.jp2")
or2019_b11 <- rast("T17RQK_20191003T160511_B11_20m.jp2")
or2021_b11 <- rast("T17RQK_20211027T160509_B11_20m.jp2")

#Definizione dell'area di interesse con la funzione ext() del pacchetto terra. 
#Negli argomenti sono indicate le coordinate UTM in questo ordine: xmin, xmax, ymin, ymax
aoi <- ext(754809, 763308, 2946037, 2953282)

#Ritaglio dell'area di interesse con la funzione crop() del pacchetto terra
oct18 <- crop(or2018, aoi)
oct19 <- crop(or2019, aoi)
oct21 <- crop(or2021, aoi)

#Ritaglio della banda 11
oct18b11 <- crop(or2018_b11 , aoi)
oct19b11 <- crop(or2019_b11 , aoi)
oct21b11 <- crop(or2021_b11 , aoi)


#====================
#VISUALIZZAZIONE DATI
#====================

#Vsualizzazione a colori naturali con plotRGB() di terra 
#assegno r = rosso(3), g = verde(2), b = blu(1)

### va bene stretch lineare o è meglio hist? im.plotRGB che tipo di stretch fa in automatico?
par(mfrow=c(1,3))  #divisione del pannello in 3 colonne
plotRGB(oct18, 3, 2, 1, stretch ="lin", main = "RGB 2018") #stretch adatta il range di valori originale a quello consentito dalla visualizzazione
plotRGB(oct19, 3, 2, 1, stretch ="lin", main = "RGB 2019") #in questo caso stretch lineare
plotRGB(oct21, 3, 2, 1, stretch ="lin", main = "RGB 2021")

#Esportazioni immagini in formato png -----------------------------------------
#png("imgprova.png", width = 800, height = 600, res=100)     # dettagli output 
#intanto provo con i valori di default
png("RGB_bahamas.png")
    
par(mfrow=c(1,3))
plotRGB(oct18, 3, 2, 1, stretch ="lin", main = "RGB 2018") 
plotRGB(oct19, 3, 2, 1, stretch ="lin", main = "RGB 2019") 
plotRGB(oct21, 3, 2, 1, stretch ="lin", main = "RGB 2021")

dev.off() 
#-------------------------------------------------------------------------------

#Visualizzazione a falsi colori
#assegno r = NIR(4), g = rosso(3), b = verde(2)
plotRGB(oct18, 4, 3, 2, stretch ="lin", main = "NIR 2018")
plotRGB(oct19, 4, 3, 2, stretch ="lin", main = "NIR 2019")
plotRGB(oct21, 4, 3, 2, stretch ="lin", main = "NIR 2021")


#=============================================
#NDVI(Normalized Difference Vegetation Index)
#=============================================

#Calcolo ndvi con funzione im.ndvi() di imageRy
ndvi18 <- im.ndvi(oct18, 4, 3)
ndvi19 <- im.ndvi(oct19, 4, 3)
ndvi21 <- im.ndvi(oct21, 4, 3)

ndvi <- c(ndvi18, ndvi19, ndvi21) #concatenamento in un vettore

#visualizzazione ndvi con palette viridis
plot(ndvi, col = viridis(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI")

names(ndvi) <- c("NDVI 2018", "NDVI 2019", "NDVI 2021") #modifica nome oggetti, per definire titoli dei singoli plot
plot(ndvi, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE))
#definisco il range di valori tra i valori minimo e massimo assoluto, in modo da avere stessa scala di valori tra le 3 immagini

#posso fare così e rinominare, oppure
plot(ndvi18, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2018")
plot(ndvi19, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2019")
plot(ndvi21, col = inferno(100), nc = 3, range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2021")
#qui l'unica cosa migliore è che i grafici sono più distanziati e quindi barre e coordinate non sono eccessivamente vicine. BOH?

#Ridgeline plot dell'ndvi con im.ridgeline() di imageRy
im.ridgeline(ndvi, scale = 2, palette = "viridis") #scale definisce le dimensioni verticali del plot

#Differenze di ndvi tra 2018-2019, 2019-2021, 2018-2021
d_ndvi18_19 <- ndvi[[2]] - ndvi[[1]]
plot(d_ndvi18_19, col = viridis(100), main = "ΔNDVI 2018-2019")

d_ndvi19_21 <- ndvi[[3]] - ndvi[[2]]
plot(d_ndvi19_21, col = inferno(100), main = "ΔNDVI 2019 - 2021")

d_ndvi18_21 <- ndvi[[3]] - ndvi[[1]]
plot(d_ndvi18_21, col = inferno(100), main = "ΔNDVI 2018 - 2021")


#===========================================
#NDMI (Normalized Difference Moisture Index)
#===========================================

#Ricampionamento della banda 8 per portarla a risoluzione 20m
oct18b8_20m <- resample(oct18[[4]], oct18b11, method = "average")
oct19b8_20m <- resample(oct19[[4]], oct19b11, method = "average")
oct21b8_20m <- resample(oct21[[4]], oct21b11, method = "average")

#Calcolo e visualizzazione NDMI
ndmi18 <- (oct18b8_20m - oct18b11)/(oct18b8_20m + oct18b11)
ndmi19 <- (oct19b8_20m - oct19b11)/(oct19b8_20m + oct19b11)
ndmi21 <- (oct21b8_20m - oct21b11)/(oct21b8_20m + oct21b11)

ndmi <- c(ndmi18, ndmi19, ndmi21)
plot(ndmi, col = mako(100)) 

#Differenza di ndmi tra 2018 e 2021
d_ndmi18_21 <- ndmi[[3]] - ndmi[[1]]
plot(d_ndmi18_21, col = inferno(100))
#non capisco come interpretare i segni #lo scatterplot mi conferma che è sostanzialemnte diminuito

#Scatterplot per confrontare 2018 e 2021
ndmi18_21 <- c(ndmi18, ndmi21)
pairs(ndmi18_21)                                                                                     # creazione matrice scatterplot 
plot(ndmi18_21[[1]], ndmi18_21[[2]], xlab="NDMI 2018", ylab="NDMI 2021", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red")                                                                              # inserisce linea bisettrice?

#Ridgeline plot -> serve?
names(ndmi) <- c("NDMI 2018", "NDMI 2019", "NDMI 2021")
im.ridgeline(ndmi, scale=2, palette="viridis")

#direi che l'area rimane in stress idrico importante anche nel 2021, anche se si riprende rispetto al 23
#nel post uragano lo stress idrico per la vegetazione è maggiore, anche per quella che si sta riprendendo
#però, l'ndmi è influenzato anche dalla copertura no? questo non sballa i risultati?


#=================================
#CLASSIFICAZIONE IN BASE ALL'NDVI
#=================================

#Classificazione supervisionata, con le seguenti classi
# < 0.2 -> suolo/no veg. 0.2-0.4 -> veg. scarsa/stressata. >0.4 veg in salute

#Matrice con le classi
cat <- matrix(c(
  -Inf, 0.2,  1,
  0.2, 0.4,  2,
  0.4, Inf,  3
), ncol = 3, byrow = TRUE)

#Classificazione in base alla matrice
classi <- classify(ndvi, rcl = cat)

#Assegnazione dei nomi delle classi
nomi <-c("Vegetazione assente o morta", "Veg scarsa e/o stressata", "Veg abbondante e/o sana")

#Creazione di una palette + assegnazione dei colori i nomi delle classi, nell'ordine che ho definito con l'oggetto nomi
#funzione setNames() da stats (core package di R)
palette <- setNames(
  viridis(3, option = "viridis"),
  nomi
)

#Mappe della classificazione
plot(classi, col = palette, nc=3)


#Quantificazione della copertura percentuale delle classi
freq_18 <- freq(classi[[1]])  #crea tabella con i pixel di ogni classe nella colonna count
perc_18 <- freq_18$count * 100 / ncell(classi)   #divide valori di frequenza ($count) per il numero di pixel (ncell)

freq_19 <- freq(classi[[2]])
perc_19 <- freq_19$count * 100 / ncell(classi)

freq_21 <- freq(classi[[3]])
perc_21 <- freq_21$count * 100 / ncell(classi)


#Creazione tabella con i risultati
#Arrotondamento a una cifra decimale con round()
tab <- data.frame(
  class= nomi,
  perc18=round(perc_18, 1),
  perc19=round(perc_19, 1),
  perc21=round(perc_21, 1)
)

tab$class <- factor(tab$class, levels = nomi) #ordina le classi secondo il vettore nomi, altrimenti vengono automaticamente messe in ordine alfabetico

##non è obbligatorio, però lo faccio perché voglio che nel barplot le colonne siano nell'ordine morta/scarsa/sana. Rendo anche le cateogorie un dato factor, ovvero una categoria

tab  #visualizzazione della tabella

#====================================
#BARPLOT CON PERCENTUALI DI COPERTURA
#====================================

#ggplot() permette di creare grafici e aggiungere elementi con "+"
#I valori sono presi dalla tabella tab
p18 <- ggplot(tab, aes(x = class, y = perc18, fill = class)) +      # aes() determina come inserire gli elementi di tab nel grafico
  geom_bar(stat = "identity")  +                                    # crea le barre, stat = "indentity" dice di inserire i valori della tabella
  ylim(0,100) +                                                     # range dell'asse y
  scale_fill_manual(values = palette) +                             # assegna colori da una palette creata manualmente
  scale_x_discrete(labels = NULL) +                                 # toglie i nomi delle classi dall'asse x
  labs(title = "2018" , x = NULL, y = "copertura(%)") +             # definizione titolo e nomi degli assi. NULL permette di togliere il nome dell'asse x
  theme_minimal() +                                                 # tema minimal alle grafiche. Sfondo bianco rispetto a quello grigio di default
  theme(legend.position = "none")                                   # elimina la legenda

# Stessa struttura per creare gli altri grafici
p19 <- ggplot(tab, aes(x = class, y = perc19, fill = class)) +
  geom_bar(stat = "identity")  +         
  ylim(0,100) +
  scale_fill_manual(values = palette) +  
  scale_x_discrete(labels = NULL) +
  labs(title = "2019" , x = NULL, y = "copertura(%)") +
  theme_minimal() +
  theme(legend.position = "none") 

p21 <- ggplot(tab, aes(x = class, y = perc21, fill = class)) +
  geom_bar(stat = "identity")  +        
  ylim(0,100) +
  scale_fill_manual(values = palette) +  
  scale_x_discrete(labels = NULL) +
  labs(title = "2021" , x = NULL, y = "copertura(%)", fill = "LEGENDA") +  # fill definisce il titolo della legenda
  theme_minimal()
  # Solo questo grafico contiene la legenda, visto che i 3 plot verranno visualizzati assieme

# Visualizzazione dei 3 grafici affiancati grazie a pacchetto patchwork
p18 + p19 + p21




#https://ebird.org/species/bnhnut2?continue
#https://shelterboxcanada.org/where-we-work/bahamas/hurricane-dorian/
#https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/ndmi/       ndmi
#https://www.sciencedirect.com/science/article/pii/S235293852300126X     paper su analisi post dorian

#https://support.zendesk.com/hc/it/articles/4408846544922-Formattazione-del-testo-con-Markdown da togliere, guida markdown

#FINE=================================================================

