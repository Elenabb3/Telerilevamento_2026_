#per installare i pacchetti, dal cran
install.packages("nomepacchetto")
#si può fare da github avendo prima installato devtools
install_githuub(nomeutente/nomepacchetto)


# un po' di funzioni di imagery
im.list() # mostra la lista delle immagini contenute nel pacchetto
im.import("nome immagine") #importa le immagini contenute nella lista
im.multiframe(x, y) #equivale a 
par(mfrow = c(x, y))
im.ggplot(immagine) # permette di plottare immagine tramite ggplot. forse un po' meglio a livello grafico?
# poi credo che invece con ggplot non si riesca in automatico a plottare immagini. o forse sì
# però im.ggplot() è figo perché poi posso plottare l'immagine come uno degli elementi tramite patchwork
im.plotRGB(nome, r = , g = , b = )  # equivale a 
plotRGB() # in cui però bisogna indicare lo stretch = "lin" o "hist"

colorRampPalette(c("nome", "nome", "nome")) (100) # per creare una palette inserendo manualmente i colori
#devo indicare il numero di sfumature, che con viridis viene indicato con una sintassi diversa
# altirmenti se ho richiamato viridis ho palette già pronte

#dopo aver creato un vettore con più immagini posso richiamarle o per nome o per posizione
plot(vettore$nomeimmagine) # che però non è molto comodo perché magari c'è un nome lungo o non so il nome
# in genere viene automaticamente assegnato il nome del file sorgente
plot(vettore[[1]]) 

pairs() # fa matrice di scatterplot
oggetto <- flip(oggetto) # utile se ho importato immagine non georeferenziata

dvi <- nir - rosso
ndvi <- (nir - rosso)/(nir + rosso)
# oppure si calcola con
im.ndvi()
# ndvi è sempre tra -1 e 1, il range del dvi invece dipende dalla risoluzione radiometrica
# ovvero quanti bit ha l'immagine, perché determina il numero di diversi valori che può assumere
# potenze di 2, elevate al numero di bit
# se immagine 8 bit, tra -255 e 255
# tipicamente le immagini satellitari a quanti bit sono?
# posso vedere quanti bit ha la mia immagine se la richiamo, in teoria
im.classify(oggetto,  num_clusters=x, seed=n) # seed assegna semplicemente un numero, così che la classificaizone sia riproducibile



hist(ndvi) # per fare istogrammi. si può poi modificare in vari modi ora non mi ricordo la sintassi

# Per esportare le immagini
writeRaster("nome.tif") se è un raster. me lo salva però non è adatto alla visualizzazione, ma adatto per importarlo e farci sopra cose

png("nome.png", width = , height = , res = )
bla bla plotto
dev.off()

# idem per il pdf
# posso anche importare un'immagine direttamente da git, in quel caso inserendo il link
nome <- rast("https ecc") 
# però devo sostituire con raw.gituserhubcontent.com e togliere tree

#come si fanno i cicli for?
for(i in 1:nlyr(vettore)) {
  hist(vettore[[i]],
       main=paste("Istogramma banda", i),
       xlab="Valori digitali",
       col=palette[i],
       border="white")
}

#similmente potrei fare per altre cose che non sono vettori del tipo
for(i in 1:nlyr(oct18)) {
  plot(oct18[[i]], col = inferno(100), main = paste ("banda", i))
}
# e se ho prima ho fatto il multiframe me li plotta di fianco

# COME SI FANNO LE FUNZIONI?

# nome funzione, poi function con gli argomenti tra parentesi
# parentesi graffe, calcoli e poi return(risultato) se voglio che mi restituisca un valore
# altrimenti non lo metto,come nel caso del multiframe diy


differenzaselvaggia <- function(x,y){
  z=x-y
  return(z)
  }

sink("nome.txt")
funzione calcoli ecc
dev.off()
# funziona come per i png, ma per gli output di R
