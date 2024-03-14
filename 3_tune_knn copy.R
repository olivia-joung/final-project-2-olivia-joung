# Model Tuning ----
# Define and fit k-nearest neighbors model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores - 2)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data/spotify_train.rda"))
load(here("data/spotify_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/spotify_rec_tree.rda"))
load(here("recipes/spotify_rec_tree_no.rda"))
load(here("recipes/spotify_rec_baseline.rda"))

# model specifications ----
knn_spec <-
  nearest_neighbor(neighbors = tune()) |>
  set_engine("kknn") |>
  set_mode("regression")

# define workflows ----
knn_wflow_basic <-
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(spotify_rec_baseline)

knn_wflow <-
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(spotify_rec_tree)

knn_wflow_no <-
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(spotify_rec_tree_no)

# hyperparameter tuning values ----
hardhat::extract_parameter_set_dials(knn_spec)

knn_params <- parameters(knn_spec)

knn_grid <- grid_regular(knn_params, levels = 5) 

# fit workflows/models ----
set.seed(02262024)

knn_tuned_basic <-
  knn_wflow_basic |>
  tune_grid(
    spotify_folds,
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE)
  )

knn_tuned <-
  knn_wflow |>
  tune_grid(
    spotify_folds,
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE)
  )

knn_tuned_no <-
  knn_wflow_no |>
  tune_grid(
    spotify_folds,
    grid = knn_grid,
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(knn_tuned, file = here("results/knn_tuned.rda"))
save(knn_tuned_basic, file = here("results/knn_tuned_basic.rda"))
save(knn_tuned_no, file = here("results/knn_tuned_no.rda"))
