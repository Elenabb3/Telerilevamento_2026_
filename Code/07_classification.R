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

      
