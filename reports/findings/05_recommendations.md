# Recommendations (Step 7)

Audience: a health insurer's planning team (claims budgeting and member health programs).

Goal of the project: understand what drives members' claim costs and forecast them, so the insurer can budget for future claims, see where its money goes, and put prevention programs where they help most.

Each recommendation lists the evidence behind it and how strong that evidence is. All results come from one dataset of 1,332 members whose source is undocumented and which may be synthetic. They show associations, not proof of cause and effect.

## 1. Use the forecast to plan claim costs by member group

What to do: use the forecasting model to estimate each member's expected claim cost, and add these up by member group (for example smokers with obesity, other smokers, non-smokers) to plan where claim money will go.

Evidence:
- Tested on 267 members it never saw, the model is off by about 3,700 per member on average, compared with about 8,200 for a flat estimate (55% less error). Source: `reports/findings/04_modeling_summary.md`.
- No member group is badly over- or under-forecast (average errors of a few hundred dollars per group).
- If forecasts must be explained line by line, a linear regression using the same inputs is only 4% to 9% less accurate, and every effect can be read in dollars.

Strength: strong for this dataset. The model was chosen with cross-validation and tested once on held-out data.

## 2. Focus prevention programs on smokers with obesity, starting with a pilot

What to do: offer quit-smoking and weight-management support to smokers with a BMI of 30 or more. Start with a pilot: give the program to part of this group, keep a comparison group, and measure whether claim costs actually fall before rolling it out to everyone.

Evidence:
- Smokers with obesity are 11% of members but 34% of all claim costs. Source: `sql/03_analysis/06_segment_shares.sql`.
- Their typical claim (median 40,904) is more than 5 times a non-smoker's (7,365).
- Obesity raises costs mainly for smokers. Holding other factors constant, BMI 30+ adds about 17,750 for smokers on top of the smoking effect, but is not significant for non-smokers. Source: `reports/findings/03_statistical_analysis_summary.md`.

Strength: the association is strong and consistent across every method used. But it does not prove that quitting smoking or losing weight would lower these members' costs. That is why the pilot with a comparison group matters: it turns the association into evidence of what the program actually saves.

## 3. Keep smoking status accurate and up to date

What to do: treat smoking status as a priority data point in member records, and update it regularly.

Evidence:
- Smoking, alone and combined with obesity, is the strongest factor in both the regression and the forecasting model (removing either from the model raises the error more than any other input). Source: `reports/findings/04_modeling_summary.md`.
- Tobacco use is one of the factors US individual-market premiums are allowed to vary by, so this information is also usable for pricing, unlike BMI or blood pressure.

Strength: strong.

## 4. Collect fuller health history to explain unexpected high-cost members

What to do: where it is legal and members consent, collect more health history (for example chronic conditions or past hospital stays) to explain the members the current data cannot.

Evidence:
- 12 of 267 test members cost more than 10,000 above their forecast. 9 of them were non-smokers and 11 were under-forecast. None of the variables in this dataset explain them. Source: `reports/findings/04_modeling_summary.md`.
- These members cause the largest forecast misses, and better algorithms cannot fix missing information.

Strength: moderate. The gap is clear; which extra data would close it is untested.

## 5. Leave gender out, and keep health status out of individual premiums

What to do: drop gender from the model, and use the health-based forecast for budgeting and prevention planning rather than for setting individual premiums in the ACA individual market.

Evidence:
- Removing gender changes the forecast error by 7 per member, with no consistent direction, so it adds nothing. Source: `reports/findings/04_modeling_summary.md`.
- Under the Affordable Care Act, individual-market premiums may vary by age, tobacco use, location and family size, but not by gender or health status. BMI and blood pressure are health status.
- Region adds a small, consistent amount of accuracy (about 100 per member) and is a permitted factor, so it can stay.

Strength: strong for gender. The regulatory point is a rule, not a finding.

## What this analysis cannot tell us

- Whether these patterns hold for a real insurer's members. The data source is undocumented, and several patterns (a sharp jump at BMI 30, a sharp edge at blood pressure 100, men and women covering different age ranges) suggest it may be synthetic.
- Whether prevention programs would reduce costs (recommendation 2's pilot is designed to answer this).
- A range for each member's forecast. The model gives a single estimate with a typical error of about 3,700; per-member ranges would be a next step.
