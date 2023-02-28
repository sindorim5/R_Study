library(tidyverse)
library(rstudioapi)

# setwd(dirname(rstudioapi::getSourceEditorContext()$path))
# getwd()

ace_epam_1h <- read.csv(
    file = "C:/Users/multicampus/Desktop/AuroraData/ace_epam_1h.csv",
    fileEncoding = "UTF-8",
    na.strings = c("", " ", "NA", NA)
)

ace_loc_1h <- read.csv(
    file = "C:/Users/multicampus/Desktop/AuroraData/ace_loc_1h.csv",
    fileEncoding = "UTF-8",
    na.strings = c("", " ", "NA", NA)
)

ace_mag_1h <- read.csv(
    file = "C:/Users/multicampus/Desktop/AuroraData/ace_mag_1h.csv",
    fileEncoding = "UTF-8",
    na.strings = c("", " ", "NA", NA)
)

ace_sis_1h <- read.csv(
    file = "C:/Users/multicampus/Desktop/AuroraData/ace_sis_1h.csv",
    fileEncoding = "UTF-8",
    na.strings = c("", " ", "NA", NA)
)

ace_swepam_1h <- read.csv(
    file = "C:/Users/multicampus/Desktop/AuroraData/ace_swepam_1h.csv",
    fileEncoding = "UTF-8",
    na.strings = c("", " ", "NA", NA)
)

kp_ap_data <- read.csv(
    file = "C:/Users/multicampus/Desktop/AuroraData/kp_ap_data.csv",
    fileEncoding = "UTF-8",
    na.strings = c("", " ", "NA", NA)
)

summary(ace_epam_1h)
summary(ace_loc_1h)
summary(ace_mag_1h)
summary(ace_sis_1h)
summary(ace_swepam_1h)
summary(kp_ap_data)


dim(all)
dim(ace_mag_1h)

summary(all)
summary(ace_mag_1h)


nrow(ace_epam_1h)
nrow(ace_loc_1h)
nrow(ace_mag_1h)
nrow(ace_sis_1h)
nrow(ace_swepam_1h)

ace_epam_1h <- ace_epam_1h %>% rename("P_1060_1910" = "P_060_1910")
ace_loc_1h <- ace_loc_1h %>% rename("YEAR" = "X")


all <- left_join(
    ace_epam_1h,
    ace_loc_1h,
    by = c("YEAR", "MONTH", "DAY", "TIME")
)

all <- left_join(
    all,
    ace_mag_1h,
    by = c("YEAR", "MONTH", "DAY", "TIME")
)

all <- left_join(
    all,
    ace_sis_1h,
    by = c("YEAR", "MONTH", "DAY", "TIME")
)

all <- left_join(
    all,
    ace_swepam_1h,
    by = c("YEAR", "MONTH", "DAY", "TIME")
)

kp_ap_data <- kp_ap_data %>% rename("TIME" = "START_TIME")

all <- left_join(
    all,
    kp_ap_data,
    by = c("YEAR", "MONTH", "DAY", "TIME")
)

str(all)
