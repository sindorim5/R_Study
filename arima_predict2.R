# https://otexts.com/fppkr/holt-winters.html
# https://a-little-book-of-r-for-time-series.readthedocs.io/en/latest/src/timeseries.html

library(tseries)
library(forecast)
library("forecast")
library(xts)
library(tidyverse)
library(zoo)
library(MTS)
library(TTR)

all <- readRDS(
    file = "all_orderby_time.rds"
)

# 3674 = 2002.1.1 0시 ~ 187752 = 2022.12.31 23시
all_2002 <- all[3673:187752, ]

KP <- all_2002$KP

KP.ts <- ts(KP, start = c(2002, 1), frequency = 24 * 365.25)

# auto.arima
KP.arima <- auto.arima(KP.ts)
KP.arima

# MA = 3 으로 간소화
KP.ts.SMA3 <- SMA(KP.ts,
    start = c(2002, 1),
    frequency = 24 * 365.25,
    n = 3
)

# MA = 12 로 간소화
KP.ts.SMA12 <- SMA(KP.ts,
    start = c(2002, 1),
    frequency = 24 * 365.25,
    n = 12
)

KPcomponents <- decompose(KP.ts)
plot(KPcomponents)

# beta: If set to FALSE , the function will do exponential smoothing.
# gamma: If set to FALSE , an non-seasonal model is fitted.
KPforecasts <- HoltWinters(KP.ts)

KPforecasts

summary(KPforecasts$alpha)

str(KPforecasts)

plot(KPforecasts)

KPforecasts2 <- forecast(KPforecasts, h = 12)

KPforecasts2

tail(all_2002$DATE)
