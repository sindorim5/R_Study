# 엑셀 파일 가져오기(p.331)
library(readxl)
forest_example_data <- read_excel("C:/Rstudy/forest_example_data.xls")
colnames(forest_example_data) <- c("name","city","gubun","area",
                                   "number","stay","city_new",
                                   "code","codename")

str(forest_example_data)
head(forest_example_data)


# freq() 함수로 시도별 휴양림 빈도분석하기(p.333)
library(descr)
freq(forest_example_data$city, plot = T, main = 'city')


# table() 함수로 시도별 휴양림 빈도분석하기(p.334)
city_table <- table(forest_example_data$city)
city_table
barplot(city_table)


# count() 함수로 시도별 휴양림 빈도분석하고 내림차순 정렬하기(p.335)
library(dplyr)
count(forest_example_data, city) %>% arrange(desc(n))


# 소재지_시도명 컬럼으로 시도별 분포 확인하기(p.336)
count(forest_example_data, city_new) %>% arrange(desc(n))


# 제공기관명 컬럼으로 시도별 분포 확인하기(p.337)
count(forest_example_data, codename) %>% arrange(desc(n))