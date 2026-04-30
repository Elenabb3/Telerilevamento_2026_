#creazione della propria funzione

#es funzione somma
#function(argomento1,argomento2)
somma <- function(x,y){
  z=x+y
  return(z)
}

divisione <- function(x,y){
  z=x/y
  return(z)
}

#funzione per farmi il multiframe

mf <- function (nx, ny){
  par(mfrow=c(nx,ny))
}

#posso anche farmi un multiframe default, che magari è uno che uso più spesso
mf2 <- function(nx=1,ny=2){
  par(mfrow=c(nx,ny))
}

#riprovare, non so perché in questo momento non mi fa i plot

#if else per fare funzioni
#funzione che distingue numeri positivi e  negativi

pos <- function (x) {
  if(x>0) {
    "Il numero è positivo"
  }
  else if (x<0) {
    "Il numero è negativo"
  }
  else {
    "0 non è nè positivo nè negativo"
  }
}

#se non inserivo else non succedeva niente

#ciclo for
#stampa tutti i numeri da 1 a 50
loop <- function() {
  for(i in 1:50)
    print(i)
}

#funzione che stampa tutti i numeri da 1 a 50 moltiplicati per 7. Che equivale a stampare la tabellina del 7
loop2 <- function() {
  for(i in 1:50)  {
    op <- i*7
    print(op)
    }
  }

#voglio esportare il risultato della mia funzione su un file
setwd("C:\\Users\\elena\\OneDrive - Alma Mater Studiorum Università di Bologna\\Desktop")
sink("output.txt")
loop2()
dev.off()


