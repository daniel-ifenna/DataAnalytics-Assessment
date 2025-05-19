SELECT 
    U.id AS customer_id,
    U.name,
    TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE()) AS tenure_months,
    COUNT(S.id) AS total_transactions,
    ROUND(((COUNT(S.id) / NULLIF(TIMESTAMPDIFF(MONTH, U.date_joined, CURDATE()), 0)) * 12 * AVG(S.confirmed_amount) * 0.001), 2) AS estimated_clv
FROM users_customuser U
JOIN savings_savingsaccount S ON U.id = S.owner_id
WHERE S.transaction_status = 'success'
GROUP BY U.id, U.name
ORDER BY estimated_clv DESC;
