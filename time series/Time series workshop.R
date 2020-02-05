file.choose()
load("/Users/Lee/Desktop/QEco/time series/ARIMA_Workshop.RData")


library(zoo) 
library(tseries) 
library(forecast) 
library(xts)

# creating a time series objects, mangroves NEE daily data with 30 observations per month.
nee <- ts( mangroves$nee, start= 1, frequency=30)

# visualizing the mangroves NEE daily data with 30 observations per month for 12 months.
par(mfrow=c(1,1), mai=c(0.25,0.8,0.1, 0.1)) 
plot( nee, typ="l", ylab= "NEE", xlab="months")

#"You want to remove any outliers that could bias the model by skewing statistical summaries. 
#R provides a convenient method for removing time series outliers: tsclean() as part of its forecast package. 
#tsclean() identifies and replaces outliers using series smoothing and decomposition.

#tsclean will smooth the data set and remove outliers (just to visualize)
plot(nee)
lines(tsclean(nee), col="red")

# This code actually cleans the data
nee <- tsclean(nee)

# This code will decompose the data so that we may separate seasonality, trends, and error associated with timeseries data. 
# we are decomposing the time series
nee.d <- decompose(nee, 'multiplicative') 
plot(nee.d)

#because we are applying the ARIMA model, the model must be stationary. 
#"(A series is stationary when its mean, variance, and autocovariance are time invariant.)"

# p-value < 0.05 indicates the TS is stationary
adf.test(nee )


# Now we ae detecting autocorrelations. Also useful for visual tool to find whether series is stationary. displays correlation between a series and its lags.
acf(nee, lag.max=45)

# here we just do a partial autocorrelation, refer to pdf for full understanding
pacf(nee, lag.max=45)

#Here we are going to fit an ARIMA model to our data
arima.nee1 <-auto.arima(nee, trace=TRUE)

# Here we examine ACF and PACF lpots for model residuals. We would expect no significant  autocorrelations if 
# model order parameters and structure are correclty specified.
tsdisplay(residuals(arima.nee1), lag.max=45)

#repeat the fitting process now that we have an idea of a spike around 10
arima.nee2 <-arima(nee , order=c(10,1,3), seasonal= list(order=c(2,0,2)))

#Now displaying the residuals from 2nd ARIMA 
tsdisplay(residuals(arima.nee2), lag.max= 30)

#You want to minimize AIC
AIC(arima.nee1, arima.nee2)

# To compare models we use AIC, we also want to compare observed versus predicted values.
par(mfrow=c(1,1))
plot(nee , typ="l"); lines(fitted(arima.nee2),col="red")

# Measuring for significant difference from white noise.
# You need a p-value greater than 0.05!
checkresiduals(arima.nee2, lag=36)

#see graph again
par(mfrow=c(1,1))
plot(nee , typ="l"); lines(fitted(arima.nee2),col="red")

# forecast using the current model
plot(forecast(arima.nee2, h=30))

#


#NOW ONTO THE ACTUAL EXCERSIE 


#

# naming and grabbing mangrove salinity data for year, daily measurments, 30 a month
sal <- ts(mangroves$salinity.max, start= 1, frequency=30)

# visualizing the data pulled from last line
par(mfrow=c(1,1), mai=c(0.25,0.8,0.1, 0.1))
plot(sal , typ="l", ylab= "Salinity", xlab="")

# visualize outliers 
plot(sal , typ="l", ylab= "Salinity", xlab="") 
lines(tsclean(sal) , col="red")
#then remove (clean)
sal <- tsclean(sal)

sal.d <- decompose(sal, 'multiplicative') 
plot(sal.d)


# p-value < 0.05 indicates the TS is stationary
adf.test(sal)

# do if p-value is not less than 0.05
adf.test(diff(sal))


# autocorrelation
ccf( diff(sal),nee, na.action = na.pass, lag.max=40, plot=TRUE)

#fitting the model
arima.nee3 <-auto.arima(nee, xreg=c(diff(sal),0), trace=TRUE)


#compare to current model
AIC(arima.nee2, arima.nee3 )

sal.i <- sal 
sal.i[sal.i < 25 ]<- 0 
sal.i[sal.i >= 25 ]<- 1
plot(sal.i)
 

arima.nee4 <-auto.arima(nee, xreg=sal.i, trace=TRUE)


AIC(arima.nee2,arima.nee4)

print(AIC(arima.nee2,arima.nee4))

checkresiduals(arima.nee4, lag=36)

 
par(mfrow=c(1,1))
plot(nee , typ="l"); lines(fitted(arima.nee4),col="red")

