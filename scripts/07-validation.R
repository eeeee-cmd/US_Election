#### Preamble ####
# Purpose: Validate the regression models through out of sample testing and RMSE
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, 'caret', and 'here' packages must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj


# load libraries
library(tidyverse)
library(here)
library(caret)

# load data
cleaned_data <- read_parquet(here::here("data/analysis_data/president_polls_cleaned.parquet"))

# data processing
cleaned_data <- cleaned_data %>%
  mutate(
    CandidateName = as.factor(CandidateName),
    State = as.factor(State),
    Pollster = as.factor(Pollster),
    StartDate = as.Date(StartDate),
    EndDate = as.Date(EndDate),
    Party = as.factor(Party),
    Methodology = as.factor(Methodology),
    NumericGrade = as.numeric(NumericGrade),
    SampleSize = as.numeric(SampleSize)
  ) %>%
  mutate(PollRecency = as.numeric(Sys.Date() - StartDate)) %>%
  filter(CandidateName %in% c("Donald Trump", "Kamala Harris"))

# split the data into training (70%) and testing (30%) sets
set.seed(123) # Set seed for reproducibility
train_index <- createDataPartition(cleaned_data$CandidateName, p = 0.7, list = FALSE)
train_data <- cleaned_data[train_index, ]
test_data <- cleaned_data[-train_index, ]

# fit linear regression models on the training set
lm_model_trump <- lm(Percentage ~ PollScore + SampleSize + NumericGrade + PollRecency + State,
  data = train_data %>% filter(CandidateName == "Donald Trump")
)

lm_model_harris <- lm(Percentage ~ PollScore + SampleSize + NumericGrade + PollRecency + State,
  data = train_data %>% filter(CandidateName == "Kamala Harris")
)

# make predictions on the testing set for each model
predictions_trump <- predict(lm_model_trump, newdata = test_data %>% filter(CandidateName == "Donald Trump"))
predictions_harris <- predict(lm_model_harris, newdata = test_data %>% filter(CandidateName == "Kamala Harris"))

# extract actual values for RMSE calculation
actual_trump <- test_data$Percentage[test_data$CandidateName == "Donald Trump"]
actual_harris <- test_data$Percentage[test_data$CandidateName == "Kamala Harris"]

# calculate RMSE for each model
rmse_trump <- sqrt(mean((actual_trump - predictions_trump)^2, na.rm = TRUE))
rmse_harris <- sqrt(mean((actual_harris - predictions_harris)^2, na.rm = TRUE))

# tibble to store RMSE results
rmse_results <- tibble(
  Model = c("Donald Trump", "Kamala Harris"),
  RMSE = c(rmse_trump, rmse_harris)
)

write_parquet(rmse_results, here::here("data/analysis_data/rmse_results.parquet"))
