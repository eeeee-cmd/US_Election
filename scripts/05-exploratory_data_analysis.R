#### Preamble ####
# Purpose: 
# Author: Sophia Brothers
# Date: 
# Contact: 
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed
# Any other information needed? Make sure you are in the `starter_folder` rproj

library(tidyverse)
library(janitor)
library(here)
library(reshape2)

cleaned_data <- read_csv(here::here("data/analysis_data/president_polls_cleaned.csv")) |> 
  clean_names()

glimpse(cleaned_data)

head(cleaned_data)

tail(cleaned_data)

cleaned_data |> 
  slice_sample(n = 6)

summary(cleaned_data)

missing_data <- cleaned_data |> 
  summarise(across(everything(), ~sum(is.na(.))))
missing_data