#### Preamble ####
# Purpose: This script loads the raw presidential polling data from a CSV file for further analysis.
# Author: Sophia Brothers
# Date: October 22nd, 2024
# Contact: sophia.brothers@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `US_Election_2024` rproj

# load library
library(readr)

# Read the raw presidential polls data
data <- read_csv(here::here("data/raw_data/president_polls.csv"))
