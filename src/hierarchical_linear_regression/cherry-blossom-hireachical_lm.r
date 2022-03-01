### Washingtondc Cherry Blosoom Peak Date Prediction
# Navigate Working Place
setwd("C:\\Users\\cjeng\\OneDrive\\Desktop\\CherryBlossom")

## Library
library(tidyverse)
library("PerformanceAnalytics")
library(stringr)
library(readr)
library(dplyr)
library(lmerTest)
library(skimr)
library(moderndive) # get_regression_table
options(scipen = 999) 
## Function
doy_to_date <- function (year, doy) {
  strptime(paste(year, doy, sep = '-'), '%Y-%j') %>% # create date object
    strftime('%Y-%m-%d') # translate back to date string in ISO 8601 format
}

## Looading Data
washingtondc <- read.csv("data/washingtondc.csv")
kyoto <- read.csv("data/kyoto.csv")
liestal <- read.csv("data/liestal.csv")
new_data <- read.csv("data/AGDD_2022.csv")

# change column name if "read a UTF-8 text file with BOM"
colnames(washingtondc)[which(names(washingtondc) == "ï..location")] <- "location"  
colnames(kyoto)[which(names(kyoto) == "ï..location")] <- "location" 
colnames(liestal)[which(names(liestal) == "ï..location")] <- "location"

## Hierarchical Linear Regressions
# First Layer: Predict AGDD_Bloom on the bloom doy
ls_fit_AGDD_w <- lm(AGDD_Bloom ~ AGDD_Mar_13, data = washingtondc, subset = year >= 1979)
ls_fit_AGDD_k <- lm(AGDD_Bloom ~ AGDD_Mar_13, data = kyoto, subset = year >= 1979)
ls_fit_AGDD_l <- lm(AGDD_Bloom ~ AGDD_Mar_13, data = liestal, subset = year >= 1979)

# Second Layer: Predict bloom_doy
ls_fit_w <- lm(bloom_doy ~ AGDD_Bloom, data = washingtondc, subset = year >= 1979)
ls_fit_k <- lm(bloom_doy ~ AGDD_Bloom, data = kyoto, subset = year >= 1979)
ls_fit_l <- lm(bloom_doy ~ AGDD_Bloom, data = liestal, subset = year >= 1979)

### Model Evaluation
points_w <- get_regression_points(ls_fit_w)
MSE_sqrt_w =(sum(points$bloom_doy_hat - points$bloom_doy))^2
MSE_abs_w = abs(sum(points$bloom_doy_hat - points$bloom_doy))

### Adding AGDD on March 13 in 2022
x_new_w = new_data[1, 3]  # washington dc
AGDD_Bloom_2022_w <- ls_fit_AGDD_w$coefficients[1] + (ls_fit_AGDD_w$coefficients[2]*x_new_w) #  424.6752
AGDD_Bloom_2022_w
bloom_doy_2022_w <- ls_fit_w$coefficients[1] + (ls_fit_w$coefficients[2]* AGDD_Bloom_2022_w) #  91.22255
# doy_to_date(2022, bloom_doy_2022_w)# "2022-04-01"

x_new_k = new_data[2, 3] # 2022/3/13 ADGG  #Kyoto
AGDD_Bloom_2022_k <- ls_fit_AGDD_k$coefficients[1] + (ls_fit_AGDD_k$coefficients[2]*x_new_k)
bloom_doy_2022_k <- ls_fit_k$coefficients[1] + (ls_fit_k$coefficients[2]* AGDD_Bloom_2022_k[1]) # 91.95234
doy_to_date(2022, bloom_doy_2022_k)

x_new_l = new_data[3, 3] # 2022/3/13 ADGG  #Liestal
AGDD_Bloom_2022_l <- ls_fit_AGDD_l$coefficients[1] + (ls_fit_AGDD_l$coefficients[2]*x_new_l)
bloom_doy_2022_l <- ls_fit_l$coefficients[1] + (ls_fit_l$coefficients[2]* AGDD_Bloom_2022_l[1]) # 91.95234
doy_to_date(2022, bloom_doy_2022_l)

