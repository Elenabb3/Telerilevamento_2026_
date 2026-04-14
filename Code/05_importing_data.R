library(terra)
library(viridis)
library(imageRy)
library(patchwork)
library(ggplot2)
library(ggridges)


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

#per vedere la differenza tra i due tipi di stretch
im.multiframe(1,2)
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
plotRGB(stack, r=3, g=2, b=1, stretch="hist")

#NDVI
ndvi <- im.ndvi(stack, 3, 2)
plot(ndvi)

#esportare dati. Lo mette automaticamente nella working directory
writeRaster(ndvi, "ndvi.tif")

#posso reimportarlo usando rast come ho fatto all'inizio con le altre
ndvi2 <- rast("ndvi.tif")
plot(ndvi2)

#avendo esportato il raster, lo vedo fuori in bianco e nero. Se voglio esportarlo come figura invece che come dato:

#creo un png e ci infilo dentro i vari plot
png("figura1.png")
im.multiframe(2,2)
plot(gre)
plot(red)
plot(nir)
plot(ndvi)
dev.off()
#salva l'immagine automaticamente nella working directory

#creo un pdf e ci infilo dentro i vari plot
pdf("figura1.pdf")
im.multiframe(2,2)
plot(gre)
plot(red)
plot(nir)
plot(ndvi)
dev.off()

#la differenza è che pdf è vettoriale quindi le scritte non vengono sgranate quando faccio lo zoom

#---
pdf("figura2.pdf")
p1 <- im.ggplot(ndvi)
p2 <- im.ridgeline(ndvi, scale=1)

p1 + p2

dev.off()

#viene spastico perché andrebbero ridimensionate altezza e larghezza, ma è un po' complicato

https://github.com/ducciorocchini/Telerilevamento_2026/tree/main/Drone2
#indirizzo della cartella su github, che però devo modificare nel seguente modo
#devo usare un altro sito mirror di github, e togliere tree

#importare l'immagine direttamente da github
gregit<- rast("https://raw.githubusercontent.com/ducciorocchini/Telerilevamento_2026/main/Drone2/DJI_20260409152942_0001_MS_G.TIF")








