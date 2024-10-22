#### Preamble ####
# Purpose: This script performs a series of validation tests on cleaned presidential polling data.
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

# define list of tests
tests <- list(
  # test structure of data
  structure_test = function(data) {
    if (!inherits(data, "tbl_df")) {
      stop("Structure test failed: Data is not a tibble.")
    }
    if (ncol(data) == 0) {
      stop("Structure test failed: Data has no columns.")
    }
    if (nrow(data) == 0) {
      stop("Structure test failed: Data has no rows.")
    }
    cat("Structure test passed.\n")
  },
  # test if column names match expected names
  column_names_test = function(data) {
    expected_colnames <- c(
      "poll_id", "pollster_id", "Pollster", "Party", "sponsors",
      "NumericGrade", "PollScore", "Methodology",
      "State", "StartDate", "EndDate",
      "SampleSize", "Population", "ElectionDate",
      "Stage", "CandidateName", "Percentage"
    )

    if (!all(names(data) == expected_colnames)) {
      stop("Column names test failed: Column names do not match expected names.")
    }
    cat("Column names test passed.\n")
  },
  # test if certain columns contain NA values
  na_values_test = function(data) {
    if (any(is.na(data$Percentage))) {
      stop("NA values test failed: Percentage contains NA values.")
    }
    if (any(is.na(data$CandidateName))) {
      stop("NA values test failed: CandidateName contains NA values.")
    }
    cat("NA values test passed.\n")
  },
  # test if any numeric grades or pollscores are out of expected range
  numeric_grade_pollscore_test = function(data) {
    if (any(data$NumericGrade < 0 | data$NumericGrade > 3, na.rm = TRUE)) {
      stop("Numeric grade test failed: NumericGrade is out of expected range.")
    }
    if (any(data$PollScore < -2 | data$PollScore > 2, na.rm = TRUE)) {
      stop("Pollscore test failed: PollScore is out of expected range.")
    }
    cat("Numeric grade and pollscore test passed.\n")
  },
  # test if sample size is out of expected range
  sample_size_test = function(data) {
    if (any(data$SampleSize < 100 | data$SampleSize > 30000, na.rm = TRUE)) {
      stop("Sample size test failed: sample_size is out of expected range.")
    }
    cat("Sample size test passed.\n")
  },
  # test if start date is before end date
  date_logic_test = function(data) {
    if (any(data$StartDate > data$EndDate, na.rm = TRUE)) {
      stop("Date logic test failed: StartDate is not before EndDate")
    }
    cat("Date logic test passed.\n")
  },
  # test if election date is within range
  election_date_test = function(data) {
    if (any(data$ElectionDate < as.Date("2024-11-01") | data$ElectionDate > as.Date("2024-11-08"))) {
      stop("Election date test failed: ElectionDate is out of expected range.")
    }
    cat("Election date test passed.\n")
  }
)

run_tests <- function(data) {
  walk(tests, ~ .x(data))
  cat("All tests completed successfully!\n")
}

run_tests(cleaned_data)
