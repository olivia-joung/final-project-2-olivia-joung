# Analysis of tuned and trained models (comparisons)
# Select final model
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load testing data
load(here("data/spotify_test.rda"))

# load models
load(here("results/baseline_fit.rda"))
load(here("results/lm_fit.rda"))
load(here("results/lm_fit_no.rda"))
load(here("results/lm_fit_basic.rda"))
load(here("results/en_tuned_basic.rda"))
load(here("results/en_tuned.rda"))
load(here("results/en_tuned_no.rda"))
load(here("results/boost_tuned_basic.rda"))
load(here("results/boost_tuned.rda"))
load(here("results/boost_tuned_no.rda"))
load(here("results/rf_tuned_basic.rda"))
load(here("results/rf_tuned.rda"))
load(here("results/rf_tuned_no.rda"))
load(here("results/knn_tuned_basic.rda"))
load(here("results/knn_tuned.rda"))
load(here("results/knn_tuned_no.rda"))

# collecting metrics

## baseline
baseline_metrics <- collect_metrics(baseline_fit) |> 
  filter(.metric == "rmse") |>
  mutate(model = "baseline")

## lm
lm_metrics_basic <- collect_metrics(lm_fit_basic) |> 
  filter(.metric == "rmse") |>
  mutate(model = "lm_basic")

lm_metrics <- collect_metrics(lm_fit) |> 
  filter(.metric == "rmse") |>
  mutate(model = "lm")

lm_metrics_no <- collect_metrics(lm_fit_no) |> 
  filter(.metric == "rmse") |>
  mutate(model = "lm_no")

## en
en_metrics_basic <- collect_metrics(en_tuned_basic) |> 
  filter(.metric == "rmse") |>
  arrange(mean) |>
  mutate(model = "en_basic")

en_metrics <- collect_metrics(en_tuned) |> 
  filter(.metric == "rmse") |>
  mutate(model = "en")

en_metrics_no <- collect_metrics(en_tuned_no) |> 
  filter(.metric == "rmse") |>
  mutate(model = "en_no")

## bt
bt_metrics_basic <- collect_metrics(boost_tuned_basic) |> 
  filter(.metric == "rmse") |>
  arrange(mean) |>
  mutate(model = "bt_basic")

bt_metrics <- collect_metrics(boost_tuned) |> 
  filter(.metric == "rmse") |>
  arrange(mean) |>
  mutate(model = "bt")

bt_metrics_no <- collect_metrics(boost_tuned_no) |> 
  filter(.metric == "rmse", mean < 24) |>
  arrange(std_err) |>
  mutate(model = "bt_no")

## rf
rf_metrics_basic <- collect_metrics(rf_fit_basic) |> 
  filter(.metric == "rmse") |>
  mutate(model = "rf_basic")

rf_metrics <- collect_metrics(rf_fit) |> 
  filter(.metric == "rmse") |>
  mutate(model = "rf")

rf_metrics_no <- collect_metrics(rf_fit_no) |> 
  filter(.metric == "rmse") |>
  mutate(model = "rf_no")

## knn
knn_metrics_basic <- collect_metrics(knn_tuned_basic) |> 
  filter(.metric == "rmse", neighbors == 15) |>
  mutate(model = "knn_basic") 

knn_metrics <- collect_metrics(knn_tuned) |> 
  filter(.metric == "rmse", neighbors == 15) |>
  mutate(model = "knn")

knn_metrics_no <- collect_metrics(knn_tuned_no) |> 
  filter(.metric == "rmse", neighbors == 15) |>
  mutate(model = "knn_no")

