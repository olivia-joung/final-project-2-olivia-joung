# Initial reading in of data ----

# Load packages
library(tidyverse)
library(here)
library(skimr)
library(janitor)

# Load data
spotify_songs <- read.csv(here("data/spotify_songs.csv")) |>
  janitor::clean_names() |>
  tibble()

# Inspection
skim(spotify_songs)

write_rds(spotify_songs, here("data/spotify_songs.rds"))
