# Trump vs. Harris: A 2024 US Presidential Elections Modelling Forecast

By: Sophia Brothers, Deyi Kong and Rayan Awad Alim.

## Overview

This repository provides readers with all the necessary data, R scripts, and files to understand and reproduce a prediction on United States Presidential Election.

Here we predicts the 2024 U.S. Presidential election. We utilizes linear regression model deploying polling data and demographic factors to predict both popular vote and Electoral College outcomes. The findings indicate a close race between Donald Trump and Kamala Harris, and we predict Trump will secure the Electoral College and Popular Vote due to key wins in tight races for the Battleground States. The results emphasize the role of state-level dynamics, particularly in Battleground states, in determining election outcomes.

The data used in this analysis comes from a combination of publicly available polling data for the 2024 U.S. Presidential election. The analysis leverages R and several libraries. The dataset covers various polls conducted across multiple states, capturing the support for each major candidate—Donald Trump and Kamala Harris—along with detailed attributes of the polls. Obtained from: https://projects.fivethirtyeight.com/polls/president-general/2024/national/.


## File Structure

The repo is structured as:

-   `data/raw_data` contains the raw data as obtained from https://projects.fivethirtyeight.com/polls/president-general/2024/national/.
-   `data/analysis_data` contains the cleaned datasets that were constructed.
-   `data/simulated_data` contains the simulated data that were constructed.
-   `models` contains fitted models. 
-   `other` contains details about LLM chat interactions and sketches.
-   `paper` contains the files used to generate the paper, including the Quarto document and reference bibliography file, as well as the PDF of the paper. 
-   `scripts` contains the R scripts used to simulate, download, clean, test data, exploratory analysis, modelling and validation.


## Statement on LLM usage

LLMs such as ChatGPT were used to help formulate the questions for the simulated survey, summarize figures + tables, provide election context, as well as for minor coding help. Full usage can be found on `other/llm_usage/usage.txt`.
