# codice per classificare immagini

library(terra)
library(imageRy)

im.list()

sun <- im.import("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
plot(sun)

#classificazione
sunc <- im.classify(sun, num_clusters=3)
#da una classificazione random, posso dire a R quale delle classificazioni usare tramite il seed
sunc <- im.classify(sun, num_clusters=3, seed=19)

#classificazione grand canyon
can <- im.import("dolansprings_oli_2013088_canyon_lrg.jpg")
plot(can)

#noi useremo unsupervised classification. L'unica cosa che dobbiamo indicare è il numero di gruppi
can2 <- im.classify(can, num_clusters=4, seed=19)
#vedo che non l'ha fatta benissimo, perché ad esempio ha unito colori scuri nella stessa classe, che sono sia acqua sia aree più scure
#per risolvere si può aumentare il numero di classi

#classificazione immagine da internet
setwd("C:\\Users\\elena\\OneDrive - Alma Mater Studiorum Università di Bologna\\Desktop\\uni\\telerilevamento")
list.files()

dji <- rast("dji_fly_20241226_054143_0_1735188103432_photo_low_quality.JPG")
dji <- flip(dji)
plot(dji)

djic <- im.classify(dji, num_clusters=3)

#classificazione mato grosso
m06 <- im.import("matogrosso_ast_2006209_lrg.jpg")  
m92 <- im.import("matogrosso_l5_1992219_lrg.jpg")

par(mfrow=c(1,2))
plot(m92)
plot(m06)

m92c <- im.classify(m92, num_clusters=2, seed=19) #classifico con due categorie

#metto etichette
levels(m92c) <- data.frame(
  value = c(2, 1),
  label = c("forest", "human")
)

m92c #ora vedo che ha messo le etichette negli attributi dell'elemento

m06c <- im.classify(m06, num_clusters=2, seed=19)
levels(m06c) <- data.frame(
  value = c(2, 1),
  label = c("forest", "human")
)

#voglio ottenere istogrammi dalle due immagini che mi diano le percentuali di foresta e di suolo antropizzato

freq92 <- freq(m92c)
perc92 <- freq92$count * 100 / ncell(m92c) #calcolo delle percentuali, la seconda parte mi da il numero di pixel dell'immagine

freq06 <- freq(m06c)
perc06 <- freq06$count * 100 / ncell(m06c)

#creo tabella
tabout <- data.frame(
      class=c("Forest", "Human"),
      perc92=c(83,17),
      perc06=c(45,55)
)
      
tabout



      
