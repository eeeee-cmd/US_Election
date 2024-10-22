#### Preamble ####
# Purpose: Run a linear regression model on president polls data
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, 'here', and 'arrow' packages must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj

# load libraries
library(tidyverse)
library(here)
library(arrow)

# load data
cleaned_data <- read_parquet(here::here("data/analysis_data/president_polls_cleaned.parquet"))

# convert some columns to the appropriate data types
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
  filter(CandidateName %in% c("Donald Trump", "Kamala Harris"))

# linear regression model that predicts support percentages
lm_model <- lm(
  Percentage ~ PollScore + SampleSize + NumericGrade + State +
    PollRecency + CandidateName,
  data = cleaned_data
)

# summary of model
summary(lm_model)

# save modified data for the model as a CSV + Parquet and save model as RDS
write_csv(cleaned_data, here::here("data/analysis_data/model_data.csv"))
write_parquet(cleaned_data, here::here("data/analysis_data/model_data.parquet"))
saveRDS(lm_model, here::here("models/lm_model.rds"))
