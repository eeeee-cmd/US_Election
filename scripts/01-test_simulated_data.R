#### Preamble ####
# Purpose: 
# Author: Sophia Brothers
# Date: 
# Contact: 
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed?

library(dplyr)
library(purrr)

data <- read_csv(here::here("data/simulated_data/simulated_data.csv"))

test_results <- list()

test_structure <- function(data) {
  if (!is.data.frame(data)) {
    return("poll_data is not a data frame.")
  }
  if (ncol(data) != 22) {
    return("poll_data does not have the correct number of columns.")
  }
  if (nrow(data) != 100) {
    return("poll_data does not have the correct number of rows.")
  }
  return("Structure test passed.")
}

test_column_names <- function(data) {
  expected_colnames <- c("poll_id", "pollster_id", "pollster", "sponsor_ids", 
                         "sponsors", "pollster_rating_id", "numeric_grade", 
                         "pollscore", "methodology", "state", 
                         "start_date", "end_date", "sponsor_candidate", 
                         "sponsor_candidate_party", "endorsed_candidate_name", 
                         "endorsed_candidate_party", "sample_size", 
                         "population", "election_date", "stage", 
                         "candidate_name", "pct")
  if (!all(colnames(data) == expected_colnames)) {
    return("Column names do not match expected names.")
  }
  return("Column names test passed.")
}

test_pollscore_values <- function(data) {
  if (any(data$pollscore < 60 | data$pollscore > 100)) {
    return("pollscore values are out of range (60 to 100).")
  }
  return("Pollscore test passed.")
}

test_numeric_grade <- function(data) {
  if (any(data$numeric_grade < 2 | data$numeric_grade > 5)) {
    return("numeric_grade values are out of range (2 to 5).")
  }
  return("Numeric grade test passed.")
}

test_sample_size <- function(data) {
  if (any(data$sample_size < 500 | data$sample_size > 2000)) {
    return("sample_size values are out of range (500 to 2000).")
  }
  return("Sample size test passed.")
}

test_date_logic <- function(data) {
  if (any(data$start_date >= data$end_date)) {
    return("Some start_dates are not before their corresponding end_dates.")
  }
  return("Date logic test passed.")
}

test_election_date <- function(data) {
  if (any(data$election_date < as.Date('2024-11-01') | 
          data$election_date > as.Date('2024-11-08'))) {
    return("Some election_dates are out of range (2024-11-01 to 2024-11-08).")
  }
  return("Election date test passed.")
}

test_candidate_parties <- function(data) {
  candidate_parties <- c("Party A", "Party B", "Party C")
  if (any(!data$sponsor_candidate_party %in% candidate_parties) || 
      any(!data$endorsed_candidate_party %in% candidate_parties)) {
    return("Some candidate parties are invalid.")
  }
  return("Candidate parties test passed.")
}

test_results %>% 
  map(~ ifelse(.x, "passed", "failed")) %>% 
  print()

if (all(unlist(test_results))){
  message("All tests passed!")
} else {
  message("Some tests failed. Check the individual test results above.")
}