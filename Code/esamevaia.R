library(terra)
library(imageRy)
library(viridis)
 
setwd("C:/Users/elena/OneDrive - Alma Mater Studiorum Università di Bologna/Desktop/immagini/vaia")
v2018b2 <- rast("T32TPS_20180623T101029_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(675632, 681748, 5099278, 5102177) #xmin, xmax, ymin, ymax   675632  5102177  681748  5099278
blu18 <- crop(v2018b2, aoi)


#####avrebbe senso ritagliare tutto a parte, e poi importarle nello script principale. E magari mettere script con come le ho ritagliate in file a parte. Più ordinato?
#però allora dovrei ri esportarle sul pc in formato tiff?
#RITAGLIO IMMAGINI PRE VAIA

v2018b3 <- rast("T32TPS_20180623T101029_B03_10m.jp2")
gre18 <- crop(v2018b3, aoi)

v2018b4 <- rast("T32TPS_20180623T101029_B04_10m.jp2")
red18 <- crop(v2018b4, aoi)

v2018b8 <- rast("T32TPS_20180623T101029_B08_10m.jp2")
nir18 <- crop(v2018b8, aoi)


vaia18 <- c(blu18, gre18, red18, nir18) #1,2, 3, 4  #crea elemento con tutte le bande sovrapposte, se lo plotto me le plotta tutte in automatico

#RITAGLIO IMMAGINI POST VAIA

v2019b2 <- rast("T32TPS_20190626T102031_B02_10m.jp2")
blu19 <- crop(v2019b2, aoi)

v2019b3 <- rast("T32TPS_20190626T102031_B03_10m.jp2")
gre19 <- crop(v2019b3, aoi)

v2019b4 <- rast("T32TPS_20190626T102031_B04_10m.jp2")
red19 <- crop(v2019b4, aoi)

v2019b8 <- rast("T32TPS_20190626T102031_B08_10m.jp2")
nir19 <- crop(v2019b8, aoi)

vaia19 <- c(blu19, gre19, red19, nir19)


#colori naturali e nir 2018
im.plotRGB(vaia18, 3, 2, 1) #colori  naturali
im.plotRGB(vaia18, 4, 3, 2) #NIR nel rosso


#confronto nir 2018/2019
par(mfrow=c(1,2))
im.plotRGB(vaia18, 4, 3, 2)
im.plotRGB(vaia19, 4, 3, 2)


#NDVI 2018 
ndvi18 <- im.ndvi(vaia18, 4, 3)

#NDVI 2019
ndvi19 <- im.ndvi(vaia19, 4, 3)

par(mfrow=c(1,2))
plot(ndvi18)
plot(ndvi19)


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
