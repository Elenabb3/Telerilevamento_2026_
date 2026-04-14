library(terra)
library(viridis)
library(imageRy)

setwd("C:\\Users\\elena\\OneDrive - Alma Mater Studiorum Università di Bologna\\Desktop\\uni\\telerilevamento")
getwd()

list.files()

#importo le bande
gre <- rast("DJI_20260409152942_0001_MS_G.tif")
gre <- flip(gre)
plot(gre)
plot(gre, col=mako(100))

red <- rast("DJI_20260409152942_0001_MS_R.tif")
red <- flip(red)
plot(red)
#molto simile all'immagine che esce con la banda del verde perché sono molto correlate, solite cose

nir <- rast("DJI_20260409152942_0001_MS_NIR.tif")
nir <- flip(nir)
plot(nir)
#la vegetazione abbastanza colorata, le persone molto meno

#stack delle 3 immagini
stack <- c(gre, red, nir)
plot(stack)

#il drone ha 3 sensori per le 3 bande, e l'angolo da cui ogni sensore prende l'immagine è leggermente diverso,
#quindi quando io combino le bande mi aspetto un po' di sfasamento. C'è un modo per sistemarlo (coregistrazione) ma noi non lo facciamo
#perché è pesante e tutto e tanto è a scopo didattico

plotRGB(stack, r=3, g=2, b=1, stretch="lin")

im.multiframe(1,2)
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
