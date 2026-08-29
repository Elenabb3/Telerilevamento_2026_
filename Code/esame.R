library(terra)
library(imageRy)
library(viridis)
 
setwd("C:/Users/elena/OneDrive - Alma Mater Studiorum Università di Bologna/Desktop/immagini")

###immagine 2025
m2025b2 <- rast("T32TQS_20250611T101041_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(714661, 720554, 5145276, 5149034) #xmin, xmax, ymin, ymax
blu25 <- crop(m2025b2, aoi)

m2025b3 <- rast("T32TQS_20250611T101041_B03_10m.jp2")  # la funzione rast fa parte del pacchetto terra
gre25 <- crop(m2025b3, aoi)

m2025b4 <- rast("T32TQS_20250611T101041_B04_10m.jp2")  # la funzione rast fa parte del pacchetto terra
red25 <- crop(m2025b4, aoi)

m2025b8 <- rast("T32TQS_20250611T101041_B08_10m.jp2")  # la funzione rast fa parte del pacchetto terra
nir25 <- crop(m2025b8, aoi)


##immagine 2016
m2016b2 <- rast("T32TQS_20160628T101032_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
blu16 <- crop(m2016b2, aoi)

m2016b3 <- rast("T32TQS_20160628T101032_B03_10m.jp2")  # la funzione rast fa parte del pacchetto terra
gre16 <- crop(m2016b3, aoi)

m2016b4 <- rast("T32TQS_20160628T101032_B04_10m.jp2")  # la funzione rast fa parte del pacchetto terra
red16 <- crop(m2016b4, aoi)

m2016b8 <- rast("T32TQS_20160628T101032_B08_10m.jp2")  # la funzione rast fa parte del pacchetto terra
nir16 <- crop(m2016b8, aoi)

mar16 <- c(blu17, gre16, red16, nir16)  # 1, 2, 3, 4  #crea elemento con tutte le bande sovrapposte, se lo plotto me le plotta tutte in automatico
#anche se me ne mette solo 3 invecce di 4 e non ho capito perché


im.plotRGB(mar25, 3, 2, 1) #colori  naturali

im.plotRGB(mar25, 4, 3, 2) #NIR nel rosso

ndvi25 <- im.ndvi(mar25, 4, 3)
plot(ndvi25)

writeRaster(ndvi, "NDVI2025.tif")  #esporta raster ndvi nella wd

#salvo pdf con il plot ndvi
pdf("NDVI2025.pdf")
plot(ndvi25)
dev.off()




-----

library(terra)
library(imageRy)
library(viridis)

setwd("C:/Users/elena/Downloads")


g2017b2 <- rast("T32TNS_20170626T102021_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(570477, 573271, 5140025, 5144499) #xmin, xmax, ymin, ymax   NW 570477E 5144499N   SE 573271 E 5140025 N
blu17 <- crop(g2017b2, aoi)

g2017b3 <- rast("T32TNS_20170626T102021_B03_10m.jp2")
gre17 <- crop(g2017b3, aoi)

g2017b4 <- rast("T32TNS_20170626T102021_B04_10m.jp2")
red17 <- crop(g2017b4 , aoi)

g2017b8 <- rast("T32TNS_20170626T102021_B08_10m.jp2")
nir17 <- crop(g2017b8, aoi)


g2026b2 <- rast("T32TNS_20260619T101601_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
blu26 <- crop(g2026b2, aoi)

g2026b3 <- rast("T32TNS_20260619T101601_B03_10m.jp2")
gre26 <- crop(g2026b3, aoi)

g2026b4 <- rast("T32TNS_20260619T101601_B04_10m.jp2")
red26 <- crop(g2026b4 , aoi)

g2026b8 <- rast("T32TNS_20260619T101601_B08_10m.jp2")
nir26 <- crop(g2026b8, aoi)


mor17 <- c(blu17, gre17, red17, nir17)
mor26 <- c(blu26, gre26, red26, nir26)


par(mfrow=c(1,2))
im.plotRGB(mor17, 3, 2, 1)
im.plotRGB(mor26, 3, 2, 1)


ndvi17 <- im.ndvi(mor17, 4, 3)
ndvi26 <- im.ndvi(mor17, 4, 3)
ndvi <- c(ndvi17, ndvi26)
plot(ndvi)




                          
