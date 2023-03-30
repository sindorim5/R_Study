library(tidyverse)
library(dplyr)
library(xml2)
library(XML)
library(methods)
library(lubridate)
library(xlsx)
library(tibble)

# meteor_showers 전처리 된 내용을 csv로 저장해서 다시 불러옴
meteor_showers <- read.csv(
    file = "meteor_shower/real_data/meteor_shower_crawl_radiant.CSV"
)
meteor_showers$startDate <- as.Date(meteor_showers$startDate)
meteor_showers$endDate <- as.Date(meteor_showers$endDate)
meteor_showers$peakDate <- as.Date(meteor_showers$peakDate)
# moon_phases
moon_phases <- read.csv(
    file = "meteor_shower/real_data/moon_illumination_1800-2100.csv"
)
moon_phases$date <- as.Date(
    moon_phases$date,
    format = "%Y-%m-%d"
)
# 달이 밝을 수록 숫자가 높다
# 유성우를 볼 확률은 낮다, 나중에 min으로 찾을 것
phases <- c(
    "new" = 0,
    "last quarter" = 0.5,
    "first quarter" = 0.5,
    "full" = 1.0,
    "waxing crescent" = 0.25,
    "waning crescent" = 0.25,
    "waxing gibbous" = 0.75,
    "waning gibbous" = 0.75
)
moon_phases$percentage <- phases[moon_phases$phase]
moon_phases_2023 <- moon_phases %>%
    filter(format(moon_phases$date, "%Y") == 2023)
# constellations
constellations <- read.csv(
    file = "meteor_shower/real_data/constellations_crawl.csv"
)
monthsFull <- c(
    "January" = 1, "February" = 2, "March" = 3, "April" = 4,
    "May" = 5, "June" = 6, "July" = 7, "August" = 8,
    "September" = 9, "October" = 10, "November" = 11, "December" = 12
)
constellations$bestmonth <- monthsFull[constellations$bestmonth]
hemispheres <- c("northern" = 0, "southern" = 1)
constellations$hemisphere <- hemispheres[constellations$hemisphere]
# cities
cities <- read.csv(
    file = "meteor_shower/real_data/cities_crawl.csv"
)
cities$Latitude <- as.numeric(cities$Latitude)
# 안 쓰는 데이터 제거
meteor_showers <- meteor_showers %>% select(
    name, radiant, startDate, endDate, peakDate
)
moon_phases_2023 <- moon_phases_2023 %>% select(
    date, percentage
)
# meteor_showers에 존재하는 별자리만 사용
selected_constellations <- data.frame()
for (row in seq_len(nrow(constellations))) {
    ifelse(
        constellations[row, ]$constellation %in% meteor_showers$radiant,
        selected_constellations <- rbind(selected_constellations, constellations[row, ]),
        next
    )
}
str(selected_constellations)
str(moon_phases_2023)
str(meteor_showers)
# 해당 국가에서 볼 수 있는 별자리 리스트 가져오기
getConstellationList <- function(country) {
    latitude <- cities[cities$Country == country, "Latitude"]
    constellation_list <- selected_constellations[
        which(selected_constellations$latitudestart >= latitude & selected_constellations$latitudeend <= latitude),
        "constellation"
    ]
    return(constellation_list)
}

best_moon_dates <- data.frame(
    country = character(),
    meteor_shower = character(),
    constellation = character(),
    date = character()
)

for (country in cities$Country) {
    temp_list <- getConstellationList(country)
    for (constellation in temp_list) {
        # 별자리에 해당하는 유성우 리스트
        meteor_shower_names <- meteor_showers[meteor_showers$radiant == constellation, "name"]
        best_moon_temp <- data.frame(
            country = character(),
            meteor_shower = character(),
            constellation = character(),
            date = character()
        )
        for (meteor_shower_name in meteor_shower_names) {
            # 유성우 이름에 해당하는 row를 가져온다.
            meteor_shower <- meteor_showers[meteor_showers$name == meteor_shower_name, ]
            meteor_shower_startdate <- meteor_shower$startDate
            meteor_shower_enddate <- meteor_shower$endDate
            # 유성우의 peakdate에 해당하는 달의 밝기(주기)를 가져온다
            moon_phases_peakdate <- moon_phases_2023[
                meteor_shower$peakDate == moon_phases_2023$date, "percentage"
            ]
            # 유성우 기간 동안의 달의 주기를 가져온다
            moon_phases_list <- moon_phases_2023[
                moon_phases_2023$date >= meteor_shower_startdate &
                    moon_phases_2023$date <= meteor_shower_enddate,
            ]
            # 유성우 기간 동안 달이 제일 어두운 때를 저장
            best_moon_date <- moon_phases_list[which.min(moon_phases_list$percentage), "date"]
            # 만약 유성우 peakdate의 밝기가 0.5 이하라면 peakdate를 사용한다
            if (moon_phases_peakdate <= 0.5) {
                best_moon_date <- meteor_shower$peakDate
            }
            best_moon_temp <- rbind(
                best_moon_temp,
                data.frame(
                    country = country,
                    meteor_shower = meteor_shower_name,
                    constellation = constellation,
                    date = best_moon_date
                )
            )
        }
        best_moon_dates <- rbind(
            best_moon_dates,
            best_moon_temp
        )
    }
    # file_name <- paste0("constellation_", country, ".xlsx")
    # write.xlsx2(best_moon_temp, file_name)
}

str(best_moon_dates)

View(best_moon_dates)

best_moon_dates$date <- as.character(best_moon_dates$date)

file_name_all <- "constellation_Result.xlsx"
write.xlsx2(best_moon_dates, file_name_all)
