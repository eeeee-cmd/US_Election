#### Preamble ####
# Purpose: Run a linear regression model to predict the electoral college
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and 'here' packages must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj

# load libraries
library(tidyverse)
library(here)
library(arrow)

# convert some columns to the appropriate data types
cleaned_data <- read_parquet(here::here("data/analysis_data/president_polls_cleaned.parquet"))
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
  )

# create a new variable called PollRecency
# PollRecency measures how recently the poll was conducted (based on start date)
cleaned_data <- cleaned_data %>%
  mutate(PollRecency = as.numeric(Sys.Date() - StartDate))

# only consider polls for Trump or Harris
cleaned_data <- cleaned_data %>%
  filter(CandidateName %in% c("Donald Trump", "Kamala Harris")) %>%
  select(State, PollScore, SampleSize, NumericGrade, PollRecency, Percentage, CandidateName)

# linear model for Donald Trump's poll percentage based on various predictors
lm_model_trump <- lm(Percentage ~ PollScore + SampleSize + NumericGrade + PollRecency + State,
                     data = cleaned_data %>% filter(CandidateName == "Donald Trump")
)

# linear model for Kamala Harris' poll percentage based on various predictors
lm_model_harris <- lm(Percentage ~ PollScore + SampleSize + NumericGrade + PollRecency + State,
                      data = cleaned_data %>% filter(CandidateName == "Kamala Harris")
)

# save modified data for the model as a CSV + Parquet and save models as RDS
write_csv(cleaned_data, here::here("data/analysis_data/electoral_data.csv"))
write_parquet(cleaned_data, here::here("data/analysis_data/electoral_data.parquet"))
saveRDS(lm_model_trump, here::here("models/lm_model_trump.rds"))
saveRDS(lm_model_harris, here::here("models/lm_model_harris.rds"))
