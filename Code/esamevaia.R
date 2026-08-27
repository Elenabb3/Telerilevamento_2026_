library(terra)
library(imageRy)
library(viridis)
 
setwd("C:/Users/elena/OneDrive - Alma Mater Studiorum Università di Bologna/Desktop/immagini/vaia")

#####avrebbe senso ritagliare tutto a parte, e poi importarle nello script principale. E magari mettere script con come le ho ritagliate in file a parte. Più ordinato?
#però allora dovrei ri esportarle sul pc in formato tiff?


########################
### ??? sono strane le immagini a colori reali di tutti gli anni tranne 2026. Capire perché!!!!
#######################


#RITAGLIO IMMAGINI PRE VAIA
v2018b2 <- rast("T32TPS_20180623T101029_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(675632, 681748, 5099278, 5102177) #xmin, xmax, ymin, ymax   675632  5102177  681748  5099278
blu18 <- crop(v2018b2, aoi)

v2018b3 <- rast("T32TPS_20180623T101029_B03_10m.jp2")
gre18 <- crop(v2018b3, aoi)

v2018b4 <- rast("T32TPS_20180623T101029_B04_10m.jp2")
red18 <- crop(v2018b4, aoi)

v2018b8 <- rast("T32TPS_20180623T101029_B08_10m.jp2")
nir18 <- crop(v2018b8, aoi)

#RITAGLIO IMMAGINI POST VAIA

v2019b2 <- rast("T32TPS_20190626T102031_B02_10m.jp2")
blu19 <- crop(v2019b2, aoi)

v2019b3 <- rast("T32TPS_20190626T102031_B03_10m.jp2")
gre19 <- crop(v2019b3, aoi)

v2019b4 <- rast("T32TPS_20190626T102031_B04_10m.jp2")
red19 <- crop(v2019b4, aoi)

v2019b8 <- rast("T32TPS_20190626T102031_B08_10m.jp2")
nir19 <- crop(v2019b8, aoi)

#RITAGLIO IMMAGINI 2022

v2022b2 <- rast("T32TPS_20220612T100559_B02_10m.jp2")
blu22 <- crop(v2022b2, aoi)

v2022b3 <- rast("T32TPS_20220612T100559_B03_10m.jp2")
gre22 <- crop(v2022b3, aoi)

v2022b4 <- rast("T32TPS_20220612T100559_B04_10m.jp2")
red22 <- crop(v2022b4, aoi)

v2022b8 <- rast("T32TPS_20220612T100559_B08_10m.jp2")
nir22 <- crop(v2022b8, aoi)

#RITAGLIO IMMAGINI 2026

v2026b2 <- rast("T32TPS_20260628T101041_B02_10m.jp2")
blu26 <- crop(v2026b2, aoi)

v2026b3 <- rast("T32TPS_20260628T101041_B03_10m.jp2")
gre26 <- crop(v2026b3, aoi)

v2026b4 <- rast("T32TPS_20260628T101041_B04_10m.jp2")
red26 <- crop(v2026b4, aoi)

v2026b8 <- rast("T32TPS_20260628T101041_B08_10m.jp2")
nir26 <- crop(v2026b8, aoi)



#CREAZIONE DEGLI STACK DI IMMAGINI
vaia18 <- c(blu18, gre18, red18, nir18) #1,2, 3, 4  #crea elemento con tutte le bande sovrapposte, se lo plotto me le plotta tutte in automatico
vaia19 <- c(blu19, gre19, red19, nir19)
vaia22 <- c(blu22, gre22, red22, nir22)
vaia26 <- c(blu26, gre26, red26, nir26)


#dovrei anche  plottare le bande separate verso l'inizio del progetto, o qualcosa del genere



#colori naturali e nir 2018
im.plotRGB(vaia18, 3, 2, 1) #colori  naturali
im.plotRGB(vaia18, 4, 3, 2) #NIR nel rosso


#confronto nir 2018/2019
par(mfrow=c(2,2))
nir18 <- im.plotRGB(vaia18, 4, 3, 2)
nir19 <- im.plotRGB(vaia19, 4, 3, 2)
nir22 <- im.plotRGB(vaia22, 4, 3, 2)
nir26 <- im.plotRGB(vaia26, 4, 3, 2)


#NDVI dei vari anni
ndvi18 <- im.ndvi(vaia18, 4, 3)
ndvi19 <- im.ndvi(vaia19, 4, 3)
ndvi22 <- im.ndvi(vaia22, 4, 3)
ndvi26 <- im.ndvi(vaia26, 4, 3)

ndvi <- c(ndvi18, ndvi19, ndvi22, ndvi26)
plot(ndvi, col=inferno(100))


### si vede la perdita di superficie forestale subito dopo, e poi la ripresa negli anni successivi
## nel 2026 i valori di ndvi mi sembrano anche maggiori. Immagino perché la vegetazione è nuova e più giovane/in salute? Oppure vegetazione più erbacea/arbustiva che può dare valori di ndvi maggiori
# poi da quel che so ora la vegetazione è più diversificata ora che sta ricrescendo perché non è più solo abete rosso, ha senso che le latifoglie abbiano più riflettanza
# sarebbe carino cercare mappe vegetazione per avvalorare che prima era solo abete rosso
# confronto con cartina successioni italia che mi dice verso quale tipo di vegetazione tende naturalmente la successione

diff18_26 <- ndvi26 - ndvi18
plot(diff18_26)


##matrice che mi fa vedere tutti i confronti tra i vari anni, non so se ha senso veramente metterla però divertente

anni <- c("2018", "2019", "2022", "2026")


par(mfrow = c(4, 4))

for (i in 1:4) {
  for (j in 1:4) {
    
    diff <- ndvi[[j]] - ndvi[[i]]
    
    plot(diff,
         main = paste(anni[j], "-", anni[i]))
         
  }
}




#voglio calcolare le percentuali di valori positivi e negativi

# numero totale di celle valide
tot <- global(!is.na(diff18_26), "sum", na.rm = TRUE)[1,1]

# celle con differenza positiva
pos <- global(diff18_26 > 0, "sum", na.rm = TRUE)[1,1]

# celle con differenza negativa
neg <- global(diff18_26 < 0, "sum", na.rm = TRUE)[1,1]

# celle uguali a zero
zero <- global(diff18_26 == 0, "sum", na.rm = TRUE)[1,1]

# percentuali
perc_pos <- pos / tot * 100
perc_neg <- neg / tot * 100
perc_zero <- zero / tot * 100

#OPPPURE
perc_pos <- pos / ncell(diff18_26) * 100
perc_neg <- neg / ncell(diff18_26) * 100
perc_zero <- zero / ncell(diff18_26) * 100


perc_pos
perc_neg
perc_zero


#la percentuale di pixel in aumento è significativamente maggiore di quelli in perdita (70/30) quindi al netto, nonostante la temporanea perdita subito dopo vaia, c'è stato un aumento di valori di ndvi dal 2018 al 2026
#coerentemente a quanto sembrava dalle immagini




###PROVO A FARE UN RIDGELINE PLOT

vaia_ridg=c(ndvi18, ndvi19)  
names(vaia_ridg) =c("NDVI 2018", "NDVI 2019") # Per assegnare i nomi alle due immagini del vettore
# Applicazione della funzione im.ridgeline del pacchetto imageRy
im.ridgeline(vaia_ridg, scale=2, palette="viridis")



####PROVO A FARE UNO SCATTERPLOT

ndvi=c(ndvi18, ndvi19)

# Verifica del concatenamento  
plot(ndvi[[1]])     # NDVI pre-evento 
plot(ndvi[[2]])     # NDVI post-evento 



# Scatterplot -> non sono male per veder meglio se veramente c'è stato un aumento o diminuzione dell'ndvi o se sembra solo dalle immagini
### PROVA SCATTERPLOT
ndvi=c(ndvi18, ndvi19)
plot(ndvi[[1]])     # NDVI pre-evento 
plot(ndvi[[2]]) 

pairs(ndvi)                                                                                # creazione matrice scatterplot 
plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2018", ylab="NDVI 2019", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red")                            
#è effettivamente diminuito

