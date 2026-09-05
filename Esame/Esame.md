# Analisi dell'impatto dell'uragano Dorian sulla vegetazione di Grand Bahama

> #### Corso di Telerilevamento Geo-Ecologico in R, a.a. 2025-26
> #### Elena Betti

## Indice?

# Introduzione

Tra il 1 e 3 settembre 2019, l'isola di Grand Bahama è stata colpita dall'uragano Dorian. Si è trattato del più forte uragano che ha colpito le Bahamas in tempi moderni, e uno dei più potenti mai registrati nell'Oceano Atlantico, raggiungendo categoria 5 e venti oltre i 350 km/h. Oltre ai venti, una forte mareggiata con onde fino a 6 m di altezza ha inondato le quote più basse dell'isola. La tempesta ha colpito soprattutto la parte centro-orientale dell'isola, e oltre numerose vittime e danni devastanti ai centri abitati, ha causato importanti danni alle foreste. L'isola di Grand Bahama si trova nei Caraibi e a causa della sua posizione geografica è regolarmente interessata da tempeste tropicali, con picco nei mesi di settembre e ottobre, che coincidono con gli ultimi mesi del periodo delle piogge. La vegetazione è caratterizzata da foreste di Pino delle Bahamas (_Pinus caribae_ var. _bahamensis_ (Griseb.) W. H. Barrett & Golfari) e di mangrovie nelle aree più vicine alla costa. Sembra che l'uragano Dorian abbia causato l'estinzione del picchio muratore delle Bahamas (_Sitta insularis_), specie endemica dell'isola e già a rischio critico prima del 2019, che non è stata più osservata negli anni successivi.

# Obiettivo del progetto

Questo progetto vuole analizzare l'impatto dell'uragano Dorian sulla vegetazione dell'isola in 3 diversi momenti: 

* Ottobre 2018, prima dell'uragano;
* Ottobre 2019, circa un mese dopo;
* Ottobre 2021, due anni dopo


è stata selezionata un'area di [inserire ettari o metri quadri] nella parte centrale dell'isola, a ovest dell'aeroporto ausiliare di Grand Bahama. Sono state svolte le seguenti analisi:

* NDVI (Normalized Difference Vegetation Index)
* NDMI (Normalized Difference Moisture Index)
* Classificazione dei valori di NDVI e mappatura del territorio
* Quantificazione percentuale dell'estensione delle classi

# Dati

