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

cleaned_data <- read_csv(here::here("data/analysis_data/president_polls_cleaned.csv"))

tests <- list(
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
  
  column_names_test = function(data) {
    expected_colnames <- c("poll_id", "pollster_id", "Pollster", "Party", "sponsors", 
                           "NumericGrade", "PollScore", "Methodology", 
                           "State", "StartDate", "EndDate", 
                           "SampleSize", "Population", "ElectionDate", 
                           "Stage", "CandidateName", "Percentage")
    
    if (!all(names(data) == expected_colnames)) {
      stop("Column names test failed: Column names do not match expected names.")
    }
    cat("Column names test passed.\n")
  },
  
  na_values_test = function(data) {
    if (any(is.na(data$pollscore))) {
      stop("NA values test failed: pollscore contains NA values.")
    }
    if (any(is.na(data$candidate_name))) {
      stop("NA values test failed: candidate_name contains NA values.")
    }
    cat("NA values test passed.\n")
  },
  
  numeric_grade_pollscore_test = function(data) {
    if (any(data$numeric_grade < 2 | data$numeric_grade > 5)) {
      stop("Numeric grade test failed: numeric_grade is out of expected range.")
    }
    if (any(data$pollscore < 60 | data$pollscore > 100)) {
      stop("Pollscore test failed: pollscore is out of expected range.")
    }
    cat("Numeric grade and pollscore test passed.\n")
  },
  
  sample_size_test = function(data) {
    if (any(data$sample_size < 500 | data$sample_size > 2000)) {
      stop("Sample size test failed: sample_size is out of expected range.")
    }
    cat("Sample size test passed.\n")
  },
  
  date_logic_test = function(data) {
    if (any(data$start_date >= data$end_date)) {
      stop("Date logic test failed: start_date is not before end_date.")
    }
    cat("Date logic test passed.\n")
  },
  
  election_date_test = function(data) {
    if (any(data$election_date < as.Date('2024-11-01') | data$election_date > as.Date('2024-11-08'))) {
      stop("Election date test failed: election_date is out of expected range.")
    }
    cat("Election date test passed.\n")
  },
  
  candidate_parties_test = function(data) {
    valid_candidates <- c("Candidate 1", "Candidate 2", "Candidate 3")
    if (any(!data$candidate_name %in% valid_candidates)) {
      stop("Candidate parties test failed: candidate_name contains invalid candidates.")
    }
    cat("Candidate parties test passed.\n")
  }
)

run_tests <- function(data) {
  walk(tests, ~ .x(data))  
  cat("All tests completed successfully!\n")
}

run_tests(cleaned_data)