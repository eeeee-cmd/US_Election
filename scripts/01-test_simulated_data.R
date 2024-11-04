#### Preamble ####
# Purpose: This script reads in the simulated polling data, performs a series of validation tests
# to ensure the data structure, column names, and values are correct, and reports the results.
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse`, 'arrow', and `testthat` packages must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj

# load libraries
library(dplyr)
library(arrow)
library(testthat)

# read the simulated data
data <- read_parquet(here::here("data/simulated_data/simulated_data.parquet"))

# create list to store test results
test_results <- list()

# test if the data structure is correct
test_results$structure <- test_that("Data structure", {
  expect_true(is.data.frame(data), info = "poll_data is not a data frame.")
  expect_equal(ncol(data), 25, info = "poll_data does not have the correct number of columns.")
  expect_equal(nrow(data), 100, info = "poll_data does not have the correct number of rows.")
})

# test if the column names match the expected column names
test_results$column_names <- test_that("Column names", {
  expected_colnames <- c(
    "poll_id", "pollster_id", "pollster", "sponsor_ids",
    "sponsors", "pollster_rating_id", "numeric_grade",
    "pollscore", "methodology", "state",
    "start_date", "end_date", "sponsor_candidate",
    "sponsor_candidate_party", "endorsed_candidate_name",
    "endorsed_candidate_party", "sample_size",
    "population", "election_date", "stage",
    "candidate_name", "pct", "pollscore_pct_interaction",
    "sample_size_grade_interaction",
    "sample_size_methodology_interaction"
  )
  expect_equal(colnames(data), expected_colnames, info = "Column names do not match expected names.")
})

# test if the pollscore values are within the valid range (60 to 100)
test_results$pollscore_values <- test_that("Pollscore values", {
  expect_true(all(data$pollscore >= 60 & data$pollscore <= 100), info = "pollscore values are out of range (60 to 100).")
})

# test if the numeric grades are within the valid range (2 to 5)
test_results$numeric_grade <- test_that("Numeric grade values", {
  expect_true(all(data$numeric_grade >= 2 & data$numeric_grade <= 5), info = "numeric_grade values are out of range (2 to 5).")
})

# test if the sample sizes are within the valid range (500 to 2000)
test_results$sample_size <- test_that("Sample size values", {
  expect_true(all(data$sample_size >= 500 & data$sample_size <= 2000), info = "sample_size values are out of range (500 to 2000).")
})

# test if the start dates are logically before the end dates
test_results$date_logic <- test_that("Date logic", {
  expect_true(all(data$start_date < data$end_date), info = "Some start_dates are not before their corresponding end_dates.")
})

# test if the election dates are within the valid range (2024-11-01 to 2024-11-08)
test_results$election_date <- test_that("Election date range", {
  expect_true(all(data$election_date >= as.Date("2024-11-01") & data$election_date <= as.Date("2024-11-08")),
    info = "Some election_dates are out of range (2024-11-01 to 2024-11-08)."
  )
})

# test if the candidate parties are valid (only Party A, Party B, Party C are allowed)
test_results$candidate_parties <- test_that("Candidate parties", {
  candidate_parties <- c("Party A", "Party B", "Party C")
  expect_true(all(data$sponsor_candidate_party %in% candidate_parties), info = "Some sponsor_candidate_party values are invalid.")
  expect_true(all(data$endorsed_candidate_party %in% candidate_parties), info = "Some endorsed_candidate_party values are invalid.")
})

# print the test results
print(test_results)
