# meteor_showers 전처리 된 내용을 csv로 저장해서 다시 불러옴
meteor_showers <- read.csv(
    file = "meteor_shower/real_data/meteor_shower_crawl.CSV"
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
    name, radiant, startDate, endDate
)
moon_phases_2023 <- moon_phases_2023 %>% select(
    date, percentage
)

getConstellationList <- function(country) {
    latitude <- cities[cities$Country == country, "Latitude"]
    constellation_list <- constellations[
        which(constellations$latitudestart >= latitude & constellations$latitudeend <= latitude),
        "constellation"
    ]
    return(constellation_list)
}

for (country in cities$Country) {
    temp_list <- getConstellationList(country)
    best_moon_dates <- data.frame(
        country = character(),
        meteor_shower = character(),
        constellation = character(),
        date = character()
    )

    for (constellation in temp_list) {
        meteor_shower <- meteor_showers[meteor_showers$radiant == constellation, "name"][1]
        if (is.na(meteor_shower)) next
        meteor_shower_startdate <- meteor_showers[
            meteor_showers$radiant == constellation, "startdate"
        ][1]
        meteor_shower_enddate <- meteor_showers[
            meteor_showers$radiant == constellation, "enddate"
        ][1]
        moon_phases_list <- moon_phases_2023[
            moon_phases_2023$date >= meteor_shower_startdate & moon_phases_2023$date <= meteor_shower_enddate,
        ]
        best_moon_date <- moon_phases_list[which.min(moon_phases_list$percentage), "date"]
        best_moon_dates <- rbind(
            best_moon_dates,
            data.frame(
                country = country,
                meteor_shower = meteor_shower,
                constellation = constellation,
                date = best_moon_date
            )
        )
    }
    file_name <- paste0(constellation_, country, .xlsx)
    write.xlsx2(best_moon_dates, file_name)
}
