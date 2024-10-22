#### Preamble ####
# Purpose: Simulate polling data for the 2024 US Election for use in election forecasting
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` and 'arrow' packages must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj

# load libraries
library(dplyr)
library(arrow)

# set seed for reproducability
set.seed(123)

# define possible values to simulate polling data
pollster_ids <- c(1001, 1002, 1003, 1004)
pollsters <- c("Pollster A", "Pollster B", "Pollster C", "Pollster D")
sponsors <- c("Sponsor 1", "Sponsor 2", "Sponsor 3")
states <- c("Florida", "Ohio", "Texas", "Georgia", "Arizona", "California")
methodologies <- c("Phone", "Online", "Mixed")
candidates <- c("Candidate 1", "Candidate 2", "Candidate 3")
candidate_parties <- c("Party A", "Party B", "Party C")
population_types <- c("Registered Voters", "Likely Voters", "Adults")
n <- 100

# generate random start and end dates for each poll
start_dates <- sample(seq(as.Date("2024-01-01"), as.Date("2024-12-31"), by = "day"), n, replace = TRUE)
end_dates <- start_dates + sample(1:30, n, replace = TRUE)

# create a simulated data frame of polls with various attributes
poll_data <- data.frame(
  poll_id = 1:n,
  pollster_id = sample(pollster_ids, n, replace = TRUE),
  pollster = sample(pollsters, n, replace = TRUE),
  sponsor_ids = sample(1:3, n, replace = TRUE),
  sponsors = sample(sponsors, n, replace = TRUE),
  pollster_rating_id = sample(1:5, n, replace = TRUE),
  numeric_grade = round(runif(n, 2, 5), 2),
  pollscore = round(runif(n, 60, 100), 2),
  methodology = sample(methodologies, n, replace = TRUE),
  state = sample(states, n, replace = TRUE),
  start_date = start_dates,
  end_date = end_dates,
  sponsor_candidate = sample(candidates, n, replace = TRUE),
  sponsor_candidate_party = sample(candidate_parties, n, replace = TRUE),
  endorsed_candidate_name = sample(candidates, n, replace = TRUE),
  endorsed_candidate_party = sample(candidate_parties, n, replace = TRUE),
  sample_size = sample(500:2000, n, replace = TRUE),
  population = sample(population_types, n, replace = TRUE),
  election_date = sample(seq(as.Date("2024-11-01"), as.Date("2024-11-08"), by = "day"), n, replace = TRUE),
  stage = sample(c("Primary", "General"), n, replace = TRUE),
  candidate_name = sample(candidates, n, replace = TRUE),
  pct = round(runif(n, 30, 60), 2)
)

# write the cleaned and simulated polling data to a CSV file
write_csv(cleaned_data, here::here("data/simulated_data/simulated_data.csv"))
write_parquet(cleaned_data, here::here("data/simulated_data/simulated_data.parquet"))
