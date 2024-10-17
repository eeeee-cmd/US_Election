#### Preamble ####
# Purpose: Downloads and saves the data from https://projects.fivethirtyeight.com/polls/president-general/2024/national/
# Author: Deyi Kong
# Date: 17 October 2024
# Contact: deyi.kong@mail.utoronto.ca
# License: MIT
# Pre-requisites: The `tidyverse` package must be installed and loaded
# Any other information needed? Make sure you are in the `election_folder` rproj


#### Workspace setup ####
library(tidyverse)

#### Download data ####
data <- read.csv("/Users/a._./Downloads/president_polls.csv")

#### Save data ####
write_csv(data, "data/01-raw_data/raw_data.csv") 

         
