library(dplyr)

# aurora_regulated를 시간별로 sort
all <- read.csv(
    # file = "~/Desktop/AuroraData/aurora_complete.csv",
    # file = "C:/Users/SONG/Documents/R_Study/aurora_regulated.csv",
    file = "C:/Users/multicampus/Documents/R_Study/aurora_regulated.csv",
    fileEncoding = "UTF-8",
    na.strings = c("", " ", "NA", NA)
)

# YEAR, MONTH, DAY, TIME을 POSIX형으로
all_orderby_year <- all %>% arrange(YEAR, MONTH)
temp <- all_orderby_year
temp$dateTime <- paste(temp$YEAR,
    paste(ifelse(
        temp$MONTH < 10,
        paste("0", temp$MONTH, sep = ""),
        temp$MONTH
    )),
    paste(ifelse(
        temp$DAY < 10,
        paste("0", temp$DAY, sep = ""),
        temp$DAY
    )),
    sep = "-"
)
temp$mTIME <- paste(ifelse(
    temp$TIME %/% 100 < 10,
    paste("0", temp$TIME %/% 100, sep = ""),
    temp$TIME %/% 100
), "00", sep = ":")
temp$REAL_TIME <- paste(temp$dateTime, temp$mTIME, sep = " ")
temp$DATE <- strptime(temp$REAL_TIME, "%Y-%m-%d %H:%M", tz = "UTC")
all_orderby_year$DATE <- temp$DATE

all_orderby_year <- all_orderby_year %>% relocate(c("DATE"))

all_orderby_year <- all_orderby_year %>% select(-YEAR, -MONTH, -DAY, -TIME)

saveRDS(
    all_orderby_year,
    file = "all_orderby_year.rds"
)