ndvi=c(ndvi19, ndvi22)
pairs(ndvi)                                                                                # creazione matrice scatterplot 
plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2018", ylab="NDVI 2019", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red")
#è effettivamente aumentato

ndvi=c(ndvi18, ndvi22)
pairs(ndvi)                                                                                # creazione matrice scatterplot 
plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2018", ylab="NDVI 2022", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red")
#??

ndvi=c(ndvi18, ndvi26)
pairs(ndvi)                                                                                # creazione matrice scatterplot 
plot(ndvi[[1]], ndvi[[2]], xlab="NDVI 2018", ylab="NDVI 2026", main="Scatterplot NDVI")    # scatterplot NDVI pre e post-evento 
abline(0, 1, col="red")
#è aumentato proprio rispetto alla situazione di partenza, come sembrava dalle immagini
#però io non so realmente leggere gli scatterplot quindi forse mi dovrei informare meglio
                          
### PROVA CLASSIFICAZIONE in base all'ndvi


class_matrix <- matrix(c(-Inf, 0.2, 1, 
                         0.2, 0.4, 2, 
                         0.4, Inf, 3), 
                       ncol = 3, byrow = TRUE)

classi18 <- classify(ndvi18, class_matrix)
classi19 <- classify(ndvi19, class_matrix)
classi22 <- classify(ndvi22, class_matrix)
classi26 <- classify(ndvi26, class_matrix)

