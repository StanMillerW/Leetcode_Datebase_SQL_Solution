WITH RECURSIVE temp AS 
(SELECT
	v.user_id,  v.visit_date, t.transaction_date, t.amount,
	COUNT(t.transaction_date) OVER(PARTITION BY v.user_id, v.visit_date ) as daily_trans_count
FROM
	Visits v LEFT JOIN Transactions t ON v.user_id = t.user_id AND v.visit_date = t.transaction_date),
temp2 AS 
(SELECT 0 AS n
UNION ALL  
SELECT n+1 FROM temp2 
WHERE n < (SELECT MAX(daily_trans_count) FROM temp))

SELECT
    temp2.n as transactions_count, IFNULL(t3.visits_count,0) as visits_count
FROM
    (SELECT
        t2.daily_trans_count as transactions_count, COUNT(t2. user_id) AS visits_count
    FROM
        (SELECT
            DISTINCT t1.user_id,t1.visit_date,t1.daily_trans_count
        FROM
            temp t1)t2
    GROUP BY 
        t2.daily_trans_count)t3
RIGHT JOIN 
    temp2 ON t3.transactions_count = temp2.n
ORDER BY 
    temp2.n