# visulaizing
library(ggplot2)
ggplot(washingtondc, aes(x = AGDD_Mar_13, y= AGDD_Bloom)) + geom_point() + geom_smooth(method = "lm") + labs(x = "AGDD_Mar_13", y = "AGDD_Bloom")
ggplot(washingtondc, aes(x = AGDD_Bloom, y= bloom_doy)) + geom_point() + geom_smooth(method = "lm") + labs(x = "AGDD", y = "Bloom Doy")

# ===================

##### Vancouver Prediction
cherry <- read.csv("data/washingtondc.csv") %>% 
  bind_rows(read.csv("data/liestal.csv")) %>% 
  bind_rows(read.csv("data/kyoto.csv"))
colnames(cherry)[which(names(cherry) == "ï..location")] <- "location"

# Model Fitted
ls_fit_AGDD_v <- lm(AGDD_Bloom ~ AGDD_Mar_13, data = cherry, subset = year >= 1979)
ls_fit_v <- lm(bloom_doy ~ AGDD_Bloom, data = cherry, subset = year >= 1979)
x_new_v = new_data[4, 3] # 2022/3/13 ADGG   420.7769
AGDD_Bloom_2022_v <- ls_fit_AGDD_v$coefficients[1] + (ls_fit_AGDD_v$coefficients[2]*x_new_v)
bloom_doy_2022_v <- ls_fit_v$coefficients[1] + (ls_fit_v$coefficients[2]* AGDD_Bloom_2022_v) #  95.88758  
doy_to_date(2022,bloom_doy_2022_v)# "2022-04-01"

# Predicting 2023 to 2031
set.seed(123)
new_w <- rnorm(9,mean = ls_fit_AGDD_w$coefficients[1], sd = sd(washingtondc$AGDD_Bloom))
new_k <- rnorm(9,mean = ls_fit_AGDD_k$coefficients[1], sd = sd(kyoto$AGDD_Bloom))
new_l <- rnorm(9,mean = ls_fit_AGDD_l$coefficients[1], sd = sd(liestal$AGDD_Bloom))
new_v <- rnorm(9,mean = ls_fit_AGDD_v$coefficients[1], sd = sd(cherry$AGDD_Bloom))

bloom_doy_w <- bloom_doy_2022_w
bloom_doy_k <- bloom_doy_2022_k
bloom_doy_l <- bloom_doy_2022_l
bloom_doy_v <- bloom_doy_2022_v
for (i in new_w){
  bloom_doy_w <- round(ls_fit_w$coefficients[1] + (ls_fit_w$coefficients[2]* new_w))
}
for (i in new_k){
  bloom_doy_k <- round(ls_fit_k$coefficients[1] + (ls_fit_k$coefficients[2]* new_k))
}
for (i in new_w){
  bloom_doy_l <- round(ls_fit_l$coefficients[1] + (ls_fit_l$coefficients[2]* new_l))
}
for (i in new_v){
  bloom_doy_v <- round(ls_fit_v$coefficients[1] + (ls_fit_v$coefficients[2]* new_v))
}

## Prepare Submission
list_2022 <- c(round(as.numeric(bloom_doy_2022_k)),
               round(as.numeric(bloom_doy_2022_l)), 
               round(as.numeric(bloom_doy_2022_w)), 
               round(as.numeric(bloom_doy_2022_v)))
df <- data.frame("kyoto" = bloom_doy_k,
                 "liestal" = bloom_doy_l,
                 "washingtondc" = bloom_doy_w,
                 "vancouver" = bloom_doy_v)
df[nrow(df) + 1,] <- list_2022 #add row
year <- c(2023:2031, 2022)
submission_predictions <- data.frame(year, df)
submission_predictions <- submission_predictions[order(year),]
submission_predictions <- as.list(submission_predictions)
write.csv(submission_predictions, "submission_predictions.csv")
