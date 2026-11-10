# Business Insights: Smartphone Feature–Price Analysis

## Business objective
Recommend a practical smartphone specification mix and target price for an Indian smartphone brand launching a model below ₹20,000.

## Key findings
The analysis uses 973 records after excluding seven models flagged for manual verification. The target segment contains 506 phones.

| Feature | Finding in the ₹15K–₹20K segment | Business implication |
|---|---|---|
| RAM | Average rating score: 73.3 for 4GB, 79.3 for 6GB, and 81.4 for 8GB. Median prices: ₹15,999, ₹17,990, and ₹18,249. | 8GB is attractive if the cost increase is manageable. |
| Storage | 128GB is the most represented configuration (140 rated records); average rating score 79.9. | Use 128GB as the baseline. |
| 5G | Median price: ₹17,990 for 5G vs ₹16,999 for non-5G. | Include 5G; its observed median-price premium is about ₹991. |
| Battery | 138 of 170 phones have at least 5,000 mAh. | Target a 5,000 mAh-class battery, but do not pay a large premium for capacity alone. |
| Processor | Snapdragon and Dimensity average rating scores are 79.4 and 79.1. | Either is a reasonable candidate; compare specific chipset models and costs. |
| Processor speed | 156 of 167 phones with known speed fall in the 2.0–2.49 GHz range. | Do not select a chipset using clock speed alone. |
| Rear camera | 100+ MP phones average 82.6, versus 79.4 for 50–99 MP; the 100+ MP group has 26 phones. | Consider camera hardware as a differentiator, but validate sensor and image-processing quality. |

## Regression result
A multiple linear regression model was trained on 506 phones priced below ₹20,000, using an 80/20 train-test split.

- R²: 0.668
- MAE: ₹1,871.54
- RMSE: ₹2,401.91
- Baseline MAE: ₹3,570.30

The model outperformed the average-price baseline on this test split. These results are an initial estimate, not a guarantee of future pricing accuracy. Regression coefficients are associations, not causal effects.

## Recommendation
Evaluate the following specification for a product positioned at **₹18,999**:

- 8GB RAM
- 128GB internal storage
- 5G connectivity
- 5,000 mAh or higher battery
- Snapdragon or Dimensity chipset selected on real-world performance and cost
- Rear camera in the 50–99 MP range as a practical baseline; consider 100+ MP only after validating sensor quality

## Important limitations
- The source rating field's definition and scale are unverified. It is described as a rating score, not confirmed customer satisfaction.
- The dataset is observational and cannot establish that a feature causes a price or rating change.
- RAM and storage comparisons use rated records only; their counts exclude phones with missing ratings.
- Megapixels and processor clock speed do not independently measure real-world quality or performance.
- The regression uses one train-test split and a limited set of predictors.
- Listed prices may differ from transaction prices. Manufacturing cost, sales volume, demand, and competitor strategy were not modelled.

## Bottom line
An 8GB / 128GB / 5G phone with a 5,000 mAh-class battery and a capable Snapdragon or Dimensity chipset is a reasonable configuration to evaluate at ₹18,999. Validate component costs, competitor offerings, and real-world performance before finalising the product.
