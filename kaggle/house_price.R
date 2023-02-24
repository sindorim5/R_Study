train <-
    read.csv(
        "./data/house_prices/train.csv",
        na.strings = c("", "na", "NA"),
        stringsAsFactors = TRUE,
        header = TRUE
    )
test <-
    read.csv(
        "./data/house_prices/test.csv",
        na.strings = c("", "na", "NA"),
        stringsAsFactors = TRUE,
        header = TRUE
    )

str(train)
str(test)

test$SalePrice <- NA
all <- rbind(train, test)
str(all)


# 데이터 전처리
library(dplyr)

sapply(all, function(x) {
    sum(is.na(x))
})

## MSZoning
all[is.na(all$MSZoning), "MSZoning"] <- as.factor("RL")
summary(all$MSZoning)

## LotFrontage
LotFrontage.median <- median(all$LotFrontage, na.rm = TRUE)
all[is.na(all$LotFrontage), "LotFrontage"] <- LotFrontage.median

## Alley는 제외하자

## Utilities
summary(all$Utilities)
all[is.na(all$Utilities), "Utilities"] <- as.factor("AllPub")

## Exterior1st
summary(all$Exterior1st)
all[is.na(all$Exterior1st), "Exterior1st"] <- as.factor("VinylSd")

## Exterior2nd
summary(all$Exterior2nd)
all[is.na(all$Exterior2nd), "Exterior2nd"] <- as.factor("VinylSd")

## MasVnrType
summary(all$MasVnrType)
all[is.na(all$MasVnrType), "MasVnrType"] <- as.factor("None")

## MasVnrArea
summary(all$MasVnrArea)
temp <- subset(all, MasVnrArea > 0)
nrow(temp)
MasVnrArea.median <- median(all$MasVnrArea, na.rm = TRUE)
all[is.na(all$MasVnrArea), "MasVnrArea"] <- MasVnrArea.median

## BsmtQual, factor로 가져와서 None으로 바꾸면 없는 요소라고 오류남
## char로 바꾸고 다시 넣을 것
summary(all$BsmtQual)
all$BsmtQual <- as.character(all$BsmtQual)
all[is.na(all$BsmtQual), "BsmtQual"] <- "None"
all$BsmtQual <- as.factor(all$BsmtQual)

## BsmtCond
summary(all$BsmtCond)
all$BsmtCond <- as.character(all$BsmtCond)
all[is.na(all$BsmtCond), "BsmtCond"] <- "None"
all$BsmtCond <- as.factor(all$BsmtCond)

## BsmtExposure
summary(all$BsmtExposure)
all$BsmtExposure <- as.character(all$BsmtExposure)
all[is.na(all$BsmtExposure), "BsmtExposure"] <- "None"
all$BsmtExposure <- as.factor(all$BsmtExposure)

## BsmtFinType1
summary(all$BsmtFinType1)
all$BsmtFinType1 <- as.character(all$BsmtFinType1)
all[is.na(all$BsmtFinType1), "BsmtFinType1"] <- "None"
all$BsmtFinType1 <- as.factor(all$BsmtFinType1)

## BsmtFinSF1
summary(all$BsmtFinSF1)
BsmtFinSF1.median <- median(all$BsmtFinSF1, na.rm = TRUE)
all[is.na(all$BsmtFinSF1), "BsmtFinSF1"] <- BsmtFinSF1.median

## BsmtFinType2
summary(all$BsmtFinType2)
all$BsmtFinType2 <- as.character(all$BsmtFinType2)
all[is.na(all$BsmtFinType2), "BsmtFinType2"] <- "None"
all$BsmtFinType2 <- as.factor(all$BsmtFinType2)

## BsmtFinSF2
summary(all$BsmtFinSF2)
all[is.na(all$BsmtFinSF2), "BsmtFinSF2"] <- 0

## BsmtUnfSF
summary(all$BsmtUnfSF)
all[is.na(all$BsmtUnfSF), "BsmtUnfSF"] <- 0

## TotalBsmtSF
summary(all$TotalBsmtSF)
all[is.na(all$TotalBsmtSF), "TotalBsmtSF"] <- 0

## Electrical
summary(all$Electrical)
all[is.na(all$Electrical), "Electrical"] <- "SBrkr"

## BsmtFullBath
summary(all$BsmtFullBath)
all[is.na(all$BsmtFullBath), "BsmtFullBath"] <- 0

## BsmtHalfBath
summary(all$BsmtHalfBath)
all[is.na(all$BsmtHalfBath), "BsmtHalfBath"] <- 0

## KitchenQual
summary(all$KitchenQual)
all[is.na(all$KitchenQual), "KitchenQual"] <- "TA"
View(all %>% select(KitchenQual))

## Functional
###################
