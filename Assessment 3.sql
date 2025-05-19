SELECT 
    id AS plan_id,
    owner_id,
    'Savings' AS type,
    MAX(transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(transaction_date)) AS inactivity_days
FROM savings_savingsaccount
WHERE transaction_status = 'success'
GROUP BY id, owner_id
HAVING DATEDIFF(CURDATE(), MAX(transaction_date)) > 365

UNION

SELECT 
    id AS plan_id,
    owner_id,
    'Investment' AS type,
    MAX(last_charge_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(last_charge_date)) AS inactivity_days
FROM plans_plan
WHERE status_id = 1  
GROUP BY id, owner_id
HAVING DATEDIFF(CURDATE(), MAX(last_charge_date)) > 365;
