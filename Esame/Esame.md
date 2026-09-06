# Analisi dell'impatto dell'uragano Dorian sulla vegetazione di Grand Bahama

> #### Corso di Telerilevamento Geo-Ecologico in R, a.a. 2025-26
> #### Elena Betti

## Indice?

# Introduzione

Tra il 1 e 3 settembre 2019, l'isola di Grand Bahama è stata colpita dall'uragano Dorian. Si è trattato del più forte uragano che ha colpito le Bahamas in tempi moderni, e uno dei più potenti mai registrati nell'Oceano Atlantico, raggiungendo categoria 5 e venti oltre i 350 km/h. Oltre ai venti, una forte mareggiata con onde fino a 6 m di altezza ha inondato l'isola. La tempesta ha colpito soprattutto la parte centro-orientale, e oltre numerose vittime e danni devastanti ai centri abitati, ha causato importanti danni alle foreste.  
L'isola di Grand Bahama si trova nei Caraibi e a causa della sua posizione geografica è regolarmente interessata da tempeste tropicali. La frequenza delle tempeste ha picco tra settembre e ottobre, ovvero gli ultimi mesi del periodo delle piogge. La vegetazione è costituita principalmente da foreste di Pino delle Bahamas (_Pinus caribae_ var. _bahamensis_), oltre a mangrovieti nelle aree più vicine alla costa. Sembra che l'uragano Dorian abbia causato l'estinzione del picchio muratore delle Bahamas (_Sitta insularis_), specie endemica dell'isola e già a rischio critico prima del 2019, e che non è stata più osservata negli anni successivi.


<p align="center">
<img width="300" height="300" alt="Dorian_2019-09-01_1641Z" src="https://github.com/user-attachments/assets/8ef4aa95-c089-446a-9022-1f99658abc3a" />
<img width="300" height="250" alt="uragano-Dorian-Bahamas-57" src="https://github.com/user-attachments/assets/2f9d0ec7-efb9-4d01-8505-a9fda50d7b5b" />


# Obiettivo del progetto

Questo progetto vuole analizzare l'impatto dell'uragano Dorian sulla vegetazione dell'isola in 3 diversi momenti: 

* Ottobre 2018, prima dell'uragano;
* Ottobre 2019, circa un mese dopo;
* Ottobre 2021, due anni dopo


È stata selezionata una zona della parte centrale dell'isola, a ovest dell'aeroporto ausiliare di Grand Bahama.  

<p align="center">
<img width="550" height="400" alt="bahamas MAPPA" src="https://github.com/user-attachments/assets/04d4da7c-a62c-48df-8cad-488fdfd7d1d6" />



Sono state svolte le seguenti analisi:

* NDVI (Normalized Difference Vegetation Index)
* NDMI (Normalized Difference Moisture Index)
* Classificazione dei valori di NDVI e mappatura del territorio
* Quantificazione della copertura percentuale delle classi tra i vari anni

# Dati

