# TITOLO DEL PROGETTO

L'area di studio ecc. ecc.

In classe ha aggiunto una bandiera della Mauritania boh ok

## Pacchetti utilizzati (sottotitolo)
Per questo esame i pacchetti ...

```r
library(terra) #commento sulla libreria
library(imageRy) #per multiframe e altro, ricordarsi di richiamare tutti i pacchetti all'inizio anche nel multiframe

```

## Importazione dei dati

Sono stati scaricati da earth observatory: inserire link

Oppure (Earth Observatory)[link tra parentesi quadre] così mi mette il link chiamato come voglio

Selezione della working directory

```r
setwd("C:\\Users\\elena\\OneDrive - Alma Mater Studiorum Università di Bologna\\Desktop\\uni\\telerilevamento")
getwd()
list.files()
```

per importare dati uso funzione `rast()` del pacchetto `terra` (modo per evidenziare pacchetti e funzioni tra backtick

importazione dell'immagine e salvataggio in png

```r
png("figura.png")
richat <- rast("richa<img width="480" height="480" alt="figura" src="https://github.com/user-attachments/assets/24a263d5-1784-4258-80a0-aee3199c80d5" />
tstructure_oli_20260306.jpg")
richat <- flip(richat)
plot(richat)
dev.off()
```

Voglio mettere l'immagine in markdown (semplicemente la trascino)
<img width="480" height="480" alt="figura" src="https://github.com/user-attachments/assets/215827f3-6ef2-4da5-bee2-7a75c67a21c3" />

Pezzo di codice per plottare le bande

```r
par(mfrow=c(2,1))
plot(richat[[1]])
plot(richat[[2]])
```

Immagine (senza multiframe perché non mi funziona, correggere)

<img width="480" height="480" alt="bande" src="https://github.com/user-attachments/assets/1c06cc76-c426-47f6-b9cb-cc824326dafc" />

Poi il prof mette il codice su chat chiedendo di fare istogrammi


```r
par(mfrow=c(2,2))
hist(values(richat[[1]]), main="Istogramma Red", col="red")
hist(values(richat[[2]]), main="Istogramma Green", col="green")
hist(values(richat[[3]]), main="Istogramma Blue", col="blue")
```

Immagine con gli istogrammi

<img width="480" height="480" alt="ist" src="https://github.com/user-attachments/assets/0e803b0f-6ac8-449d-a35e-f0ed39887408" />


