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
Le bande sono state importate separatamente e poi riunite in stack per ogni anno.
!Aggiungere commentino con la struttura generale dello stack e le bande corrispondenti ai vari livelli

```r

MANCA

```

> [!NOTE]
>
> La banda 11 viene tenuta separata dalle altre, vista la differente risoluzione spaziale. Verrà utilizzata più tardi per il calcolo dell'NDMI

## Ritaglio dell'area di interesse

Utilizzo le funzioni ext() e crop() del pacchetto terra per definire e ritagliare l'area di interesse. Le coordinate sono indicate in UTM (scrivere meglio il sistema magari)

```r

MANCA

```

# Visualizzazione

Non so se mettere anche la visualizzazione delle singole bande

## Colori reali (RGB)

```r

MANCA

```
<p align="center">
<img width="800" height="400" alt="RGB_bahamas" src="https://github.com/user-attachments/assets/a176e3db-2bd1-46f2-b322-965b9db2ad8f" />

COMMENTO


## Falsi colori (NIR - rosso - verde)

```r

MANCA

```

<p align="center">
<img width="800" height="400" alt="NIR_bahamas" src="https://github.com/user-attachments/assets/08ca8c4d-a3d0-4f05-86c2-462972dd040c" />
  
COMMENTO


## Esportazione delle immagini


# NDVI (Normalized Difference Vegetation Index)

$$
NDVI = \frac{NIR - RED}{NIR + RED}
$$

L'NDVI misura la salute e l'abbondanza della vegetazione tramite le differenze tra riflettanza nel vicino infrarosso (NIR), che è particolarmente alta nelle foglie in salute e diminuisce progressivamente quando la pianta è sotto stress o le foglie muoiono. Grazie alla normalizzazione (wait il prof non aveva detto che è una standardizzazione invece di una normalizzazione?), che lo distingue dal DVI (Difference Vegetation Index), restituisce valori compresi tra -1 e 1, e può essere usato per confrontare immagini acquisite in condizioni diverse (spiegare meglio).
Valori di NDVI sotto allo 0.2 sono associati ad assenza di vegetazione (suolo, acqua, tessuto urbano, ...) o vegetazione morta, mentre valori tra 0.2 e 1 indicano vegetazione progressivamente sempre più in salute e abbondante.

```r

MANCA

```

<p align="center">
<img width="800" height="400" alt="NDVI" src="https://github.com/user-attachments/assets/e840e3f2-a1b3-404c-a30f-28d89c207441" />

COMMENTO

Creazione di un ridgeline pront per confrontare la distribuzione dei valori di NDVI nelle 3 immagini

```r

MANCA

```

<p align="center">
<img width="400" height="300" alt="ridgeline_ndvi" src="https://github.com/user-attachments/assets/4aee81fb-1be2-4e2c-b419-c81a598a3f98" />

COMMENTO


## Variazione di NDVi 

Il calcolo della differenza di NDVI tra gli anni permette di visualizzare la variazione dell'indice sulla mappa. Valori positivi e negativi come leggerli?

```r

MANCA

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

```r

MANCA

```

#Calcolo dell'NDMI

```r

MANCA

```

<p align="center">
<img width="800" height="400" alt="NDMI" src="https://github.com/user-attachments/assets/a44442d3-57d6-4996-89cd-21784260ae89" />

COMMENTO

Qua poi dovrò capire se mettere anche  ridgeline e scatterplot. Sicuro faccio la differenza tra il 2018 e il 2021

<p align="center">
<img width="400" height="300" alt="ridgeline_NDMI" src="https://github.com/user-attachments/assets/3529ae00-8bd2-4123-b0d3-9e94d605b6b1" />

<p align="center">
<img width="400" height="300" alt="ΔNDMI 2018-2021" src="https://github.com/user-attachments/assets/2012e60f-990f-4938-a846-92cbdc550353" />

<p align="center">
<img width="400" height="300" alt="pairs_NDMI" src="https://github.com/user-attachments/assets/2be40679-c797-4901-af8e-529a27a32c0a" />

<p align="center">
<img width="400" height="300" alt="Scatterplot_NDMI" src="https://github.com/user-attachments/assets/e22aa2ca-c320-41ea-8940-d7f6b1c11659" />


  
# CLASSIFICAZIONE

È stata applicata una classificazione per categorizzare i valori di NDVI in classi e analizzarne l'evoluzione nel tempo. La classificazione non è automatica, e sono state fornite le seguenti classi di riferimento.

TABELLA TABELLA TABELLA


```r

MANCA

```

<p align="center">
<img width="800" height="400" alt="plot_classi" src="https://github.com/user-attachments/assets/7ef5331c-cd41-4eb8-810c-8aab72161b0d" />


## Analisi quantitativa delle classi

Sono state calcolate le percentuali di copertura delle classi per ogni anno preso in esame.

```r

MANCA

```

I risultati sono riportati in questa tabella.

TABELLA TABELLA

Infine, sono stati creati dei barplot per visualizzare le variazioni delle percentuali

```r

MANCA

```

<p align="center">
<img width="1000" height="400" alt="barplot" src="https://github.com/user-attachments/assets/551f58b7-eaaf-42b7-9674-922d044a0d78" />



COMMENTO


# CONCLUSIONE

# BIBLIOGRAFIA





