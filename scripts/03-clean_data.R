#### Preamble ####
# Purpose: 
# Author: Sophia Brothers
# Date: 
# Contact: 
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed?
 
library(tidyverse)
library(here)

data <- read_csv(here::here("data/raw_data/president_polls.csv"))
print(head(data))
cleaned_data <- tryCatch({
  data %>%
    select(
      poll_id,
      pollster_id,
      pollster,
      party,
      sponsors,
      numeric_grade,
      pollscore,
      methodology,
      state,
      start_date,
      end_date,
      sample_size,
      population,
      election_date,
      stage,
      candidate_name,
      pct
    ) %>%
  
    rename(
      Pollster = pollster,
      Party = party,
      NumericGrade = numeric_grade,
      PollScore = pollscore,
      Methodology = methodology,
      State = state,
      StartDate = start_date,
      EndDate = end_date,
      SampleSize = sample_size,
      Population = population,
      ElectionDate = election_date,
      Stage = stage,
      CandidateName = candidate_name,
      Percentage = pct
    ) %>%
  
    mutate(
      # Specify the format of the date for proper parsing
      StartDate = mdy(StartDate),  # Use mdy() for MM/DD/YYYY format
      EndDate = mdy(EndDate),      # Same here
      ElectionDate = mdy(ElectionDate)  # And here
    ) %>%
    
    filter(!is.na(StartDate), !is.na(EndDate), !is.na(ElectionDate)) %>%
    group_by(State, StartDate, Pollster) %>%
    mutate(
      CandidateName = ifelse(CandidateName == "Joe Biden", 
                             "Kamala Harris", CandidateName)
    ) %>%
    ungroup()
    }, 
  error = function(e) {
  message("An error occurred during data cleaning: ", e)
  NULL
})

if (!is.null(cleaned_data)) {
  write_csv(cleaned_data, here::here("data/analysis_data/president_polls_cleaned.csv"))
  
  print(head(cleaned_data))
} else {
  message("Cleaned data not available for saving due to an error.")
}