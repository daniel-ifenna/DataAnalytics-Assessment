Select *
from plans_plan;

SELECT *
FROM savings_savingsaccount;

SELECT *
FROM users_customuser;
UPDATE users_customuser
SET `name`= CONCAT(first_name, ' ', last_name);

-- checking for duplicates--
WITH DUPLICATED AS(
	SELECT *,
    ROW_NUMBER()OVER(PARTITION BY id, first_name, last_name, phone_number, date_of_birth  ORDER BY id) AS Count_duplicate
	FROM users_customuser)
    SELECT *
    FROM DUPLICATED
    WHERE count_duplicate > 1;

WITH DUPLICATED AS(
	SELECT *,
    ROW_NUMBER()OVER(PARTITION BY id, savings_id, last_name, transaction_date  ORDER BY id) AS Count_duplicate
	FROM savings_savingsaccount)
    SELECT *
    FROM DUPLICATED
    WHERE count_duplicate > 1;
    
SELECT 
  U.id AS owner_id,
  U.name,
  S.Savings_count,
  I.Investment_count,
  S.Total_deposit
FROM users_customuser U

JOIN (
    SELECT 
        owner_id, 
        COUNT(is_a_fund = 1) AS Investment_count
    FROM plans_plan
    WHERE is_goal_achieved > 0 
    GROUP BY owner_id
) I ON U.id = I.owner_id

JOIN (
    SELECT 
        owner_id, 
        COUNT(*) AS Savings_count,
        SUM(confirmed_amount) AS Total_deposit
    FROM savings_savingsaccount
    WHERE transaction_status = 'success' AND confirmed_amount > 0
    GROUP BY owner_id
) S ON U.id = S.owner_id

WHERE 
  I.Investment_count > 0 AND 
  S.Savings_count > 0

ORDER BY S.Total_deposit DESC;
