# load packages
library(dplyr)
library(jsonlite)
library(lubridate)
library(tidyr)
library(readr)
library(stringr)
library(slider)
library(tibble)
library(ggplot2)

# load sources
for(script in list.files("sources", full.names = TRUE)) {source(script)}
