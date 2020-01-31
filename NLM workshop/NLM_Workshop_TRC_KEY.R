load("~/Documents/Git Repository/QuanEco/NLM workshop/NLM_Workshop copy.RData")
library(nlstools)


Selfstart for TRC:
  
  # Selfstart for the trc:
  trcModel <- function(TA, a, b) {
    y=a * exp(b*TA)
    return(y) 
  }

# Create a function to find initial values for the selfstart function:
trc.int <- function (mCall, LHS, data){
  x <- data$TA
  y <- data$NEE
  
  a <-1.00703982 + -0.08089044* (min(na.omit(y)))
  b <- 0.051654 + 0.001400 * (min(na.omit(y))) 
  
  value = list(a, b)
  names(value) <- mCall[c("a", "b")]
  return(value)
}

# Selfstart Function
SS.trc <- selfStart(model=trcModel,initial= trc.int)

#___

   # Dataframe to store parms and se
   parms.Month <- data.frame(
     MONTH=numeric(),
     a1=numeric(),
     ax=numeric(),
     r=numeric(),
     a1.pvalue=numeric(),
     ax.pvalue=numeric(),
     r.pvalue=numeric(), stringsAsFactors=FALSE, row.names=NULL)
   parms.Month[1:12, 1] <- seq(1,12,1) # Adds months to the file
   
   
nee.day <- function(dataframe){ y = nls( NEE ~ (a1 * PAR * ax)/(a1 * PAR + ax) + r, dataframe, 
                                         start=list(a1= iv$a1 , ax= iv$ax, r= iv$r),
                                         na.action=na.exclude, trace=F, 
                                         control=nls.control(warnOnly=T))
y.df <- as.data.frame(cbind(t(coef(summary(y)) [1:3, 1]), t(coef(summary(y)) [1:3, 4]))) 
names(y.df) <-c("a1","ax", "r", "a1.pvalue", "ax.pvalue", "r.pvalue")
return (y.df )}

try(for(j in unique(day$MONTH)){
  
  # Determines starting values:
  iv <- getInitial(NEE ~ SS.lrc('PAR', "a1", "ax", "r"), data = day[which(day$MONTH == j) ,])
  # Fits light response curve:
    y3 <- try(nee.day(day[which(day$MONTH == j),]), silent=T) 
  # Extracts data and saves it in the dataframe
    try(parms.Month[c(parms.Month$MONTH == j ), 2:7 ] <- cbind(y3), silent=T) 
    rm(y3)
}, silent=T)
parms.Month
   

# Create file to store parms and se
boot.NEE <- data.frame(parms.Month[, c("MONTH")]); names (boot.NEE) <- "MONTH" 
boot.NEE$a1.est <- 0
boot.NEE$ax.est<- 0
boot.NEE$r.est<- 0
boot.NEE$a1.se<- 0
boot.NEE$ax.se<- 0
boot.NEE$r.se<- 0

for ( j in unique(boot.NEE$Month)){
  
  y1 <-day[which(day$MONTH == j),] # Subsets data
  
  # Determines the starting values:
  iv <- getInitial(NEE ~ SS.lrc('PAR', "a1", "ax", "r"), data = y1)
  
  # Fit curve:
  day.fit <- nls( NEE ~ (a1 * PAR * ax)/(a1 * PAR + ax) + r, data=y1, 
                  start=list(a1= iv$a1 , ax= iv$ax, r= iv$r),
                  na.action=na.exclude, trace=F, control=nls.control(warnOnly=T))
  
  # Bootstrap and extract values:
  try(results <- nlsBoot(day.fit, niter=100 ), silent=T) 
  try(a <- t(results$estiboot)[1, 1:3], silent=T) 
  try(names(a) <- c('a1.est', 'ax.est', 'r.est'), silent=T) 
  try( b <- t(results$estiboot)[2, 1:3], silent=T) 
  try(names(b) <- c('a1.se', 'ax.se', 'r.se'), silent=T) 
  try(c <- t(data.frame(c(a,b))), silent=T)
  
  # Add bootstrap data to dataframe:
  try(boot.NEE[c(boot.NEE$MONTH == j), 2:7] <- c[1, 1:6], silent=T) 
  try(rm(day.fit, a, b, c, results, y1), silent=T)
  
}

lrc <- merge( parms.Month, boot.NEE, by.x="MONTH", by.y="MONTH") # Merge dataframes
lrc
   