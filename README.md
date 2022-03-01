# Cherry Blossom Peak Bloom Prediction
* Submission to George Mason’s Department of Statistics cherry blossom peak bloom prediction competition
* Authors: Julia Jeng, Fang Li, Julia Hsu
* Date: Feb. 28th, 2022

## Introduction
In this analysis, we demonstrate four methods of predicting the peak bloom data in the coming decade for all four locations required by the competition. The cherry trees' blossom development is dependent on weather conditions in winter or spring and species of growing degree. Especially, the trees will bloom highly affects by their growing degree days(GDD), which is a measurement based on the temperature degrees of the area where it is located and the certain threshold base temperature.  Therefore, we studied the GDD calculations of the different cherry trees species listed in each location. 

## Data
1. [Peak Bloom Date dataset](https://github.com/GMU-CherryBlossomCompetition/peak-bloom-prediction/tree/main/data) provided by George Mason’s Department of Statistics cherry blossom peak bloom prediction competition.
2. [Historical temperature and rainfall observations](https://psl.noaa.gov/data/gridded/data.cpc.globalprecip.html) are extracted from CPC Global Unified Gauge-Based Analysis.

| File | Description |
| ---- | ----------- |
| [Timeseeries_weather_*](https://github.com/JuliaHsu/peak-bloom-prediction/tree/main/data/processed_data/) | Temperature data of 4 locations |
| other | Visit [here](https://github.com/GMU-CherryBlossomCompetition/peak-bloom-prediction/tree/main/data) for more information about the dataset provided by the competetion |

## Folder Structure
| Folder | Description |
| ------ | ----------- |
| **src** |  The src folder contains all the source codes for the project. |
| **data**|The data folder contains orginal dataset and processed data used for the project. |
| [data/processed_data/](https://github.com/JuliaHsu/peak-bloom-prediction/tree/main/data/processed_data/) | Historical timeseries temperature dataset and processed bloom date dataset|
| [data/processed_data/features/](https://github.com/JuliaHsu/peak-bloom-prediction/tree/main/data/processed_data/features) | Extracted features for ML model training |
| [result/](https://github.com/JuliaHsu/peak-bloom-prediction/tree/main/result) | predictions of different models|

## Source Code
Source code are located in the /src folder. The key files are:

### Hierarchical Linear Regressions

| File | Description |
| ---- | ----------- |
| [cherry-blossom-hireachical_lm.r](https://github.com/JuliaHsu/peak-bloom-prediction/blob/main/src/hierarchical_linear_regression/cherry-blossom-hireachical_lm.r) | R scripts for Hierarchical Linear Regression model |
### Machine Learning Models

| File | Description |
| ---- | ----------- |
| [ML/feature_extraction.ipynb](https://github.com/JuliaHsu/peak-bloom-prediction/blob/main/src/ML/feature_extraction.ipynb) | Feature extraction codes for ML model training |
| [ML/ML_pred.ipynb](https://github.com/JuliaHsu/peak-bloom-prediction/blob/main/src/ML/ML_pred.ipynb) | Codes for ML model training and PBD prediction |

### Deep Learning - LSTM 
| File | Description |
| ---- | ----------- |
| [deep_learning/LSTM_predict10years.py](https://github.com/JuliaHsu/peak-bloom-prediction/blob/main/src/deep_learning/LSTM_predict10years.py)| LSTM model for PBD predictions |

## Evaluation
|                                       | Mean absolute error | Mean squared error | 
| --------------------------------------| --------------------| -------------------|
| Hierarchical Linear Regressions       | 0.002               | 0.000004           |
| Support Vector Regression             | 3.628               | 24.094             |
| LSTM                                  | 10.739              | 16.416             |

## Predictions (using Hierarchical Linear Regressions)
| Year | Kyoto | Liestal       | Washington DC | Vancouver |
| -----| ----- | ------------- | ------------- | --------- |
| 2022 | 92    | 95            | 91            | 96        |
| 2023 | 101   | 115           | 86            | 88        |
| 2024 | 99    | 113           | 87            | 86        |
| 2025 | 100   | 112           | 91            | 89        |           
| 2026 | 100   | 113           | 88            | 88        |
| 2027 | 100   | 112           | 88            | 87        |
| 2028 | 101   | 113           | 92            | 89        |
| 2029 | 99    | 113           | 89            | 89        |
| 2030 | 100   | 111           | 85            | 89        | 
| 2031 | 102   | 115           | 86            | 89        |

The submission results for this competition is [result/submission_predictions.csv](https://github.com/JuliaHsu/peak-bloom-prediction/blob/main/result/submission_predictions.csv)