Le immagine satellitari di Sentinel_2A sono state scaricate dal portale di [Copernicus](https://browser.dataspace.copernicus.eu/).

***Tabella 1.** Bande utilizzate*

  |BANDE|RISOLUZIONE SPAZIALE|DESCRIZIONE|UTILIZZO|                 
  |--------|--------|---------|-------|
  |B2|10 m|Blu|visualizzazione RGB|
  |B3|10 m|Verde|Visualizzazione RGB|
  |B4|10 m|Rosso|Visualizzazione RGB, NDVI|
  |B8|10 m|NIR(vicino infrarosso)|NDVI, NDMI|
  |B11|20 m| SWIR 1|NDMI|

## Pacchetti

```r
library(terra)      # Visualizzazione e manipolazione di raster spaziali
library(imageRy)    # ?? guarda bene quali funzioni hai preso
library(viridis)    # Palette e colori
library(ggplot2)    # Creazione di grafici
library(ggridges)   # Creazione di ridgeline plots
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
# Importazione delle delle bande di Sentinel-2
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

Utilizzo le funzioni ext() e crop() del pacchetto terra per definire e ritagliare l'area di interesse. Le coordinate sono indicate in UTM (scrivere meglio il sistema magari)

```r
aoi <- ext(754809, 763308, 2946037, 2953282) # coordinate UTM sono in questo ordine: xmin, xmax, ymin, ymax

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

L'NDVI misura la salute e l'abbondanza della vegetazione tramite le differenze tra riflettanza nel vicino infrarosso (NIR), che è particolarmente alta nelle foglie in salute e diminuisce progressivamente quando la pianta è sotto stress o le foglie muoiono. Grazie alla normalizzazione (wait il prof non aveva detto che è una standardizzazione invece di una normalizzazione?), che lo distingue dal DVI (Difference Vegetation Index), restituisce valori compresi tra -1 e 1, e può essere usato per confrontare immagini acquisite in condizioni diverse (spiegare meglio).
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
# Definisco il range di valori tra i valori minimo e massimo assoluto, in modo da avere stessa scala di valori tra le 3 immagini
```

<p align="center">
<img width="800" height="400" alt="NDVI" src="https://github.com/user-attachments/assets/e840e3f2-a1b3-404c-a30f-28d89c207441" />

COMMENTO

Creazione di un ridgeline pront per confrontare la distribuzione dei valori di NDVI nelle 3 immagini
Utilizzo im.ridgeline() di imageRy

```r
names(ndvi) <- c("NDVI 2018", "NDVI 2019", "NDVI 2021")              # Assegnazione nomi elementi
 
r <- im.ridgeline(ndvi, scale = 2, palette = "viridis") +            # Aggiunta di elementi dopo + con la sintassi di ggplot
  xlim(0, 0.75) +                                                    # Restringimento dei valori di x per una visualizzazione migliore
  theme_minimal()+                                                   # Tema minimal con sfondo bianco
  labs(title = "Ridgeline plot dei valori di NDVI" , fill = "NDVI")  # Titolo grafico e titolo legenda

plot(r)
```

<p align="center">
<img width="400" height="300" alt="ridgeline_ndvi" src="https://github.com/user-attachments/assets/4aee81fb-1be2-4e2c-b419-c81a598a3f98" />

COMMENTO


## Variazione di NDVi 

Il calcolo della differenza di NDVI tra gli anni permette di visualizzare la variazione dell'indice sulla mappa. Valori positivi e negativi come leggerli?

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


COMMENTO


# NDMI (Normalized Difference Vegetation Index)

$$
NDMI = \frac{NIR - SWIR 1}{NIR + SWIR 1}
$$
L'NDMI viene utilizzato per misurare il contenuto di acqua nella vegetazione. !Devo dire qualcosa sulle bande, tipo perché lo SWIR 1! Varia tra -1 e 1, valori vicini a 1 indicano vegetazione in salute e assenza di stress idrico, mentre valori attorno a 0 o negativi possono essere interpretati come vegetazione secca, o sotto stress idrico.

## Ricampionamento banda 8 10m -> 20m
Sentinel-2 ottiene la banda 8 del vicino infrarosso a una risoluzione di 10 m, mentre quella dello SWIR 1 a risoluzione di 20 m. Per questo la banda 8 è stata ricampionta sulla griglia della banda 11, così da portarla a una risoluzione di 20 m e rendere le due bande utilizzabili assieme. L'NDMI, a differenza dell'NDVI, è quindi stato calcolato con una risoluzione spaziale di 20 m.  
Viene usata la funzione resample() di terra

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

COMMENTO

! Non so ancora quali dei seguenti diagrammi inserirò

## Ridgeline plot NDMI

```r
names(ndmi) <- c("NDMI 2018", "NDMI 2019", "NDMI 2021")
r1 <- im.ridgeline(ndmi, scale = 2, palette = "mako") +
  xlim(-0.3, 0.4) +                                                  # limitazione dei valori di x per una visualizzazione migliore
  theme_minimal()+                                                   # tema con sfondo bianco
  labs(title = "Ridgeline plot dei valori di NDMI" , fill = "NDMI")  # titolo grafico e titolo legenda

plot(r1)
```

<p align="center">
<img width="400" height="300" alt="ridgeline_NDMI" src="https://github.com/user-attachments/assets/3529ae00-8bd2-4123-b0d3-9e94d605b6b1" />

## Variazione di NDMI tra 2018 e 2021

Mi sembra più sensato fare solo questo confronto qua, perché voglio vedere se nel 2021 la vegetazione è più in stress idrico della situazione pre-impatto

```r
d_ndmi18_21 <- ndmi[[3]] - ndmi[[1]]
plot(d_ndmi18_21, col = inferno(100), main = "ΔNDMI 2018-2021")
```

<p align="center">
<img width="400" height="300" alt="ΔNDMI 2018-2021" src="https://github.com/user-attachments/assets/2012e60f-990f-4938-a846-92cbdc550353" />

COMMENTO

## Scatterplot

in pratica mi fa vedere in base a se la nuvola di punti è sopra o sotto la linea se c'è stata una generale diminuzione tra i due anni.
Utile perché magari dalle mappe e basta è più difficile da capire
Però alla fine lo potevo vedere anche dal ridgeline quindi forse è inutile metterli entrambi?


<p align="center">
<img width="400" height="300" alt="pairs_NDMI" src="https://github.com/user-attachments/assets/2be40679-c797-4901-af8e-529a27a32c0a" />

<p align="center">
<img width="400" height="300" alt="Scatterplot_NDMI" src="https://github.com/user-attachments/assets/e22aa2ca-c320-41ea-8940-d7f6b1c11659" />


  
# CLASSIFICAZIONE

È stata applicata una classificazione per categorizzare i valori di NDVI in classi e analizzarne l'evoluzione nel tempo. La classificazione non è automatica, e sono state fornite le seguenti classi di riferimento.

TABELLA TABELLA TABELLA da aggiungere

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

TABELLA TABELLA

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