classi <- c(classi18, classi19, classi22, classi26)
plot(classi)

levels(classi18) <- data.frame(
  value = c(1, 2, 3),
  label = c("basso", "medio", "alto")
)
plot(classi18)

###ci sta ha senso, si vede quello che vorrei vedere. Però non saprei giustificare perché le classi sono state suddivise in questo modo
#anche quelli degli esami precedenti, su cosa si sono basati?


#e ora calcolo le percentuali, ad esempio: quanta percentuale di vegetazione è stata persa subito dopo l'evento?


f18 <- freq(classi18) 
prop18 <- f18$count / ncell(classi18)
perc18 <- prop18 * 100

f19 <- freq(classi19) 
prop19 <- f19$count / ncell(classi19)
perc19 <- prop19 * 100

#dopodichè si può fare tabella e barplot per visualizzare meglio le differenze







#alcuni esami fanno anche il DVI, io sinceramente non ne vedo l'utilità, tanto mi dice le stesse cose dell'ndvi e comunque non saprei come commentarlo diversamente
#o forse può avere l'utilità di dare valori assoluti che potrebbero essere utili per calcolare certe cose? BOH

#cercare letteratura che parli dell'evento vaia, interazione col bostrico, interventi che sono poi stati fatti per far riprendere il bosco

### fare differenze di ndvi per verificare effettivi cambiamenti

### fare classificazione e percentuali varie per vedere quanto bosco è stato perso ecc...
 # con quale criterio dovrei dividere le 3 classi? Vedi esami e script lezioni

### !!!! però, io sono effettivamente in grado di distinguere cosa è bosco e cosa è prime fasi della successione? -> nell'esame su campo imperatore lo hanno fatto
 # sarebbe simpatico  andare a levico e guardare com'è adesso il versante, per capire effettivamente che succede. Ha senso che ci siano valori apparentemente così tanto più alti di ndvi nel 2026?
 # teoricamente le immagini dovrebbero essere comparabili, e dovrei aver caricato le bande giuste nei posti giusti.

#cambiare anche area di interesse per togliere quella parte di nuvole che c'è in alto a destra nel 2026. Anche fare su un'area più piccola dovrebbe andare bene



#si potrebbero concatenare gli ndvi in uno stack per scriverli più in fretta ed evitarsi il multiframe ogni volta

ndvi <- c(ndvi18, ndvi19)
diff_ndvi <- ndvi[[2]] - ndvi[[1]]
plot(diff_ndvi, col=inferno(100))

#ndvi per lo più in calo, come era attendibile dalle singole immagini



#proseguire con le immagini tot anni dopo 


writeRaster(ndvi, "NDVI2025.tif")  #esporta raster ndvi nella wd

#salvo pdf con il plot ndvi
pdf("NDVI2025.pdf")
plot(ndvi25)
dev.off()
