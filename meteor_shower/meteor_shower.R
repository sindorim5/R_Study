library(tidyverse)
library(dplyr)


meteor_showers <- read.csv(
    file = "meteor_shower/meteorshowers.csv"
)
moon_phases <- read.csv(
    file = "meteor_shower/moonphases.csv",
    na.strings = c("", " ", "NA", NA)
)
# 별자리
constellations <- read.csv(
    file = "meteor_shower/constellations.csv"
)
cities <- read.csv(
    file = "meteor_shower/cities.csv"
)

# 숫자로 바꾸기
months <- c(
    "january" = 1, "february" = 2, "march" = 3, "april" = 4,
    "may" = 5, "june" = 6, "july" = 7, "august" = 8,
    "september" = 9, "october" = 10, "november" = 11, "december" = 12
)
meteor_showers$bestmonth <- months[meteor_showers$bestmonth]
meteor_showers$startmonth <- months[meteor_showers$startmonth]
meteor_showers$endmonth <- months[meteor_showers$endmonth]
moon_phases$month <- months[moon_phases$month]
constellations$bestmonth <- months[constellations$bestmonth]

# 날짜로 바꾸기
meteor_showers$startdate <- as.Date(paste0(
    2020,
    paste(ifelse(
        as.integer(meteor_showers$startmonth) < 10,
        paste("0", as.integer(meteor_showers$startmonth), sep = ""),
        meteor_showers$startmonth
    )),
    paste(ifelse(
        as.integer(meteor_showers$startday) < 10,
        paste("0", as.integer(meteor_showers$startday), sep = ""),
        meteor_showers$startday
    )),
    sep = ""
), format = "%Y%m%d")
meteor_showers$enddate <- as.Date(paste(
    2020,
    paste(ifelse(
        as.integer(meteor_showers$endmonth) < 10,
        paste("0", as.integer(meteor_showers$endmonth), sep = ""),
        meteor_showers$endmonth
    )),
    paste(ifelse(
        as.integer(meteor_showers$endday) < 10,
        paste("0", as.integer(meteor_showers$endday), sep = ""),
        meteor_showers$endday
    )),
    sep = ""
), format = "%Y%m%d")
moon_phases$date <- as.Date(paste(
    2020,
    paste(ifelse(
        as.integer(moon_phases$month) < 10,
        paste("0", as.integer(moon_phases$month), sep = ""),
        moon_phases$month
    )),
    paste(ifelse(
        as.integer(moon_phases$day) < 10,
        paste("0", as.integer(moon_phases$day), sep = ""),
        moon_phases$day
    )),
    sep = ""
), format = "%Y%m%d")
hemispheres <- c("northern" = 0, "southern" = 1, "northern, southern" = 3)
meteor_showers$hemisphere <- hemispheres[meteor_showers$hemisphere]
constellations$hemisphere <- hemispheres[constellations$hemisphere]
phases <- c(
    "new moon" = 0, "third quarter" = 0.5,
    "first quarter" = 0.5, "full moon" = 1.0
)
moon_phases$percentage <- phases[moon_phases$moonphase]
# 안 쓰는 데이터 제거
meteor_showers <- meteor_showers %>% select(
    -startmonth, -startday, -endmonth, -endday, -hemisphere
)
moon_phases <- moon_phases %>% select(
    -month, -day, -moonphase, -specialevent
)
constellations <- constellations %>% select(
    -besttime
)
# 마지막에 확인한 위상을 저장하고 붙여넣는다
lastPhase <- 0
for (index in seq_len(nrow(moon_phases))) {
    if (is.na(moon_phases[index, "percentage"])) {
        moon_phases[index, "percentage"] <- lastPhase
    } else {
        lastPhase <- moon_phases[index, "percentage"]
    }
}
# 볼 수 있는 별자리 리스트
getConstellationList <- function(city) {
    latitude <- cities[cities$city == city, "latitude"]
    constellation_list <- constellations[
        which(constellations$latitudestart >= latitude & constellations$latitudeend <= latitude),
        "constellation"
    ]
    return(constellation_list)
}
c_list <- getConstellationList("Abu Dhabi")
getMeteorShowerList <- function(constellation_list) {
    best_moon_dates <- data.frame(constellation = character(), date = character())
    for (constellation in constellation_list) {
        meteor_shower <- meteor_showers[meteor_showers$radiant == constellation, "name"][1]
        meteor_shower_startdate <- meteor_showers[meteor_showers$radiant == constellation, "startdate"][1]
        meteor_shower_enddate <- meteor_showers[meteor_showers$radiant == constellation, "enddate"][1]
        moon_phases_list <- moon_phases[
            moon_phases$date >= meteor_shower_startdate & moon_phases$date <= meteor_shower_enddate,
        ]
        best_moon_date <- moon_phases_list[which.min(moon_phases_list$percentage), "date"]
        best_moon_dates <- rbind(
            best_moon_dates,
            data.frame(constellation = constellation, date = best_moon_date)
        )
    }
    return(best_moon_dates)
}
test <- getMeteorShowerList(c_list)

test

str(meteor_showers)
