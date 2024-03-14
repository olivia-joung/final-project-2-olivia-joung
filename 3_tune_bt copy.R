# Model Tuning ----
# Define and fit boosted tree model

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
boost_spec <-
  boost_tree(
    mtry = tune(), 
    min_n = tune(), 
    learn_rate = tune()) |>
  set_engine("xgboost") |>
  set_mode("regression")

# define workflows ----
boost_wflow_basic <-
  workflow() |> 
  add_model(boost_spec) |> 
  add_recipe(spotify_rec_baseline)

boost_wflow <-
  workflow() |> 
  add_model(boost_spec) |> 
  add_recipe(spotify_rec_tree)

boost_wflow_no <-
  workflow() |> 
  add_model(boost_spec) |> 
  add_recipe(spotify_rec_tree_no)

# hyperparameter tuning values ----
hardhat::extract_parameter_set_dials(boost_spec)

boost_params <- parameters(boost_spec) |>
  update(
    mtry = mtry(c(1, 10)),
    learn_rate = learn_rate(c(-5, -0.2)))

boost_grid <- grid_regular(boost_params, levels = 5)

# fit workflows/models ----
set.seed(02272024)

boost_tuned_basic <-
  boost_wflow_basic |>
  tune_grid(
    spotify_folds,
    grid = boost_grid,
    control = control_grid(save_workflow = TRUE)
  )

boost_tuned <-
  boost_wflow |>
  tune_grid(
    spotify_folds,
    grid = boost_grid,
    control = control_grid(save_workflow = TRUE)
  )

boost_tuned_no <-
  boost_wflow_no |>
  tune_grid(
    spotify_folds,
    grid = boost_grid,
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(boost_tuned, file = here("results/boost_tuned.rda"))
save(boost_tuned_basic, file = here("results/boost_tuned_basic.rda"))
save(boost_tuned_no, file = here("results/boost_tuned_no.rda"))
