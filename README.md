# Smartphone Feature–Price Analysis

Exploratory data analysis and price modeling to identify smartphone specifications associated with pricing in India's sub-₹20,000 segment.

## 1. Business Problem

An Indian smartphone product manager is planning a new smartphone priced below ₹20,000.

The objective is to identify which smartphone specifications are associated with higher prices and rating scores, understand feature trade-offs, and recommend a competitive specification mix and target price.

**Primary business question:** Which smartphone features offer the strongest value in the ₹15,000–₹20,000 segment?

This analysis identifies associations in the dataset. It does not establish that individual features cause price or rating changes.

## 2. Dataset

- **Source:** Kaggle – Smartphone Models Dataset
- **File:** `smartphone_cleaned_v5.csv`
- **Original records:** 980
- **Records retained for analysis:** 973
- **Phones priced below ₹20,000:** 506

Seven model records were flagged for manual verification and excluded from the primary analysis. They were retained separately rather than conclusively labelled invalid.

### Data Cleaning

- Checked for duplicate rows and duplicate brand/model combinations.
- Standardised price categories into seven price bands.
- Handled missing fast-charging and expandable-storage values using their respective availability flags.
- Replaced missing processor-brand and operating-system labels with `Unknown`.
- Preserved unresolved numeric values as missing rather than inventing specifications.
- Did not impute missing rating scores because the rating scale and definition were unverified.

## 3. Exploratory Data Analysis

The following findings focus primarily on the ₹15,000–₹20,000 segment.

| Feature | Key Finding |
|---|---|
| RAM | Average rating score increases from 73.3 for 4GB RAM to 79.3 for 6GB and 81.4 for 8GB. |
| Storage | 128GB is the dominant configuration, with 140 rated records and an average rating score of 79.9. |
| 5G | 5G phones have a median price of ₹17,990 compared with ₹16,999 for non-5G phones. |
| Battery | 138 of 170 phones have a battery capacity of 5,000 mAh or higher. |
| Processor brand | Snapdragon and Dimensity have similar average rating scores: 79.4 and 79.1. |
| Processor speed | 2.0–2.49 GHz is the dominant category, representing 156 of 167 phones with known speeds. |
| Rear camera | The 100+ MP category has an average rating score of 82.6, compared with 79.4 for the 50–99 MP category. |

### Key Observations

- 8GB RAM appears to offer a modest rating-score improvement over 6GB, with only a small difference in median price.
- 128GB storage is the strongest practical baseline for the target segment.
- 5G is associated with an approximately ₹1,000 higher median price.
- A 5,000 mAh-class battery is common, but larger capacity does not show a clear rating-score advantage.
- Snapdragon and Dimensity appear similarly positioned in this segment.
- Higher camera megapixel categories are associated with higher rating scores, but megapixels alone do not establish camera quality.

**Data note:** RAM and storage group counts represent phones with non-missing ratings because those comparisons filtered out missing rating values. Other feature comparisons count phones with the relevant specification available.

## 4. Regression Analysis

A multiple linear regression model was developed to examine the relationship between smartphone specifications and prices below ₹20,000.

### Features Used

- RAM capacity
- Internal storage
- Battery capacity
- Processor speed
- Primary rear-camera megapixels
- Display refresh rate
- 5G availability
- Processor brand

### Methodology

- Training/testing split: 80% / 20%
- Training records: 404
- Testing records: 102
- Missing numeric values: Median imputation
- Processor brand: One-hot encoding
- Regression algorithm: Multiple Linear Regression

### Model Performance

| Metric | Result |
|---|---:|
| R² Score | 0.668 |
| Mean Absolute Error (MAE) | ₹1,871.54 |
| Root Mean Squared Error (RMSE) | ₹2,401.91 |
| Baseline MAE | ₹3,570.30 |

The model explains 66.8% of price variation in the test dataset. Its MAE is lower than the baseline MAE, indicating an improvement over simply predicting the average training price.

These results represent an initial model evaluation, not guaranteed future pricing accuracy.

## 5. Preliminary Product Recommendation

Based on the exploratory analysis and regression results, the following specification is proposed for a smartphone below ₹20,000.

| Component | Recommended Specification |
|---|---|
| RAM | 8GB |
| Internal Storage | 128GB |
| Connectivity | 5G |
| Battery | 5,000 mAh or higher |
| Processor | Snapdragon or Dimensity |
| Processor Speed | Prioritise overall chipset performance |
| Rear Camera | 50–99 MP baseline; evaluate 100+ MP options |
| Indicative Target Price | **₹18,999** |

This recommendation is a data-informed starting point. Component costs, chipset generation, camera sensor quality, software support, competitor pricing, and actual customer demand require further validation.

## 6. Limitations

1. The source rating field's meaning and scale are unverified. It is treated as a rating score, not confirmed customer satisfaction.
2. The analysis is observational and identifies associations rather than causal effects.
3. Megapixel count and processor clock speed do not independently measure real-world performance.
4. The regression uses one train-test split and a limited set of predictors.
5. The dataset's listed prices may differ from actual transaction prices.
6. Sales volume, customer demand, manufacturing costs, and competitor strategy are outside the scope of this analysis.
7. Small sample groups should be interpreted cautiously.

## 7. Tools and Technologies

- Python
- Pandas and NumPy
- Scikit-learn
- PostgreSQL
- Google Colab
- Git and GitHub

