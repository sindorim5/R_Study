install.packages("xml2", repos = "http://cran.us.r-project.org")
install.packages("XML", repos = "http://cran.us.r-project.org")
install.packages("xlsx", repos = "http://cran.us.r-project.org")


library(tidyverse)
library(dplyr)
library(xml2)
library(XML)
library(methods)
library(lubridate)
library(xlsx)

# meteor_showers
# meteor_showers <- xmlToDataFrame(
#     "meteor_shower/real_data/IMO_Working_Meteor_Shower_List.xml"
# )
# 숫자로 바꾸기
months <- c(
    "Jan" = 1, "Feb" = 2, "Mar" = 3, "Apr" = 4,
    "May" = 5, "Jun" = 6, "Jul" = 7, "Aug" = 8,
    "Sep" = 9, "Oct" = 10, "Nov" = 11, "Dec" = 12
)
split_month_day <- strsplit(meteor_showers$start, " ")
temp_month <- sapply(split_month_day, function(x) x[1])
temp_month <- months[temp_month]
temp_day <- sapply(split_month_day, function(x) x[2])
meteor_showers$startDate <- as.Date(
    paste(
        2023,
        ifelse(
            temp_month < 10,
            paste0("0", temp_month),
            temp_month
        ),
        temp_day,
        sep = ""
    ),
    format = "%Y%m%d"
)
split_month_day <- strsplit(meteor_showers$end, " ")
temp_month <- sapply(split_month_day, function(x) x[1])
temp_month <- months[temp_month]
temp_day <- sapply(split_month_day, function(x) x[2])
meteor_showers$endDate <- as.Date(
    paste(
        2023,
        ifelse(
            temp_month < 10,
            paste0("0", temp_month),
            temp_month
        ),
        temp_day,
        sep = ""
    ),
    format = "%Y%m%d"
)
# startDate가 endDate보다 미래라면? (해를 넘어가는 경우)
meteor_showers$startDate[1] <- ymd(meteor_showers$startDate[1]) - years(1)
meteor_showers$startDate[2] <- ymd(meteor_showers$startDate[2]) - years(1)
meteor_showers$startDate[43] <- ymd(meteor_showers$startDate[43]) - years(1)
## meteor_showers$peak
split_month_day <- strsplit(meteor_showers$peak, " ")
temp_month <- sapply(split_month_day, function(x) x[1])
temp_month <- months[temp_month]
temp_day <- sapply(split_month_day, function(x) x[2])
meteor_showers$peakDate <- as.Date(
    paste(
        2023,
        ifelse(
            temp_month < 10,
            paste0("0", temp_month),
            temp_month
        ),
        temp_day,
        sep = ""
    ),
    format = "%Y%m%d"
)
