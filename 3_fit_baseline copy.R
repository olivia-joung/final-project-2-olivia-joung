# Model Tuning ----
# Define and fit baseline (linear regression) model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

num_cores <- parallel::detectCores(logical = TRUE)

registerDoMC(cores = num_cores)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data/spotify_train.rda"))
load(here("data/spotify_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/spotify_rec_baseline.rda"))

## null
# model specifications ----
null_spec <- 
  null_model() |> 
  set_engine("parsnip") |>
  set_mode("regression")

null_wflow <- 
  workflow() |>
  add_model(null_spec) |> 
  add_recipe(spotify_rec_baseline)


# fit model ----
null_fit <- 
  null_wflow |> 
  fit_resamples(
    resamples = spotify_folds, 
    metrics = metric_set(rmse),
    control = control_resamples(save_workflow = TRUE))

## linear baseline
# model specifications ----
baseline_spec <- 
  linear_reg() |>
  set_mode("regression") |>
  set_engine("lm")

# define workflows ----
baseline_wflow <-
  workflow() |> 
  add_model(baseline_spec) |> 
  add_recipe(spotify_rec_baseline)

# fit workflows/models ----
baseline_fit <- 
  baseline_wflow |>
  fit_resamples(
    resamples = spotify_folds, 
    control = control_resamples(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(null_fit, file = here("results/null_fit.rda"))
save(baseline_fit, file = here("results/baseline_fit.rda"))
