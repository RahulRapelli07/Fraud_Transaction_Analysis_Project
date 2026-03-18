# 🔴 Fraud Transaction Analysis
### End-to-End Data Analytics Project | Python · MySQL · Power BI

![Python](https://img.shields.io/badge/Python-3.10-3776AB?style=for-the-badge&logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Pandas](https://img.shields.io/badge/Pandas-EDA-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-00FF9F?style=for-the-badge)

---

## 📌 Project Overview

This project performs a comprehensive end-to-end analysis of fraud transactions using real-world transactional data containing 10,000 records. The goal is to uncover patterns in fraudulent transactions, identify high-risk segments, and provide actionable business insights to help financial institutions detect and prevent fraud effectively.

Prepared by: Rahul
Tools Used: Python, MySQL, Power BI
Dataset: Fraud_Transaction_Analysis_Rawdataset.csv
Date: March 2026

---

## 🎯 Objectives

- Identify the overall fraud rate across all transactions
- Discover which transaction types, merchant categories, and countries have the highest fraud rates
- Analyse time-based fraud patterns to detect peak fraud hours
- Evaluate device and IP risk scores as fraud predictors
- Build an interactive Power BI dashboard for business stakeholders

---

## 🗃️ Dataset Summary

| Property | Value |
|---|---|
| Dataset Name | Fraud_Transaction_Analysis_Rawdataset.csv |
| Total Rows | 10,000 transactions |
| Total Columns | 10 columns |
| Fraud Records | 500 (5%) |
| Legitimate Records | 9,500 (95%) |
| Missing Values | None |
| Source | Synthetic fraud transaction dataset |

---

## 📋 Key Columns

| Column | Data Type | Description |
|---|---|---|
| transaction_id | int64 | Unique identifier for each transaction |
| user_id | int64 | Unique identifier for each user |
| amount | float64 | Transaction amount in USD |
| transaction_type | category | ATM / POS / Online / QR |
| merchant_category | category | Food / Travel / Electronics / Clothing / Grocery |
| country | category | US / UK / FR / DE / TR / NG |
| hour | int64 | Hour of day transaction occurred (0–23) |
| device_risk_score | float64 | Device risk score (0.0 – 1.0) |
| ip_risk_score | float64 | IP address risk score (0.0 – 1.0) |
| is_fraud | int64 | TARGET — 1 = Fraud, 0 = Legitimate |

---

## 🛠️ Tools & Workflow

Raw CSV → Excel (Manual EDA) → Python/Pandas (Cleaning) → MySQL (Storage) → SQL (Analysis) → Power BI (Dashboard)

| Phase | Tool | Output |
|---|---|---|
| Data Viewing | Microsoft Excel | Pivot tables, manual exploration |
| Data Cleaning & EDA | Python — Pandas, Jupyter | Clean dataset + 4 engineered features |
| Database Integration | MySQL + SQLAlchemy | 10,000 rows loaded into fraud_db |
| Business Analysis | SQL — MySQL Workbench | 9 business questions answered |
| Visualization | Power BI Desktop | Interactive dashboard with 10 visuals |

---

## 🧹 Phase 1 — Data Cleaning (Python)

The raw dataset was loaded using pandas and cleaned through the following steps:

Step 1 — Data Loading
Imported the dataset using pd.read_csv(). Confirmed shape of (10000, 10). Used df.head(10) to preview the first 10 rows and understand structure.

Step 2 — Inspection
Used df.dtypes to check column types and df.describe() for summary statistics. Identified object columns needing type conversion.

Step 3 — Null and Duplicate Check
df.isnull().sum() confirmed zero missing values across all 10 columns. df.drop_duplicates() found no duplicate rows.

Step 4 — Type Standardization
Converted transaction_type, merchant_category, and country from object to category dtype to optimize memory and speed up grouping. Fixed is_fraud and hour to int64, amount to float64.

Step 5 — Feature Engineering
Created 4 new columns to enhance analytical capability:

| New Column | Logic | Purpose |
|---|---|---|
| is_high_amount | amount > 1000 → 1 else 0 | Flag high-value transactions |
| is_night_txn | hour < 6 OR hour >= 22 → 1 | Flag nighttime transactions |
| is_high_risk | device > 0.7 AND ip > 0.7 → 1 | Flag dual high-risk transactions |
| amount_bucket | pd.cut() into 5 ranges | Group amounts for range analysis |

Step 6 — Export
Saved the cleaned DataFrame to fraud_cleaned.csv and loaded it into MySQL using df.to_sql() via SQLAlchemy.

---

## 🗄️ Phase 2 — MySQL Integration

After cleaning, the DataFrame was loaded into a MySQL database using SQLAlchemy. This enables full SQL-based business analysis.

| Parameter | Value |
|---|---|
| Username | root |
| Host | localhost |
| Port | 3306 |
| Database | fraud_db |
| Table | fraud_transactions |
| Rows Loaded | 10,000 |
| Method | df.to_sql() with chunksize=500 |
| if_exists | replace (drop and recreate) |

The database fraud_db was created automatically using CREATE DATABASE IF NOT EXISTS. The table was verified with SELECT returning all 14 columns including the 4 engineered features.

---

## 📊 Phase 3 — SQL Business Analysis

Nine structured business questions were answered using SQL queries run directly on the MySQL fraud_db database.

---

### Q1 — What is the overall fraud rate?

| total_transactions | fraud_count | fraud_rate_pct |
|---|---|---|
| 10,000 | 500 | 5.00% |

Insight: 5% of all transactions are fraudulent — 500 out of 10,000 total transactions.

---

### Q2 — How does the average transaction amount differ between fraud and legitimate?

| status | avg_amount | max_amount | min_amount | total_count |
|---|---|---|---|---|
| Legitimate | $100.28 | $277.20 | $1.00 | 9,500 |
| Fraud | $1,657.58 | $11,628.21 | $10.00 | 500 |

Insight: Fraud transactions average $1,657.58 — over 16x higher than legitimate ($100.28). Fraudsters consistently target high-value transactions.

---

### Q3 — Which hours of the day have the highest fraud activity?

| hour | total_transactions | fraud_count | fraud_rate_pct |
|---|---|---|---|
| 4 | 117 | 117 | 100.00% |
| 13 | 584 | 23 | 3.94% |
| 12 | 541 | 22 | 4.07% |
| 6 | 560 | 22 | 3.93% |
| 21 | 560 | 22 | 3.93% |

Insight: Hour 4 (4 AM) is a massive outlier — ALL 117 transactions at this hour are fraudulent. This is a critical alert window.

---

### Q4 — Are night-time transactions significantly more fraudulent than daytime?

| time_period | total_transactions | fraud_count | fraud_rate_pct |
|---|---|---|---|
| Night (10PM to 6AM) | 1,228 | 220 | 17.92% |
| Day (6AM to 10PM) | 8,772 | 280 | 3.19% |

Insight: Night transactions have a 17.92% fraud rate — more than 5x higher than daytime (3.19%). Stricter verification for night transactions would significantly reduce fraud.

---

### Q5 — Which countries have the highest fraud rate?

| country | total_transactions | fraud_count | fraud_rate_pct |
|---|---|---|---|
| NG — Nigeria | 100 | 100 | 100.00% |
| US — United States | 2,050 | 97 | 4.73% |
| UK — United Kingdom | 1,965 | 85 | 4.33% |
| TR — Turkey | 1,928 | 75 | 3.89% |
| FR — France | 2,027 | 74 | 3.65% |
| DE — Germany | 1,930 | 69 | 3.58% |

Insight: Nigeria (NG) has a 100% fraud rate — every single transaction from this country is fraudulent. Immediate geo-blocking or additional verification is strongly recommended.

---

### Q6 — Which transaction type has the most fraud?

| transaction_type | total_transactions | fraud_count | fraud_rate_pct |
|---|---|---|---|
| ATM | 2,529 | 138 | 5.46% |
| Online | 2,397 | 126 | 5.26% |
| QR | 2,506 | 120 | 4.79% |
| POS | 2,568 | 116 | 4.52% |

Insight: ATM transactions have the highest fraud count (138) and rate (5.46%). ATM channels should be prioritized for enhanced fraud detection.

---

### Q7 — Which merchant category attracts the most fraud?

| merchant_category | total_transactions | fraud_count | fraud_rate_pct |
|---|---|---|---|
| Clothing | 1,982 | 109 | 5.50% |
| Travel | 2,015 | 106 | 5.26% |
| Electronics | 2,007 | 98 | 4.88% |
| Grocery | 1,973 | 95 | 4.82% |
| Food | 2,023 | 92 | 4.55% |

Insight: Clothing (5.50%) and Travel (5.26%) have the highest fraud rates. High-value purchases in these categories should trigger additional verification.

---

### Q8 — How effective are device and IP risk scores at predicting fraud?

| status | avg_device_risk | avg_ip_risk | total_count |
|---|---|---|---|
| Fraud | 0.858 | 0.852 | 500 |
| Legitimate | 0.148 | 0.150 | 9,500 |

Insight: Fraud transactions score 0.858 on device risk and 0.852 on IP risk — nearly 5.8x higher than legitimate (0.148 / 0.150). Risk scores are highly reliable fraud predictors.

---

### Q9 — What is the fraud profile when both risk scores are high AND amount is over $1,000?

| country | merchant_category | transaction_type | confirmed_fraud | avg_amount | fraud_rate_pct |
|---|---|---|---|---|---|
| US | Electronics | QR | 8 | $2,654.02 | 100% |
| FR | Travel | ATM | 7 | $3,134.15 | 100% |
| UK | Clothing | QR | 6 | $2,143.01 | 100% |
| DE | Travel | ATM | 5 | $3,705.03 | 100% |
| TR | Clothing | ATM | 5 | $2,980.10 | 100% |

Insight: When both risk scores exceed 0.7 AND transaction amount exceeds $1,000, fraud rate is 100% across all combinations. These are the highest priority transactions for immediate fraud alerts.

---

## 📈 Phase 4 — Power BI Dashboard

The data was connected directly from the MySQL fraud_db database. Power Query Editor was used to apply final transformations — removing duplicates, blank rows, and errors before loading.

### DAX Measures Created

| Measure Name | Purpose |
|---|---|
| Fraud Rate % | Overall fraud percentage using DIVIDE |
| Total Fraud Count | CALCULATE with is_fraud = 1 filter |
| Avg Fraud Amount | CALCULATE with AVERAGE on fraud rows only |
| Legit Count | CALCULATE with is_fraud = 0 filter |
| Peak Fraud Hour | VAR-based formula returning formatted 04:00 |
| Avg Device Risk Fraud | CALCULATE with AVERAGE on device_risk_score |

### Dashboard Visuals Summary

| Visual | Type | Key Finding |
|---|---|---|
| Fraud Rate | KPI Card | 5.0% — 500 of 10,000 transactions |
| Avg Fraud Amount | KPI Card | $1,657.58 vs $100 for legitimate |
| Total Fraud Count | KPI Card | 500 confirmed fraud cases |
| Legitimate Transactions | KPI Card | 9,500 — 95% of total |
| Fraud Count by Hour | Line Chart | Massive spike at 4 AM — 117 cases |
| Fraud by Merchant Category | Bar Chart | Clothing highest (109), Food lowest (92) |
| Transactions by Channel | Clustered Bar | ATM leads fraud count at 138 |
| Fraud by Country | Bar Chart | NG = 100% fraud rate |
| Fraud by Amount Bucket | Donut Chart | Dollar 1K–5K = 51% of all fraud |
| Avg Device Risk Score | Gauge | 0.858 for fraud vs 0.148 for legitimate |

---

## 💡 Key Insights

| # | Insight | Evidence |
|---|---|---|
| 1 | 5% overall fraud rate | 500 fraud out of 10,000 transactions |
| 2 | Fraud amounts 16x higher | Avg $1,657.58 fraud vs $100.28 legit |
| 3 | 4 AM is 100% fraud hour | All 117 transactions at hour 4 are fraud |
| 4 | Night fraud rate 5.6x higher | 17.92% night vs 3.19% day fraud rate |
| 5 | Nigeria equals 100% fraud country | All 100 NG transactions are fraudulent |
| 6 | ATM most vulnerable channel | 5.46% rate — highest of all channels |
| 7 | Clothing most targeted category | 5.50% rate — highest merchant category |
| 8 | Risk scores highly predictive | 0.858 fraud vs 0.148 legit device risk |
| 9 | Dollar 1K–5K range is 51% of fraud | 255 out of 500 fraud in this bucket |
| 10 | High risk plus high amount equals 100% fraud | All multi-factor high-risk transactions are fraud |

---

## ✅ Business Recommendations

### Immediate Actions
- Block or flag all transactions from Nigeria — 100% fraud rate justifies automatic rejection or mandatory manual review
- Implement 100% two-factor authentication for all transactions between 10 PM and 6 AM — nighttime fraud rate is 17.92% vs 3.19% daytime
- Deploy real-time alert system for transactions at hour 4 (4 AM) — all 117 detected transactions were fraudulent

### Risk Score Thresholds
- Set automatic fraud alert when device_risk_score is above 0.7 AND ip_risk_score is above 0.7 — this combination yields 100% fraud confirmation
- Add secondary verification step when either risk score exceeds 0.5
- Integrate risk scoring into the real-time transaction approval pipeline

### Transaction Monitoring
- Add extra verification for ATM transactions — highest fraud count (138) and rate (5.46%) among all channels
- Flag all transactions exceeding $1,000 — 51% of all fraud occurs in the $1,000–$5,000 range
- Increase monitoring for Clothing and Travel merchant categories — highest fraud rates (5.50% and 5.26%)

### Long-term Fraud Prevention
- Build a machine learning model using device_risk_score, ip_risk_score, amount, hour, and country as features
- Implement customer loyalty programs to track behavioural patterns and detect anomalies
- Review discount and promotional policies that may attract fraudulent high-value purchases
- Conduct quarterly geographic risk reviews and update country-level blocking rules as fraud patterns evolve

---

## 📋 Project Summary

| Phase | Tool | Key Output |
|---|---|---|
| Data Viewing | Microsoft Excel | Initial exploration, pivot tables, column review |
| Data Cleaning and EDA | Python — Pandas | Clean dataset with 4 engineered features |
| Database Integration | MySQL + SQLAlchemy | 10,000 rows loaded into fraud_db |
| Business Analysis | SQL — MySQL Workbench | 9 business questions answered |
| Visualization | Power BI Desktop | Interactive dashboard with 10 visuals |
| Documentation | PDF + PPT Report | Full project documentation |

---

## 🏁 Conclusion

This project successfully demonstrated a complete data analytics pipeline — from raw CSV data to actionable business insights — using Python, MySQL, and Power BI.

The analysis of 10,000 transactions revealed a 5% fraud rate with clear, exploitable patterns: fraud is concentrated at 4 AM, originates disproportionately from Nigeria, targets high-value transactions in the $1,000–$5,000 range, and consistently shows elevated device and IP risk scores (0.858 vs 0.148 for legitimate transactions).

These findings provide a strong foundation for building automated fraud detection systems. By implementing the recommended risk score thresholds, geographic controls, and time-based verification — financial institutions can significantly reduce fraud exposure without impacting legitimate customer experience.

---

Made with Python · MySQL · Power BI
