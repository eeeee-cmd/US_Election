#### Preamble ####
# Purpose: This script reads in the simulated polling data, performs a series of validation tests
# to ensure the data structure, column names, and values are correct, and reports the results.
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and 'arrow' packages must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj

# load libraries
library(dplyr)
library(purrr)
library(arrow)

# read the simulated data
data <- read_parquet(here::here("data/simulated_data/simulated_data.parquet"))

# initialize an empty list to store the results of each test (pass/fail)
test_results <- list()

# test if the data structure is correct
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

# test if the column names match the expected column names
test_column_names <- function(data) {
  expected_colnames <- c(
    "poll_id", "pollster_id", "pollster", "sponsor_ids",
    "sponsors", "pollster_rating_id", "numeric_grade",
    "pollscore", "methodology", "state",
    "start_date", "end_date", "sponsor_candidate",
    "sponsor_candidate_party", "endorsed_candidate_name",
    "endorsed_candidate_party", "sample_size",
    "population", "election_date", "stage",
    "candidate_name", "pct"
  )
  if (!all(colnames(data) == expected_colnames)) {
    return("Column names do not match expected names.")
  }
  return("Column names test passed.")
}

# test if the pollscore values are within the valid range (60 to 100)
test_pollscore_values <- function(data) {
  if (any(data$pollscore < 60 | data$pollscore > 100)) {
    return("pollscore values are out of range (60 to 100).")
  }
  return("Pollscore test passed.")
}

# test if the numeric grades are within the valid range (2 to 5)
test_numeric_grade <- function(data) {
  if (any(data$numeric_grade < 2 | data$numeric_grade > 5)) {
    return("numeric_grade values are out of range (2 to 5).")
  }
  return("Numeric grade test passed.")
}

# test if the sample sizes are within the valid range (500 to 2000)
test_sample_size <- function(data) {
  if (any(data$sample_size < 500 | data$sample_size > 2000)) {
    return("sample_size values are out of range (500 to 2000).")
  }
  return("Sample size test passed.")
}

# test if the start dates are logically before the end dates
test_date_logic <- function(data) {
  if (any(data$start_date >= data$end_date)) {
    return("Some start_dates are not before their corresponding end_dates.")
  }
  return("Date logic test passed.")
}

# test if the election dates are within the valid range (2024-11-01 to 2024-11-08)
test_election_date <- function(data) {
  if (any(data$election_date < as.Date("2024-11-01") |
    data$election_date > as.Date("2024-11-08"))) {
    return("Some election_dates are out of range (2024-11-01 to 2024-11-08).")
  }
  return("Election date test passed.")
}

# test if the candidate parties are valid (only Party A, Party B, Party C are allowed)
test_candidate_parties <- function(data) {
  candidate_parties <- c("Party A", "Party B", "Party C")
  if (any(!data$sponsor_candidate_party %in% candidate_parties) ||
    any(!data$endorsed_candidate_party %in% candidate_parties)) {
    return("Some candidate parties are invalid.")
  }
  return("Candidate parties test passed.")
}

# Use purrr::map to apply each test and store whether each test passed or failed
test_results %>%
  map(~ ifelse(.x, "passed", "failed")) %>%
  print()

# If all tests pass, print a success message. Otherwise, print a failure message.
if (all(unlist(test_results))) {
  message("All tests passed!")
} else {
  message("Some tests failed. Check the individual test results above.")
}
