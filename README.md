# Trump vs. Harris: A Data-Driven Forecast modeling the 2024 US Presidential Elections

## Overview

This repository provides readers with all the necessary data, R scripts, and files to understand and reproduce a prediction on United State Presidential Election.

The data used in this analysis comes from a combination of publicly available polling data for the 2024 U.S. Presidential election. The analysis leverages R and several libraries. The dataset covers various polls conducted across multiple states, capturing the support for each major candidate—Donald Trump and Kamala Harris—along with detailed attributes of the polls.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from https://projects.fivethirtyeight.com/polls/president-general/2024/national/.
-   `data/analysis_data` contains the cleaned datasets that were constructed.
-   `data/simulated_data` contains the simulated data that were constructed.
-   `model` contains fitted models. 
-   `other` contains relevant literature, details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, clean, and test data.


## Statement on LLM usage

LLMs are currently not used in this analysis in any way. If any, the entire chat history is available in other/llms/usage.txt.
