library(terra)
library(imageRy)
 
setwd("C:/Users/elena/OneDrive - Alma Mater Studiorum Università di Bologna/Desktop/immagini")
big25_b2 <- rast("T32TQS_20250611T101041_B02_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(714661, 720554, 5145276, 5149034) #xmin, xmax, ymin, ymax
blue25 <- crop(big25_b2, aoi)


big25_b3 <- rast("T32TQS_20250611T101041_B03_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(714661, 720554, 5145276, 5149034) 
green25 <- crop(big25_b3, aoi)


big25_b4 <- rast("T32TQS_20250611T101041_B04_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(714661, 720554, 5145276, 5149034) #xmin, xmax, ymin, ymax
red25 <- crop(big25_b4, aoi)


big25_b8 <- rast("T32TQS_20250611T101041_B08_10m.jp2")  # la funzione rast fa parte del pacchetto terra
aoi <- ext(714661, 720554, 5145276, 5149034) #xmin, xmax, ymin, ymax
nir25 <- crop(big25_b8, aoi)


mar2025 <- c(blue25, green25, red25, nir25)   1, 2, 3, 4  #crea elemento con tutte le bande sovrapposte, se lo plotto me le plotta tutte in automatico
#anche se me ne mette solo 3 invecce di 4 e non ho capito perché


im.plotRGB(mar2025, 3, 2, 1) #colori  naturali

im.plotRGB(mar25, 4, 3, 2) #NIR nel rosso

ndvi25 <- im.ndvi(mar25, 4, 3)
plot(ndvi25)

writeRaster(ndvi, "NDVI2025.tif")  #esporta raster ndvi nella wd

#salvo pdf con il plot ndvi
pdf("NDVI2025.pdf")
plot(ndvi25)
dev.off()





                          