Sono state utilizzate 3 immagini satellitari di Sentinel_2A, scaricate dal portale di [Copernicus](https://browser.dataspace.copernicus.eu/).

***Tabella 1.** Bande utilizzate*

  |BANDE|RISOLUZIONE SPAZIALE|DESCRIZIONE|UTILIZZO|                 
  |--------|--------|---------|-------|
  |B2|10 m|Blu|visualizzazione RGB|
  |B3|10 m|Verde|Visualizzazione RGB|
  |B4|10 m|Rosso|Visualizzazione RGB, NDVI, classificazione|
  |B8|10 m|NIR(vicino infrarosso)|NDVI, NDMI, classificazione|
  |B11|20 m| SWIR 1|NDMI|

## Pacchetti

```r
library(terra)      # Visualizzazione e manipolazione di raster spaziali
library(imageRy)    # Calcolo dell'ndvi, creazione ridgeline plots
library(viridis)    # Palette ad alto contrasto e adatte per il daltonismo
library(ggplot2)    # Creazione dei grafici a barre
library(patchwork)  # Visualizzazione e affiancamento di grafici
```

# Importazione e preparazione immagini

## Definizione della working directory

```r
setwd("C:/Users/elena/Desktop/EsameTele")
```
Le bande sono state importate separatamente e poi riunite in vettori per ogni anno.
I vettori creati hanno quindi la seguente struttura:

vettore:  
vettore[[1]] = blu(b2)  
vettore[[2]] = verde(b3)  
vettore[[3]] = rosso(b4)  
vettore[[4]] = NIR(b8)

```r
# Importazione delle bande di Sentinel-2
# con rast(), pacchetto terra, crea oggetti SpatRaster
or2018_b2 <- rast("T17RQK_20181030T155529_B02_10m.jp2")  
or2018_b3 <- rast("T17RQK_20181030T155529_B03_10m.jp2")
or2018_b4 <- rast("T17RQK_20181030T155529_B04_10m.jp2")
or2018_b8 <- rast("T17RQK_20181030T155529_B08_10m.jp2")

or2019_b2 <- rast("T17RQK_20191003T160511_B02_10m.jp2")
or2019_b3 <- rast("T17RQK_20191003T160511_B03_10m.jp2")
or2019_b4 <- rast("T17RQK_20191003T160511_B04_10m.jp2")
or2019_b8 <- rast("T17RQK_20191003T160511_B08_10m.jp2")

or2021_b2 <- rast("T17RQK_20211027T160509_B02_10m.jp2")
or2021_b3 <- rast("T17RQK_20211027T160509_B03_10m.jp2")
or2021_b4 <- rast("T17RQK_20211027T160509_B04_10m.jp2")
or2021_b8 <- rast("T17RQK_20211027T160509_B08_10m.jp2")

# Concatenamento delle bande in vettori
or2018 <- c(or2018_b2, or2018_b3, or2018_b4, or2018_b8)
or2019 <- c(or2019_b2, or2019_b3, or2019_b4, or2019_b8)
or2021 <- c(or2021_b2, or2021_b3, or2021_b4, or2021_b8)
```

> [!NOTE]
>
> La banda 11 viene tenuta separata dalle altre, vista la differente risoluzione spaziale. Verrà utilizzata più tardi per il calcolo dell'NDMI

```r
# Importazione della banda 11 a risoluzione 20m
or2018_b11 <- rast("T17RQK_20181030T155529_B11_20m.jp2")
or2019_b11 <- rast("T17RQK_20191003T160511_B11_20m.jp2")
or2021_b11 <- rast("T17RQK_20211027T160509_B11_20m.jp2")
```

## Ritaglio dell'area di interesse

```r
# Definizione dell'area di interesse con la funzione ext() del pacchetto terra
aoi <- ext(754809, 763308, 2946037, 2953282) # coordinate UTM (WGS84) sono in questo ordine: xmin, xmax, ymin, ymax

# Ritaglio dell'area di interesse con la funzione crop() del pacchetto terra
oct18 <- crop(or2018, aoi)
oct19 <- crop(or2019, aoi)
oct21 <- crop(or2021, aoi)

# Ritaglio della banda 11
oct18b11 <- crop(or2018_b11 , aoi)
oct19b11 <- crop(or2019_b11 , aoi)
oct21b11 <- crop(or2021_b11 , aoi)
```

# Visualizzazione

## Colori reali (RGB)

Visualizzazione dell'area a colori reali. Le bande sono così assegnate:  
r = rosso(3), g = verde(2), b = blu(1)


```r
par(mfrow = c(1,3))     # divisione del pannello in 3 colonne
plotRGB(oct18, 3, 2, 1, stretch = "lin", main = "RGB 2018") 
plotRGB(oct19, 3, 2, 1, stretch = "lin", main = "RGB 2019")
plotRGB(oct21, 3, 2, 1, stretch = "lin", main = "RGB 2021")
```
<p align="center">
<img width="800" height="400" alt="RGB_bahamas" src="https://github.com/user-attachments/assets/a176e3db-2bd1-46f2-b322-965b9db2ad8f" />

COMMENTO


## Falsi colori (NIR - rosso - verde)

Visualizzazione dell'area per evidenziare la riflettanza nel vicino infrarosso.   
Le bande sono così assegnate:  
r = NIR(4), g = rosso(3), b = verde(2)

```r
plotRGB(oct18, 4, 3, 2, stretch = "lin", main = "NIR 2018")
plotRGB(oct19, 4, 3, 2, stretch = "lin", main = "NIR 2019")
plotRGB(oct21, 4, 3, 2, stretch = "lin", main = "NIR 2021")
```

<p align="center">
<img width="800" height="400" alt="NIR_bahamas" src="https://github.com/user-attachments/assets/08ca8c4d-a3d0-4f05-86c2-462972dd040c" />
  
COMMENTO


## Esportazione delle immagini

Si riporta il codice con cui è stata esportata la precedente immagine in formato png.  
Lo stesso procedimento è stato ripetuto per tutte le altre immagini del progetto.

```r
png("NIR_bahamas.png", width = 800, height = 400, res = 100)   # Definizione nome e dimensioni immagine   
par(mfrow=c(1,3))
plotRGB(oct18, 4, 3, 2, stretch = "lin", main = "NIR 2018") 
plotRGB(oct19, 4, 3, 2, stretch = "lin", main = "NIR 2019") 
plotRGB(oct21, 4, 3, 2, stretch = "lin", main = "NIR 2021")
dev.off()  
```


# NDVI (Normalized Difference Vegetation Index)

$$
NDVI = \frac{NIR - RED}{NIR + RED}
$$

L'NDVI misura la differenza tra riflettanza nel vicino infrarosso (NIR) e nel rosso(RED). La riflettanza della banda NIR è particolarmente alta nelle foglie in salute e diminuisce progressivamente quando la pianta è sotto stress o le foglie muoiono. Per questo l'NDVI è un buon proxy per stimare l'abbondanza e la salute della vegetazione.  
Grazie alla normalizzazione, che lo distingue dal DVI (Difference Vegetation Index), restituisce valori compresi tra -1 e 1, e semplifica il confronto di immagini acquisite a diversa risoluzione radiometrica.  
Valori di NDVI sotto allo 0.2 sono associati ad assenza di vegetazione (suolo, acqua, tessuto urbano, ...) o vegetazione morta, mentre valori tra 0.2 e 1 indicano vegetazione progressivamente sempre più in salute e abbondante.

```r
# Calcolo ndvi con funzione im.ndvi() di imageRy
ndvi18 <- im.ndvi(oct18, 4, 3)
ndvi19 <- im.ndvi(oct19, 4, 3)
ndvi21 <- im.ndvi(oct21, 4, 3)

ndvi <- c(ndvi18, ndvi19, ndvi21) # concatenamento in un vettore

# Visualizzazione ndvi con palette viridis
par(mfrow=c(1, 3))
plot(ndvi18, col = viridis(100), range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2018")
plot(ndvi19, col = viridis(100), range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2019")
plot(ndvi21, col = viridis(100), range = range(values(ndvi), na.rm = TRUE), main = "NDVI 2021")
# Definisco il range della legenda, in modo da avere stessa scala tra le 3 immagini e colori direttamente confrontabili tra loro
```

<p align="center">
<img width="800" height="400" alt="NDVI" src="https://github.com/user-attachments/assets/e840e3f2-a1b3-404c-a30f-28d89c207441" />

> L'area presenta valori medio-alti di NDVI nel 2018, in particolare nella parte meridionale, indicando quindi maggiore copertura. È inoltre evidente una diminuzione dell'NDVI nel 2019, dopo l'uragano, e una maggiore uniformità nei colori. Ciò indica che, oltre a una perdita di vegetazione, c'è stata anche una perdita delle differenze di vegetazione prima presenti. Nel 2021 i valori tornano ad aumentare, indicando una ricrescita, ma la situazione appare ancora significativamente degradata rispetto al 2018.

## Ridgeline plot 

Il grafico mostra la distribuzione delle frequenze dei valori di NDVI nei 3 momenti, permettendo un confronto più immediato.

Viene utilizzata la funzione `im.ridgeline()` di `imageRy`

```r
names(ndvi) <- c("NDVI 2018", "NDVI 2019", "NDVI 2021")              # Assegnazione nomi elementi
 
r <- im.ridgeline(ndvi, scale = 1, palette = "viridis") +            # Aggiunta di elementi dopo + con la sintassi di ggplot
  xlim(0, 0.75) +                                                    # Restringimento dei valori di x per una visualizzazione migliore
  theme_minimal()+                                                   # Tema minimal con sfondo bianco
  labs(title = "Ridgeline plot dei valori di NDVI" , fill = "NDVI")  # Titolo grafico e titolo legenda

plot(r)
```

<p align="center">
<img width="800" height="600" alt="ridgeline_ndvi" src="https://github.com/user-attachments/assets/ced69bb8-9f3f-40f4-9b92-b1d64142e491" />

> Il 2018 presenta la curva più spostata verso destra, e le frequenze sono distribuite in 2 picchi principali, che possono essere ricondotti alla differenza tra l'area boschiva a sud e il resto dell'immagine. Nel 2019 i valori di spostano verso sinistra e la maggior parte si concentra in un range di valori più ristretto, indicativamente tra 0.1 e 0.2. Questi valori molto bassi sono indice di assenza di vegetazione o di vegetazione morta. Nel 2021, come atteso, la distribuzione torna a spostarsi verso valori maggiori, e sembra che si stia ricostituendo una curva a due picchi come nel 2018. La vegetazione sembra quindi essere in via di ripresa.
 

## Variazione di NDVI

Il calcolo della differenza di NDVI tra gli anni permette di visualizzare tale variazione sulla mappa. È così possibile individuare le aree interessate da maggiori cambiamenti. Valori sopra lo 0 indicano una variazione positiva, e quindi un aumento di NDVI nel secondo anno; valori negativi indicano una diminuzione.

```r
d_ndvi18_19 <- ndvi[[2]] - ndvi[[1]]
d_ndvi19_21 <- ndvi[[3]] - ndvi[[2]]
d_ndvi18_21 <- ndvi[[3]] - ndvi[[1]]

# Visualizzazione plot
par(mfrow = c(1,3))
plot(d_ndvi18_19, col = inferno(100), main = "ΔNDVI 2018-2019")
plot(d_ndvi19_21, col = inferno(100), main = "ΔNDVI 2019-2021")
plot(d_ndvi18_21, col = inferno(100), main = "ΔNDVI 2018-2021")
```

<p align="center">
<img width="800" height="400" alt="ΔNDVI" src="https://github.com/user-attachments/assets/fb458393-148b-49db-8b08-d57bb1c44ea5" />

> Praticamente sembra che nel secondo plot ci sia diminuzione perché i colori sono più scuri. In realtà no perché guardando la legenda i valori sono in un range più alto e la maggior parte dell'area ha quindi una variazione positiva. Questo indica una ripresa, ma il fatto che il range di variazione sia minore indica anche che la ripresa rispetto al 2019 è stata piuttosto scarsa. Questa è una cosa sensata direi. e infatti confrontando 2018 e 2021 c'è sempre una diminuzione, che anche se minore è comunque più comparabile alla variazione 2018-19 che a quella 2019-21. !!! Complicata questa cosa da spiegare, ho paure di fare discorsi circolari

# NDMI (Normalized Difference Vegetation Index)

$$
NDMI = \frac{NIR - SWIR 1}{NIR + SWIR 1}
$$

L'NDMI è un indice utilizzato per stimare il contenuto di acqua nella vegetazione, e quindi anche le condizioni di stress idrico.  
Utilizza la luce infrarossa a onde corte (SWIR), una categoria di infrarosso subito successiva al NIR. Le onde SWIR sono assorbite dall'acqua, e permette quindi di distinguere aree con suolo scoperto, vegetazione secca o in stress idrico (minore rifletttanza) da aree con vegetazione più florida (maggiore riflettanza).  
L'NDMI varia tra -1 e 1, e valori attorno allo 0,3 indicano la soglia di stress idrico delle piante. #però quando faccio l'NDMI invece sono i valori bassi a indicare stress, quindi occhio a spiegarlo bene.

Qua ci potrei inserire i plot della banda 11, che fa vedere la riflettanza rispetto all'acqua. o magari no sticasi


## Ricampionamento banda 8 10m -> 20m
Sentinel-2 ottiene la banda 8 NIR a una risoluzione di 10 m, mentre quella dello SWIR 1 a risoluzione di 20 m. Per questo la banda 8 è stata ricampionata sulla griglia della banda 11, così da portarla a una risoluzione di 20 m e rendere le due immagini utilizzabili per l'NDMI. Questo indice quindi, a differenza dell'NDVI, è quindi stato calcolato con una risoluzione spaziale di 20 m.  
Viene usata la funzione `resample()` del pacchetto `terra`

```r
# method = "average" fa la media dei pixel che vengono accorpati nel nuovo pixel
oct18b8_20m <- resample(oct18[[4]], oct18b11, method = "average")  # argomenti(img da ricampionare, img su cui fare ricampionamento, metodo di ricampionamento)
oct19b8_20m <- resample(oct19[[4]], oct19b11, method = "average")  
oct21b8_20m <- resample(oct21[[4]], oct21b11, method = "average")
```

## Calcolo dell'NDMI

```r
ndmi18 <- (oct18b8_20m - oct18b11)/(oct18b8_20m + oct18b11)
ndmi19 <- (oct19b8_20m - oct19b11)/(oct19b8_20m + oct19b11)
ndmi21 <- (oct21b8_20m - oct21b11)/(oct21b8_20m + oct21b11)

ndmi <- c(ndmi18, ndmi19, ndmi21)

# Visualizzazione
par(mfrow=c(1,3))
plot(ndmi18, col = mako(100), range=range(values(ndmi), na.rm = TRUE), main = "NDMI 2018")
plot(ndmi19, col = mako(100), range=range(values(ndmi), na.rm = TRUE), main = "NDMI 2019")
plot(ndmi21, col = mako(100), range=range(values(ndmi), na.rm = TRUE), main = "NDMI 2021")

dev.off()
```

<p align="center">
<img width="800" height="400" alt="NDMI" src="https://github.com/user-attachments/assets/a44442d3-57d6-4996-89cd-21784260ae89" />

> I valori di NDMI sono generalmente abbastanza bassi, già nel 2018. Comunque è ben visibile la differenza tra la zona di pineta più abbondante a sud e il resto del territorio. L'NDMI diminuisce nel 2019 e torna ad aumentare nel 2021 in modo apparentemente analogo a quello dell'NDMI. Le aree con NDMI basso corrispondono infatti, approssimativamente, a quelle attribuibili a vegetazione morta o suolo scoperto grazie all'NDVI. Boh non so che altro diree.

## Ridgeline plot NDMI

```r
names(ndmi) <- c("NDMI 2018", "NDMI 2019", "NDMI 2021")
r1 <- im.ridgeline(ndmi, scale = 1, palette = "mako") +
  xlim(-0.3, 0.4) +                                                  # limitazione dei valori di x per una visualizzazione migliore
  theme_minimal()+                                                   # tema con sfondo bianco
  labs(title = "Ridgeline plot dei valori di NDMI" , fill = "NDMI")  # titolo grafico e titolo legenda

plot(r1)
```

<p align="center">
<img width="800" height="600" alt="ridgeline_NDMI" src="https://github.com/user-attachments/assets/9586d891-059d-4009-8435-9b0cb8d78486" />

> La variazione della distribuzione delle frequenze dell'NDMI è simile a quanto visto per l'NDVI, anche se si muove su range di valori diversi, e anche meno ampi. pfffff

## Variazione di NDMI

```r
d_ndmi18_19 <- ndmi[[2]] - ndmi[[1]]
d_ndmi18_21 <- ndmi[[3]] - ndmi[[2]]
d_ndmi18_21 <- ndmi[[3]] - ndmi[[1]]

par(mfrow = c(1,3))
plot(d_ndmi18_19, col = inferno(100), main = "ΔNDMI 2018-2019")
plot(d_ndmi19_21, col = inferno(100), main = "ΔNDMI 2019-2021")
plot(d_ndmi18_21, col = inferno(100), main = "ΔNDMI 2018-2021")
```

<p align="center">
<img width="800" height="400" alt="ΔNDMI" src="https://github.com/user-attachments/assets/10f0e0e8-a6e8-4553-9adb-913cde080523" />


> Stessa roba uffa

  
# CLASSIFICAZIONE

È stata applicata una classificazione per categorizzare i valori di NDVI in classi e analizzarne l'evoluzione nel tempo.  
Sono state fornite le seguenti classi di riferimento.

|Classe|Valori di NDMI|                 
  |--------|--------|
  |Vegetazione assente o morta|< 0,2|
  |Vegetazione scarsa e/o stressata|0,2 - 0,4|
  |Vegetazione abbondante e/o sana|> 0,4|

Creazione della matrice con le categorie
```r
cat <- matrix(c(
  -Inf, 0.2,  1,
  0.2, 0.4,  2,
  0.4, Inf,  3
), ncol = 3, byrow = TRUE)
```

Classificazione dei dati in base alla matrice

```r
classi <- classify(ndvi, rcl = cat)

#Assegnazione dei nomi delle classi
nomi <-c("Vegetazione assente o morta", "Veg scarsa e/o stressata", "Veg abbondante e/o sana")

#Creazione di una palette + assegnazione dei colori i nomi delle classi, nell'ordine che ho definito con l'oggetto nomi
#funzione setNames() da stats (core package di R)
palette <- setNames(
  viridis(3, option = "viridis"),
  nomi
)
```
Visualizzazione delle mappe classificate

```r
par(mfrow=c(1,3))
plot(classi[[1]], col = palette, main = "2018")
plot(classi[[2]], col = palette, main = "2019")
plot(classi[[3]], col = palette, main = "2021")

legend(                    # Aggiungta della legenda
  "top",
  legend = nomi,
  fill = palette,
  xpd = TRUE
)
```

<p align="center">
<img width="800" height="400" alt="plot_classi" src="https://github.com/user-attachments/assets/7ef5331c-cd41-4eb8-810c-8aab72161b0d" />

COMMENTO 

## Analisi quantitativa delle classi

Sono state calcolate le percentuali di copertura delle classi per ogni anno preso in esame, e i valori sono poi stati inseriti in una tabella

```r
freq_18 <- freq(classi[[1]])  #crea tabella con i pixel di ogni classe nella colonna count
perc_18 <- freq_18$count * 100 / ncell(classi)   #divide valori di frequenza ($count) per il numero di pixel (ncell)

freq_19 <- freq(classi[[2]])
perc_19 <- freq_19$count * 100 / ncell(classi)

freq_21 <- freq(classi[[3]])
perc_21 <- freq_21$count * 100 / ncell(classi)

#Creazione tabella con i risultati
#Arrotondamento a una cifra decimale con round()
tab <- data.frame(
  class= nomi,
  perc18=round(perc_18, 1),
  perc19=round(perc_19, 1),
  perc21=round(perc_21, 1)
)

tab$class <- factor(tab$class, levels = nomi) #ordina le classi secondo il vettore nomi, altrimenti vengono automaticamente messe in ordine alfabetic
##non è obbligatorio, però lo faccio perché voglio che nel barplot le colonne siano nell'ordine morta/scarsa/sana. Rendo anche le cateogorie un dato factor, ovvero una categoria
tab  #visualizzazione della tabella
```

I risultati sono qui riportati.

|Classi(%)|2018|2019|2021|                 
  |--------|--------|---------|-------|
  |Vegetazione assente o morta|1,7|79,7|6,9|
  |Vegetazione scarsa e/o stressata|62,4|20,3|90,0|
  |Vegetazione abbondante e/o sana|35,8|0,0|3,1|


Infine, sono stati creati dei barplot per visualizzare le variazioni delle percentuali

```r
#ggplot() permette di creare grafici e aggiungere elementi con "+"
#I valori sono presi dalla tabella tab
p18 <- ggplot(tab, aes(x = class, y = perc18, fill = class)) +      # aes() determina come inserire gli elementi di tab nel grafico
  geom_bar(stat = "identity")  +                                    # crea le barre, stat = "indentity" dice di inserire i valori della tabella
  ylim(0,100) +                                                     # range dell'asse y
  scale_fill_manual(values = palette) +                             # assegna colori da una palette creata manualmente
  scale_x_discrete(labels = NULL) +                                 # toglie i nomi delle classi dall'asse x
  labs(title = "2018" , x = NULL, y = "copertura(%)") +             # definizione titolo e nomi degli assi. NULL permette di togliere il nome dell'asse x
  theme_minimal() +                                                 # tema minimal alle grafiche. Sfondo bianco rispetto a quello grigio di default
  theme(legend.position = "none")                                   # elimina la legenda

# Stessa struttura per creare gli altri grafici
p19 <- ggplot(tab, aes(x = class, y = perc19, fill = class)) +
  geom_bar(stat = "identity")  +         
  ylim(0,100) +
  scale_fill_manual(values = palette) +  
  scale_x_discrete(labels = NULL) +
  labs(title = "2019" , x = NULL, y = "copertura(%)") +
  theme_minimal() +
  theme(legend.position = "none")

p21 <- ggplot(tab, aes(x = class, y = perc21, fill = class)) +
  geom_bar(stat = "identity")  +        
  ylim(0,100) +
  scale_fill_manual(values = palette) +  
  scale_x_discrete(labels = NULL) +
  labs(title = "2021" , x = NULL, y = "copertura(%)", fill = "LEGENDA") +  # fill definisce il titolo della legenda
  theme_minimal()
  # Solo questo grafico contiene la legenda, visto che i 3 plot verranno visualizzati assieme

# Visualizzazione dei 3 grafici affiancati grazie a pacchetto patchwork
p18 + p19 + p21
```

<p align="center">
<img width="1000" height="400" alt="barplot" src="https://github.com/user-attachments/assets/551f58b7-eaaf-42b7-9674-922d044a0d78" />



COMMENTO


# CONCLUSIONE

# BIBLIOGRAFIA





