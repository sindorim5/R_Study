install.packages("xml2", repos = "http://cran.us.r-project.org")
install.packages("XML", repos = "http://cran.us.r-project.org")

library(tidyverse)
library(dplyr)
library(xml2)
library(XML)
library(methods)

meteor_showers <- xmlToDataFrame("meteor_shower/real_data/IMO_Working_Meteor_Shower_List.xml")

str(meteor_showers)
