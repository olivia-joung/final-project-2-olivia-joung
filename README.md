## Basic repo setup for final project

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



