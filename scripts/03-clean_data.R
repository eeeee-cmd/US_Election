#### Preamble ####
# Purpose: This script reads and cleans raw presidential polling data,
# performing various transformations, and outputs the cleaned data to a CSV file.
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and 'here' package must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj

# load libraries
library(tidyverse)
library(here)

# read data
data <- read_csv(here::here("data/raw_data/president_polls.csv"))

# Data cleaning by renaming and selecting specific columns, date formatting,
# filtering invalid entries, attributing polls for Joe Biden to Kamala Harris
cleaned_data <- tryCatch(
  {
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
        StartDate = mdy(StartDate), # Use mdy() for MM/DD/YYYY format
        EndDate = mdy(EndDate), # Same here
        ElectionDate = mdy(ElectionDate) # And here
      ) %>%
      filter(!is.na(StartDate), !is.na(EndDate), !is.na(ElectionDate)) %>%
      group_by(State, StartDate, Pollster) %>%
      mutate(
        CandidateName = ifelse(CandidateName == "Joe Biden",
          "Kamala Harris", CandidateName
        )
      ) %>%
      ungroup()
  }, # error handling to mitigate any cleaning issues
  error = function(e) {
    message("An error occurred during data cleaning: ", e)
    NULL
  }
)

# save cleaned data as new csv if successful, print error if not
if (!is.null(cleaned_data)) {
  write_csv(cleaned_data, here::here("data/analysis_data/president_polls_cleaned.csv"))

  print(head(cleaned_data))
} else {
  message("Cleaned data not available for saving due to an error.")
}
