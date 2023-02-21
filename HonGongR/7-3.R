# 엑셀 파일 가져오기(p.359)
library(readxl)
xlsdata <- read_excel("C:/Rstudy/선별진료소_20211125194459.xls")
View(xlsdata)


# 데이터 컬럼 추출 및 열 이름 변경하기(p.360)
data_raw <- xlsdata[,c(2:5)]
head(data_raw)

names(data_raw)
names(data_raw) <- c("state","city","name","addr")
names(data_raw)


# state 컬럼 빈도 확인하기(p.361)
table(data_raw$state)
barplot(table(data_raw$state))


# 대전시 선별진료소 데이터 추출하기(p.362)
daejeon_data <- data_raw[data_raw$state == "대전",]
head(daejeon_data)

nrow(daejeon_data)


# 데이터 세트에서 선별진료소 위도와 경도 데이터 가져오기(p.363)
library(ggmap)
ggmap_key <- "사용자 API 키를 입력하세요."
register_google(ggmap_key)
daejeon_data <- mutate_geocode(data = daejeon_data, location = addr,
                               source = 'google')

head(daejeon_data)
head(daejeon_data$lon)


# 대전시 지도 시각화하기(p.365)
daejeon_map <- get_googlemap('대전', maptype = 'roadmap', zoom = 11)
ggmap(daejeon_map) +
  geom_point(data = daejeon_data,
             aes(x = lon, y = lat, color = factor(name)), size = 3)


# 마커로 위치 표시하고 위치 이름 넣기(p.366)
daejeon_data_marker <- data.frame(daejeon_data$lon, daejeon_data$lat)
daejeon_map <- get_googlemap('대전', maptype = 'roadmap',
                             zoom = 11, markers = daejeon_data_marker)
ggmap(daejeon_map) +
  geom_text(data = daejeon_data, aes(x = lon, y = lat),
            size = 3, label = daejeon_data$name)

