library(tidyverse)
library(here)

cleaned_data <- read_csv(here::here("data/analysis_data/president_polls_cleaned.csv"))
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

cleaned_data <- cleaned_data %>%
  mutate(PollRecency = as.numeric(Sys.Date() - StartDate))

cleaned_data <- cleaned_data %>%
  filter(CandidateName %in% c("Donald Trump", "Kamala Harris")) %>%
  select(State, PollScore, SampleSize, NumericGrade, PollRecency, Percentage, CandidateName)

lm_model_trump <- lm(Percentage ~ PollScore + SampleSize + NumericGrade + PollRecency + State, 
                     data = cleaned_data %>% filter(CandidateName == "Donald Trump"))

lm_model_harris <- lm(Percentage ~ PollScore + SampleSize + NumericGrade + PollRecency + State, 
                      data = cleaned_data %>% filter(CandidateName == "Kamala Harris"))

write_csv(cleaned_data, here::here("data/analysis_data/electoral_data.csv"))
saveRDS(lm_model_trump, here::here("models/lm_model_trump.rds"))
saveRDS(lm_model_harris, here::here("models/lm_model_harris.rds"))