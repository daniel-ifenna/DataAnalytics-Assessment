WITH monthly_transactions AS (
    SELECT 
        owner_id,
        YEAR(transaction_date) AS txn_year,
        MONTH(transaction_date) AS txn_month,
        COUNT(*) AS monthly_txn_count
    FROM savings_savingsaccount
    WHERE transaction_status = 'success'
    GROUP BY owner_id, YEAR(transaction_date), MONTH(transaction_date)
),

avg_txn_per_user AS (
    SELECT 
        owner_id,
        AVG(monthly_txn_count) AS avg_txns_per_month
    FROM monthly_transactions
    GROUP BY owner_id
),

categorized_users AS (
    SELECT 
        owner_id,
        avg_txns_per_month,
        CASE 
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM avg_txn_per_user
)

SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category
ORDER BY 
    CASE frequency_category
        WHEN 'High Frequency' THEN 1
        WHEN 'Medium Frequency' THEN 2
        ELSE 3
    END;
