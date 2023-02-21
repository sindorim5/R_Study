# 엑셀 파일 가져오기(p.344)
library(readxl)
entrance_xls<- read_excel("C:/Rstudy/entrance_exam.xls")

str(entrance_xls)
head(entrance_xls)


# 컬럼명 변경과 띄어쓰기 제거하기(p.345)
colnames(entrance_xls) <- c("country", "JAN", "FEB", "MAR", "APR", "MAY",
                            "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")

entrance_xls$country <- gsub(" ", "", entrance_xls$country)
entrance_xls


# 1월 기준 상위 5개국 추출하기(p.347)
entrance_xls |> nrow()
top5_country <- entrance_xls[order(-entrance_xls$JAN),] |> head(n = 5)
top5_country


# 데이터 구조 재구조화하기(p.348)
library(reshape2)
top5_melt <- melt(top5_country, id.vars = 'country', variable.name = 'mon')
head(top5_melt)


# 선 그래프 그리기(p.349)
library(ggplot2)

ggplot(top5_melt, aes(x = mon, y = value, group = country)) +
  geom_line(aes(color = country))


# 그래프 제목 지정하고 y축 범위 조정하기(p.350)
ggplot(top5_melt, aes(x = mon, y = value, group = country)) +
  geom_line(aes(color = country)) +
  ggtitle("2020년 국적별 입국 수 변화 추이") +
  scale_y_continuous(breaks = seq(0, 500000, 50000))


# 막대 그래프 그리기(p.351)
ggplot(top5_melt, aes(x = mon, y = value, fill = country)) +
  geom_bar(stat = "identity", position = "dodge")


# 누적 막대 그래프 그리기(p.352)
ggplot(top5_melt, aes(x = mon, y = value, fill = country)) +
  geom_bar(stat = "identity", position = "stack")
