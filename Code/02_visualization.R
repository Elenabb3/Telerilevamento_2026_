#visualizzazione di dati multispettrali. Esistono anche le immagini iper spettrali, che ne hanno ancora di più
#risoluzione spettrale: aumenta con l'aumentare del numero di bande

install.packages("viridis")
library(viridis)
library(terra)
library(imageRy)


#le funzioni di imageRy iniziano tutte per im.
im.list()
#con quello installato dal CRAN ne ho 34, nella versione di github ce ne sono 3/4 in più
#link con informazioni sulel varie bande di sentinel
#voglio importare la banda n.2
b2 <- im.import("sentinel.dolomites.b2.tif")
#per visualizzare l'immagine devo fare plot, lo fa in automatico solo per imageRy installata da github
plot(b2)

#DEFINIRE I COLORI DELLA MAPPA
# https://r-charts.com/colors/ --link con i colori di R e relativi codici
cl <- colorRampPalette(c("lightsalmon","darkolivegreen3","mediumpurple1"))(100)
#funzione per definire la palette
#devo concatenare i colori in modo che li legga tutti e 3
#partendo da questi 3 colori, crea le sfumature intermedie. Gli dico io quante
plot(b2, col=cl) #quindi invece di dire il colore diretto, gli indico l'oggetto che contiene la palette

#ALTRO MODO PER CAMBIARE I COLORI
#esiste il pacchetto viridis che permette di usare palette che vedono anche i daltonici (?)
#REGOLA: scrivo tutti i pacchetti in cima, non durante il codice. Aggiungo all'inizio l'installazione del pacchetto viridis
plot(b2, col=inferno(100)) #notare che in questo caso il numero di sfumature sta dentro alla parentesi, sintassi diversa

#se cerco il pacchetto sul cran, dovrei arrivare alle altre palette tra cui scegliere

#ESERCIZIO: cambiare colore nella scala di grigi
cl <- colorRampPalette(c("gray30","gray60","gray90"))(100)
plot(b2, col=cl)
#oppure
cl <- colorRampPalette(c("dark gray","gray","light gray"))(100)

#immagini multiframe (es. 2 immagini una accanto all'altra)
#MODO1: come abbiamo fatto a statistica con par. mf sta per multiframe
par(mfrow=c(1,2))
plot(b2, col=inferno(100))
plot(b2, col=cl)

dev.off() #serve per chiudere finestra grafica senza schiacciare manualmente la x

#MODO2:funzione di imageRy apposita (usa sempre par, solo che lo mette nella funzione per poterlo scrivere più facilmente)
im.multiframe(1,2)
plot(b2, col=inferno(100))
plot(b2, col=cl)


####recuperare cose in mezze fatte nell'ora di lezione saltata #####

cl = colorRampPalette(c("royalblue3", "seagreen1", "red1"))(100)
plot(b2, col=cl)

# bands
b3 = im.import("sentinel.dolomites.b3.tif")
b4 = im.import("sentinel.dolomites.b4.tif")
b8 = im.import("sentinel.dolomites.b8.tif")

par(mfrow=c(1,4))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

dev.off()

im.multiframe(1,4)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

# Exercise: plot the bands using im.multiframe() one on top of the other
im.multiframe(4,1)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

im.multiframe(2,2)
plot(b2)
plot(b3)
plot(b4)
plot(b8)

cl = colorRampPalette(c("black", "light grey"))(100)
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

cl = colorRampPalette(c("black", "light grey"))(2)
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)



####fine parte copiata da recuperare

sentinel <- c(b2, b3, b4, b8)
plot(sentinel)
plot(sentinel, col=inferno(100))

plot(sentinel$sentinel.dolomites.b8) #richiamo il layer con $, però in realtà è più comodo usare i subset come sotto, se le bande non sono tante
dev.off() #per togliere il multiframe?

#layer1=b2, layer2=b3, layer3=b4, layer4=b8
plot(sentinel[[4]]) #seleziona solo una delle bande dello stack. Ho fatto un subset
plot(sentinel[[2]])










