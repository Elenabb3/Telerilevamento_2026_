#visualizzazione di dati multispettrali. Esistono anche le immagini iper spettrali, che ne hanno ancora di più
#risoluzione spettrale: aumenta con l'aumentare del numero di bande

install.packages("viridis")
library(viridis)
library(terra)
library(imageRy)
library(ggplot2)

install.packages("patchwork")
library(patchwork)


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
plot(b2, col=cl) #b2 lo ho già importato un po' di righe sopra

# importo altre 3 bande
b3 = im.import("sentinel.dolomites.b3.tif")
b4 = im.import("sentinel.dolomites.b4.tif")
b8 = im.import("sentinel.dolomites.b8.tif")

#plotto le bande
par(mfrow=c(1,4))
plot(b2)
plot(b3)
plot(b4)
plot(b8)

dev.off()

#riplotto le bande ma facendo il multiframe con la funziona di imagery
im.multiframe(1,4)  #### non funziona, almeno su rstudio. Provare su R
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

#riplotto, cambiando la palette in scala di grigi
cl = colorRampPalette(c("black", "light grey"))(100)
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)

cl = colorRampPalette(c("black", "light grey"))(2) #tengo solo 2 valori, quindi mi esce una mappa con 2 soli colori
plot(b2, col=cl)
plot(b3, col=cl)
plot(b4, col=cl)
plot(b8, col=cl)



####fine parte copiata da recuperare

sentinel <- c(b2, b3, b4, b8)  #concateno le bande all'interno di un vettore, così le posso plottare tutte in una votla
plot(sentinel)
plot(sentinel, col=inferno(100))

plot(sentinel$sentinel.dolomites.b8) #richiamo il layer con $, però in realtà è più comodo usare i subset come sotto, se le bande non sono tante
####se richiamo così non funziona. Credo non sia giusto il nome dell'elemento, è perché lo ho scaricato dal cran invece che da github?

dev.off() #per togliere il multiframe?


#####RICHIAMO GLI ELEMENTI TRAMITE SUBSET: non serve sapere il nome, ma solo il numero in lista
#layer1=b2, layer2=b3, layer3=b4, layer4=b8
plot(sentinel[[4]]) #seleziona solo una delle bande dello stack. Ho fatto un subset
plot(sentinel[[2]])


##lezione 10/03
##GGPLOT
#reimporto banda b2, b3, b4 e b8 se non l'ho già fatto
p1 <- im.ggplot(b8)
p2 <- im.ggplot(b4)

p1 + p2 #avendo installato patchwork, io posso plottare semplicemente facendo così. Con il + dico di mettere i due plot uno accanto all'altro
#quindi è un ulteriore metodo per fare i multiframe (oltre a par, im.multiframe e facendo gli stack)

#FARE PLOT CON 3 BANDE RGB

sentinel <- c(b2, b3, b4, b8) #rifaccio lo stack
#1=b2 blue 2=b3 green 3=b4 red 4=b8 vicino infrarosso. Dovrei capire se richiamo l'oggetto a quale corrisponde quale colore in base all'ordine in cui sono?
im.plotRGB(sentinel, r=3, g=2, b=1)
#dato che ho segnato le 3 bande del visibile, mi restituisce l'immagine a colori naturali

#metto il vicino infrarosso tra le bande. Scalo le bande di uno
im.plotRGB(sentinel, r=4, g=3, b=2)
#l'immagine diventa rossa dove c'è vegetazione, perché le foglie riflettono molto nel vicino infrarosso
#vedo più chiaramente dove c'è vegetazione e dove no, cosa che nell'immagine reale non era così visibile perché si confondeva con ombre o altre parti scure

#posso cambiare la posizione dell'infrarosso, in modo che venga di un altro colore. Qui ad esempio sul verde
im.plotRGB(sentinel, r=3, g=4, b=2)

im.plotRGB(sentinel, r=3, g=2, b=4) #idem col blu

#plot the four manners of RGB in a single multiframe
im.multiframe(2,2))
im.plotRGB(sentinel, r=3, g=2, b=1)
im.plotRGB(sentinel, r=4, g=3, b=2)
im.plotRGB(sentinel, r=3, g=4, b=2)
im.plotRGB(sentinel, r=3, g=2, b=4)

#provo a cambiare l'ordine delle altre due bande, vedo che non cambia molto perché sono molto correlati, quello che cambia è dove metto l'infrarosso
im.multiframe(1,2)
im.plotRGB(sentinel, r=4, g=3, b=2)
im.plotRGB(sentinel, r=4, g=2, b=3)


###### fare matrice di plot di correlazione tra gli elementi. Vale anche per le tabelle, in cui fa le correlazioni tra le varrie colonne
pairs(sentinel)
#c'è anche ggpairs, che però va usato sui dataframe, forse ce lo farà più avanti

#posso anche scrivere
im.plotRGB(sentinel, 4, 2, 3) #basta che tengo l'ordine delle bande


#funzione di terra fa cui deriva quella di imageRy, c'è bisogno di fare lo stretch lineare per le immagini che hanno valori in una parte ristretta
#usando im.plotRGB lo fa già in automatico
plotRGB(sentinel, 4, 2, 3, stretch="lin")
plotRGB(sentinel, 4, 2, 3, stretch="hist") #altro modo, che fa lo stretch aumentando il contrasto sui valori medi










