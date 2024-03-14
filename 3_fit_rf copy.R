# Model Tuning ----
# Define and fit random forest model

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
rf_spec <-
  rand_forest(
    mode = "regression",
    trees = 1000, 
    min_n = tune(),
    mtry = tune()
  ) |> 
  set_engine("ranger")

# define workflows ----
rf_wflow_basic <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(spotify_rec_baseline)

rf_wflow <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(spotify_rec_tree)

rf_wflow_no <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(spotify_rec_tree_no)

# hyperparameter tuning values ----
hardhat::extract_parameter_set_dials(rf_spec)

rf_params_basic <- parameters(rf_spec) |> 
  update(mtry = mtry(c(1, 14)))

rf_params <- parameters(rf_spec) |>
  update(mtry = mtry(c(1, 12)))

rf_params_no <- parameters(rf_spec) |>
  update(mtry = mtry(c(1, 10)))

rf_grid_basic <- grid_regular(rf_params_basic, levels = 5)
rf_grid <- grid_regular(rf_params, levels = 5)
rf_grid_no <- grid_regular(rf_params_no, levels = 5)

# fit workflows/models ----
set.seed(02272024)

rf_tuned_basic <-
  rf_wflow_basic |>
  tune_grid(
    spotify_folds,
    grid = rf_grid_basic,
    control = control_grid(save_workflow = TRUE)
  )

rf_tuned <-
  rf_wflow |>
  tune_grid(
    spotify_folds,
    grid = rf_grid,
    control = control_grid(save_workflow = TRUE)
  )

rf_tuned_no <-
  rf_wflow_no |>
  tune_grid(
    spotify_folds,
    grid = rf_grid,
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(rf_tuned, file = here("results/rf_tuned.rda"))
save(rf_tuned_basic, file = here("results/rf_tuned_basic.rda"))
save(rf_tuned_no, file = here("results/rf_tuned_no.rda"))
