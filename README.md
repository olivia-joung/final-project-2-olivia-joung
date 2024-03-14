## Spotify Data: An Analysis on Track Popularity

This repository is for an analysis of data on 30,000 Spotify tracks, including qualitative data like genre/subgenre, as well as quantitative data like energy, song duration, etc.

## Basic overview of what can be found in repo

**Note: I had commit issues with my original repo, so this is a copy of my original project, which is why all the commits are so close together. Previously discussed with Professor Kuyper.**

### Folders/directories

- `data/` - raw data, as well as training/testing sets and folds
- `memos/` - memos 1 and 2
- `plots/` - all plots
- `recipes/` - all recipes
- `results/` - all fitted/tuned models and their metrics/results

### R scripts

- `0a_data_collection.R` - read in data
- `0b_univariate_analysis.R` - univariate EDA
- `1_initial_setup.R` - splitting/folding data
- `2_recipes.R` - all recipes created
- `3_fit_baseline.R` - null/baseline model
- `3_fit_bt.R` - boosted tree model
- `3_fit_knn.R` - k-nearest neighbors model
- `3_fit_lasso.R` - lasso model
- `3_fit_lm.R` - linear regression model
- `3_fit_rf.R` - random forest model
- `4_model_analysis.R` - model analysis of current models (will likely split into multiple scripts once bt, knn, and rf are fitted)
- `5_train_final_model.R` - training final model
- `5_final_model_analysis.R` - assessing final model



