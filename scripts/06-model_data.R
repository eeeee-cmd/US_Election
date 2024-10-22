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
 filter(CandidateName %in% c("Donald Trump", "Kamala Harris"))

lm_model <- lm(Percentage ~ PollScore + SampleSize + NumericGrade + State + PollRecency + CandidateName, 
               data = cleaned_data)

summary(lm_model)

write_csv(cleaned_data, here::here("data/analysis_data/model_data.csv"))
saveRDS(lm_model, here::here("models/lm_model.rds"))
