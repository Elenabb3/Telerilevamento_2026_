library(terra)
libbrary(imageRy)

setwd("C:\\Users\\elena\\OneDrive - Alma Mater Studiorum Università di Bologna\\Desktop\\uni\\telerilevamento")
getwd()
list.files()


png("figura.png")
richat <- rast("richatstructure_oli_20260306.jpg")
richat <- flip(richat)
plot(richat)
dev.off()

png("bande.png")
par(mfrow=c(1,2))
plot(richat[[1]])
plot(richat[[2]])
dev.off()


png("ist.png")
par(mfrow=c(2,2))
hist(values(richat[[1]]), main="Istogramma Red", col="red")
hist(values(richat[[2]]), main="Istogramma Green", col="green")
hist(values(richat[[3]]), main="Istogramma Blue", col="blue")
dev.off()

#oppure si può fare anche con un ciclo, invece di rifare un grafico ogni volta (dovrebbe essere sul codice della seconda lezione)


