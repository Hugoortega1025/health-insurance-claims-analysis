# Statistical Analysis Summary (Step 4)

Dataset: `insurance_cleaned`, 1,332 policyholders. Notebook: `notebooks/03_statistical_analysis.ipynb`. Every number below is printed by a cell in that notebook.

These are associations in data that may be synthetic, not proof of cause and effect. Claim units are undocumented, so amounts are shown as plain numbers.

## Final model

Model 2: ordinary least squares on claim (in dollars) with all variables plus a smoking × BMI 30+ interaction.

```
claim ~ age + bmi + bloodpressure + children + diabetic + C(gender) + C(region) + smoker * bmi_30_plus
```

| Fit | Model 1 (no interaction) | Model 2 (final) |
|---|---|---|
| R² | 0.707 | 0.792 |
| Adjusted R² | 0.705 | 0.790 |
| AIC | 27,212 | 26,759 |
| BIC | 27,270 | 26,827 |

The F-test comparing the two models shows the interaction improves the fit by more than chance (p < 0.001).

## Hypotheses from EDA

| Hypothesis | Result | Evidence from Model 2 (other variables held constant) |
|---|---|---|
| 1. Smoking is the strongest factor | Supported | Smokers with BMI under 30: +12,380 |
| 2. Smoking and BMI 30+ interact | Supported | Interaction +17,750 (95% CI 16,200 to 19,300). An obese smoker's expected claim is about 29,300 higher than a non-smoker under BMI 30. |
| 3. Blood pressure adds little once smoking and BMI are included | Not supported | +137 per point (95% CI 107 to 168), down from 229 in Model 1 |
| 4. The northeast has higher claims | Supported | Other regions about 2,200 to 3,200 lower |
| 5. Age shows little association | Supported | +9 per year, p = 0.53 |
| 6. Gender, diabetic status and children show little association | Partly supported | Gender (p = 0.16) and diabetic (p = 0.35) not significant; children +694 per child (95% CI 446 to 942) |

## Why Model 2

- Model 1 left a clear pattern in its residuals. It predicted too low for obese smokers (average residual +6,546) and too high for non-obese smokers (-7,358), and its residual spread was uneven (Breusch-Pagan p < 0.001).
- Model 2 removed both problems. Residuals average zero in every smoking × BMI group, with a similar spread (SD about 4,900 to 6,300), and Breusch-Pagan p = 0.185.
- Its remaining issue is a long right tail (residual skewness 1.48). 73 people have claims more than 10,000 above their prediction, 61 of them non-smokers. No variable in the data explains them.

## Checks and alternatives

| Check | Result |
|---|---|
| Robust standard errors (HC3) | Standard errors change slightly; no variable changes significance |
| Model 3: log(claim) | Fixes the right tail (skewness -0.11), but brings back heteroscedasticity (p < 0.001) and creates a downward slope in smokers' residuals. Rejected. |
| Gamma GLM, log link | Predictions run away (up to 98,305 against a largest actual claim of 63,770); same banding as Model 3. Rejected. |
| Gamma GLM, identity link | Same conclusions as Model 2 (smoker +12,538, interaction +17,709). Its variance assumption fits this data worse: smokers' Pearson residuals are much tighter than non-smokers'. Kept as a robustness check. |

## Limitations

- Observational data, possibly synthetic: the results are associations within this dataset.
- The model treats each child and each BMI point as adding the same amount, which is an approximation.
- High-claim non-smokers remain unexplained by the available variables.
- Gender is significant only in the log model (p = 0.038), so it is treated as weak evidence.
