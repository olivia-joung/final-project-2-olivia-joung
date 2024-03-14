# Resampling ----
# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

# handle common conflicts
tidymodels_prefer()

# set seed
set.seed(02232024)

# load data ----

spotify_data <- read_rds(here("data/spotify_data.rds"))

# initial split ----
spotify_split <- spotify_data |> 
  initial_split(prop = 0.8, strat = track_popularity)

# make sure to include verification of # of cols/rows
spotify_train <- spotify_split |> training()
spotify_test <- spotify_split |> testing()

# folding data
set.seed(123456)

spotify_folds <-
  spotify_train |>
  vfold_cv(v = 10, repeats = 5, strata = track_popularity)

# writing sets/folds to rda
save(spotify_split, file = here("data/spotify_split.rda"))
save(spotify_train, file = here("data/spotify_train.rda"))
save(spotify_test, file = here("data/spotify_test.rda"))
save(spotify_folds, file = here("data/spotify_folds.rda"))