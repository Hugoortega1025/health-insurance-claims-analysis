"""Turn the cleaned insurance table into model inputs for scikit-learn."""

import pandas as pd


def build_features(df):
    """Return X (the inputs) and y (claim) from the cleaned insurance table.

    - Adds the two columns found in Step 4: BMI 30+ and smoker x BMI 30+.
    - Turns yes/no columns into 1/0 and text columns into 0/1 columns.

    Every step looks at one row at a time, so it is safe to run before the train/test split.
    """
    # Column order matters slightly for tree models (it decides ties between equally good splits),
    # so keep the order of the original table
    X = df[["age", "gender", "bmi", "bloodpressure", "diabetic", "children", "smoker", "region"]].copy()

    # Same two columns as Model 2 in notebook 03
    X["bmi_30_plus"] = (X["bmi"] >= 30).astype(int)                      # 1 if BMI is 30 or more
    X["smoker_bmi_30"] = (X["smoker"] & (X["bmi"] >= 30)).astype(int)    # 1 only for smokers with BMI 30+

    # Yes/no columns become 1/0
    X["smoker"] = X["smoker"].astype(int)
    X["diabetic"] = X["diabetic"].astype(int)

    # Text columns become 0/1 columns, one per category
    # drop_first=True leaves out one category as the baseline (female, northeast)
    X = pd.get_dummies(X, columns=["gender", "region"], drop_first=True, dtype=int)

    y = df["claim"]
    return X, y
