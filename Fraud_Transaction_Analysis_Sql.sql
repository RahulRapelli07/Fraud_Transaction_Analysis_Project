Show databases;
use fraud_db;
show tables;
select * from fraud_transactions limit 20;

# Q1. What is the overall fraud rate in the dataset?
select 
    count(*) AS total_transactions,
    sum(is_fraud) AS fraud_count,
    Round(100 * sum(is_fraud) / count(*),2) AS Fraud_rate_pct
from fraud_transactions;
	
# Q2. How does the average transaction amount differ between fraud and legitimate transactions?
select 
   case when is_fraud = 1 then 'fraud' else 'legimate' end as Transaction_status,
   round(avg(amount),2) as Average_amount,
   round(max(amount),2) as Maximum_amount,
   round(min(amount),2) as minimum_amount,
   count(*) as total_count
from fraud_transactions
group by is_fraud;

# Q3. Which hours of the day have the highest fraud activity?
select
    hour,
    count(*) as total_transactions,
    sum(is_fraud) as fraud_count,
    round(100 * sum(is_fraud) / count(*),2) as fraud_rate_pct
from fraud_transactions
group by hour
order by fraud_count desc
limit 5;

# Q4. Are night-time transactions significantly more fraudulent than daytime ones?
select
     case when is_night_txn = 1 then 'Night(10pm to 6am)' else 'Day(6am to 10pm)' end as time_period,
     count(*) as total_transactions,
     sum(is_fraud) as fraud_count,
     round(100 * sum(is_fraud) / count(*),2) as fraud_rate_pct
from fraud_transactions
group by is_night_txn
order by fraud_count desc;

# Q5. Which countries have the highest fraud rate?
select
    country,
    count(*) as total_transactions,
    sum(is_fraud) as fraud_count,
    round(100 * sum(is_fraud) / count(*),2) as fraud_rate_pct
from fraud_transactions
group by country
order by fraud_count desc;

# Q6. Which transaction type (ATM, POS, Online, QR) has the most fraud?
select
    transaction_type,
    count(*) as total_transactions,
    sum(is_fraud) as fraud_count,
    round(100 * sum(is_fraud) / count(*),2) as fraud_rate_pct
from fraud_transactions
group by transaction_type
order by fraud_count desc;

# Q7. Which merchant category attracts the most fraud?
select
    merchant_category,
    count(*) as total_transactions,
    sum(is_fraud) as fraud_count,
    round(100 * sum(is_fraud) / count(*),2) as fraud_rate_pct
from fraud_transactions
group by merchant_category
order by fraud_count desc;

# Q8. How effective are device and IP risk scores at predicting fraud?
select
    case when is_fraud = 1 then 'fraud' else 'legimate' end as Status,
    round(avg(device_risk_score),3) as average_device_risk,
    round(avg(ip_risk_score),3) as average_ip_risk,
    count(*) as total_count
from fraud_transactions
group by is_fraud;

# Q9. What is the fraud profile when BOTH risk scores are high AND the amount is over $1,000?
select
     country,
     merchant_category,
     transaction_type,
     count(*) as high_risk_txns,
     round(avg(amount),2) as average_amount,
     sum(is_fraud) as confirmed_fraud,
     round(100 * sum(is_fraud) / count(*),2) as fraud_rate_pct
from fraud_transactions
where
     device_risk_score > 0.7 and
     ip_risk_score > 0.7 and
     amount > 1000
group by country,merchant_category,transaction_type
order by confirmed_fraud desc
limit 10;