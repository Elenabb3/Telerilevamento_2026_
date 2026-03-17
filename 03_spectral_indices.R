library(terra)
library(imageRy)

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
