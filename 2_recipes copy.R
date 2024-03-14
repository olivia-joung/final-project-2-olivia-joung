# Resampling ----
# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(naniar)

# handle common conflicts
tidymodels_prefer()

# read in training data/folds
load(here("data/spotify_train.rda"))
load(here("data/spotify_folds.rda"))

# recipes

## basic (baseline) recipe
spotify_rec_baseline <- recipe(track_popularity ~ ., data = spotify_train) |> 
  step_rm(track_popularity_bins) |>
  step_dummy(all_nominal_predictors()) |>
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

spotify_rec_baseline |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

## linear recipe 

### with playlist genre
spotify_rec_lm <- recipe(track_popularity ~ ., data = spotify_train) |> 
  step_rm(track_popularity_bins, key, mode) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_interact(~ tempo:danceability) |> 
  step_interact(~ tempo:energy) |> 
  step_interact(~ energy:loudness) |> 
  step_interact(~ speechiness:instrumentalness) |> 
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

spotify_rec_lm |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

### w/o playlist genre
spotify_rec_lm_no <- recipe(track_popularity ~ ., data = spotify_train) |> 
  step_rm(track_popularity_bins, key, mode, playlist_genre, playlist_subgenre) |>
  step_interact(~ tempo:danceability) |> 
  step_interact(~ tempo:energy) |> 
  step_interact(~ energy:loudness) |> 
  step_interact(~ speechiness:instrumentalness) |> 
  step_zv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

spotify_rec_lm_no |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

## tree-based recipe

### w/ playlist genre
spotify_rec_tree <- recipe(track_popularity ~ ., data = spotify_train) %>% 
  step_rm(track_popularity_bins, key, mode) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

spotify_rec_tree |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()

### w/o playlist genre
spotify_rec_tree_no <- recipe(track_popularity ~ ., data = spotify_train) %>% 
  step_rm(track_popularity_bins, key, mode, playlist_genre, playlist_subgenre) |>
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

spotify_rec_tree_no |>
  prep() |>
  bake(new_data = NULL) |>
  glimpse()


# save recipe
save(spotify_rec_baseline, file = here("recipes/spotify_rec_baseline.rda"))
save(spotify_rec_lm, file = here("recipes/spotify_rec_lm.rda"))
save(spotify_rec_tree, file = here("recipes/spotify_rec_tree.rda"))
save(spotify_rec_lm_no, file = here("recipes/spotify_rec_lm_no.rda"))
save(spotify_rec_tree_no, file = here("recipes/spotify_rec_tree_no.rda"))

