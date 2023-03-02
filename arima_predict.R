install.packages("tseries", repos = "http://cran.us.r-project.org")
install.packages("forecast", repos = "http://cran.us.r-project.org")
install.packages("MTS", repos = "http://cran.us.r-project.org")

library(tseries)
library(forecast)
library(xts)
library(tidyverse)
library(zoo)
library(MTS)

all <- readRDS(
    file = "all_orderby_time.rds"
)

View(all[1, ])

all_2002 <- all %>% filter(all$DATE$year + 1900 == 2002 | all$DATE$year + 1900 == 2003)

View(all_2002)

str(all_2002)

# all$DATE <- as.Date(all$DATE)

# allTS <- xts(
#     x = all[, -1],
#     order.by = all$DATE,
#     frequency = 8760,
#     tzone = "UTC",
# )

head(all_2002[, -1])

allTS_2002 <- ts(
    all_2002,
    frequency = 8760,
    start = c(2002, 1)
)

mySelect <- allTS_2002[, 18:22]

mySelect.VARselect <- VARselect(mySelect, lag.max = 10, type = "const", season = 8760)

mySelect.VARselect

lags <- embed(
    mySelect,
    10
)

mySelect.model <- VAR(
    mySelect,
    p = 0,
    type = "const"
)

summary(mySelect.model)
