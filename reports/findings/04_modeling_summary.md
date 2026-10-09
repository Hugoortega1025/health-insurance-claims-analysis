# Predictive Modeling Summary (Step 5)

Dataset: `insurance_cleaned`, 1,332 policyholders, split 80/20 (1,065 training, 267 test, `random_state=42`). Notebook: `notebooks/04_modeling.ipynb`. Input preparation: `src/models/features.py`. Every number below is printed by a cell in the notebook.

Business question: how accurately can an insurer's pricing team predict a customer's claim? Accuracy is measured by MAE (mean absolute error) in dollars. Claim units are undocumented and the data may be synthetic.

## Results

| Model | Cross-validated MAE (5-fold, training) | Test MAE |
|---|---|---|
| Baseline: training median for everyone | 8,394 | 8,183 |
| Linear regression (Model 2 inputs) | 4,136 | 4,083 |
| Ridge / Lasso (alpha = 1) | 4,136 | |
| Random forest | 4,100 | |
| Gradient boosting (final model) | 3,967 | 3,697 |

- Gradient boosting was chosen before the test set was used. On the test set it is off by about 3,700 per person, 55% less error than the baseline.
- It beat linear regression and the random forest in all five folds. The gain over linear regression is modest: 168 per person (4%) in cross-validation, 386 (9%) on the test set.
- Ridge and Lasso match linear regression: with 12 inputs and 1,065 rows, the linear model is not overfitting.
- The random forest scores 1,534 on its own training data but 4,100 in cross-validation, a clear case of overfitting caught by cross-validation.

## The interaction from Step 4 matters for prediction

| Model | With BMI 30+ columns | Without them |
|---|---|---|
| Linear regression | 4,136 | 4,980 |
| Random forest | 4,100 | 4,088 |

Tree models find the smoking × BMI 30 pattern on their own. Linear regression needs it built in. With it, the explainable model comes within 4% to 9% of the best model.

## Error analysis (test set; error = actual minus predicted)

| Group | n | MAE | Mean error |
|---|---|---|---|
| Non-smokers, BMI 30+ | 111 | 3,796 | +125 |
| Non-smokers, BMI under 30 | 104 | 3,440 | -246 |
| Smokers, BMI 30+ | 29 | 4,610 | -379 |
| Smokers, BMI under 30 | 23 | 3,233 | +711 |

- No group is badly biased: mean errors are a few hundred dollars, compared with 6,500 to 7,400 for Model 1 in Step 4.
- 12 test people are missed by more than 10,000. 9 are non-smokers, and 11 were predicted too low. They would be underpriced, and no variable in the data explains them.

## What drives the predictions (permutation importance, test set)

Smoker × BMI 30+ (3,154), smoker (2,218) and blood pressure (1,329) dominate, followed by BMI (271) and region (45 to 155). Age, gender, children, diabetic and BMI 30+ on its own contribute about nothing. This matches Step 4, except children, which is significant in Step 4 but too small to improve predictions noticeably.

## Fairness

| Inputs | Cross-validated MAE | Change |
|---|---|---|
| All inputs | 3,967 | |
| Without gender | 3,974 | +7 (folds go both ways) |
| Without region | 4,071 | +104 (worse in every fold) |
| Without gender and region | 4,042 | +74 |

- Gender can be dropped with no loss of accuracy; the ACA does not allow it in individual health premiums.
- Region adds about 100 per person; location is a permitted factor.
- BMI and blood pressure are health status, which the ACA does not allow in individual-market premiums. As built, the model fits settings where health information can legally be used, or internal cost forecasting.

## Not done

Hyperparameter tuning and partial dependence plots. The default models already beat the baseline by a wide margin, and the BMI 30+ columns plus permutation importance already show how the model uses smoking and BMI.
