library(terra)
library(imageRy)
library(viridis)

im.list()
#importo matogrosso_l5_1992219_lrg.jpg. Non tutte le bande sono state importate
mato1992 <- im.import("matogrosso_l5_1992219_lrg.jpg")
#è un jpg e non è georeferenziata, quindi capita che esce capovolta
mato1992<-flip(mato1992) #funzione di terra per ruotare le immagini

# l1=NIR l2=red l3=green
im.plotRGB(mato1992, 1, 2, 3)

#metto il NIR in corrispondenza al verde (quindi secondo posto)
im.plotRGB(mato1992, 2, 1, 3)

mato1992
#mi da range di valori di riflettanza, qua varia tra 0 e 255 invece che tra 0 e 1
#per evitare di fare range di decimali tra 0 e 1 e fare invece numeri interi. Le immagini sono a 8 bit quindi ci sono 256 combinazioni
#quindi si associa ad ogni possibile stringa di 0 e 1 lunga 8 cifre un numero intero
#di solito le immagini scaricate da internet sono a 8 bit (buon compromesso tra qualità e peso)
#risoluzione radiometrica - quanti bit compongono le immagini. Uno dei 3 tipi di risoluzione che ci ha spiegato e che può chiedere all'esame
mato2006 <- im.import("matogrosso_ast_2006209_lrg.jpg")
mato2006 <- flip(mato2006)
#immagine di aster (altro satellite) che ha risoluzione di 15 m invece che 30 come landstat
im.plotRGB(mato2006, 1, 2, 3)
im.multiframe(1,2) #risolvere il problema del multiframe
par(mfrow=c(1,2)) #non funziona neanche così (visualizza solo uno dei due plot, ma dividendo a metà come se ce ne fossero due
#comparazione tra 1992 e 2006

#CALCOLO DEL DVI
dvi92 <- mato1992[[1]] - mato1992[[2]] #i numeri indicano le bande del NIR e del red. Indico tramite subset con le parentesi
plot(dvi1992)
#noto dalla legenda che il range del dvi varia tra -255 e +255 (con immagine a 8 bit)
#massimo teorico di dvi = NIR-red= 255-0=255
#minimo teorico, NIR=0 e la riflettanza nel rosso è altissima 0-255=-255

#calcolo minimo e massimo per immagine a 4 bit
#15, -15
#se io ho due immagini con soluzione radiometrica diversa, i due valori non sono comparabili. Quindi si usa il dvi normalizzato (NDVI)
#solitamente si standardizza sulla somma di NIR e RED. Dire che è una normalizzazione è improprio, è una standardizzazione
#(NIR-RED) / (NIR+RED)
#max e minimo diventano 1 e -1 indipendentemente dal numero di bit, quindi i valori sono comparabili

ndvi92 <- (mato1992[[1]] - mato1992[[2]])/(mato1992[[1]] + mato1992[[2]])
#oppure ancora meglio
ndvi92 <- dvi92/(mato1992[[1]] + mato1992[[2]])


dvi06 <- mato2006[[1]] - mato2006[[2]]
ndvi06 <- dvi06/(mato2006[[1]] + mato2006[[2]])

#per mettere altra palette di viridis
plot(ndvi1992, col=inferno(100))


#per calcolarli più in fretta con le funzioni di imagery
dvi1992 = im.dvi(mato1992, 1, 2)
ndvi1992 = im.ndvi(mato1992, 1, 2)
#eccetera


#plottare DVI e NDVI in 2 colonne e 2 righe (non sto qua a scriverlo tanto abbiamo capito)




                                           
                                      






