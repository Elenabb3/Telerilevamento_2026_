library(terra)
library(imageRy)

im.list()

EN1 <- im.import("EN_01.png")
EN1 <- flip(EN1)
plot(EN1)
EN1 #vedo che è un'immagine a 8 bit

EN13 <- im.import("EN_13.png")
EN13 <- flip(EN13)
plot(EN13)

par(mfrow=c(2,1))
plot(EN1)
plot(EN13)

#differencing. faccio la differenza tra i valori per la banda n.1
ENdif <- EN1[[1]] - EN13[[1]] 
dev.off()
plot(ENdif)
#quindi i colori mi indicano dove i valori nell'immagine 13 sono più bassi oppure più alti



