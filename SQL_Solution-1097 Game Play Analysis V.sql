WITH temp AS
(SELECT player_id, MIN(event_date) AS install_date
 FROM Activity
 GROUP BY player_id)
 
SELECT 
    install_dt, installs, 
    ROUND(IFNULL(return_number,0)/installs,2) AS Day1_retention
FROM
    (SELECT install_date AS install_dt, COUNT(player_id) AS installs
     FROM temp
     GROUP BY install_date)a
    LEFT JOIN 
    (SELECT install_date, COUNT(IFNULL(temp.player_id,0)) AS return_number
    FROM temp RIGHT JOIN Activity a2 ON temp.player_id = a2. player_id 
    AND DATE_ADD(temp.install_date, INTERVAL 1 DAY) = a2.event_date
    GROUP BY install_date) b 
ON a.install_dt = b.install_date
ORDER BY install_dt
