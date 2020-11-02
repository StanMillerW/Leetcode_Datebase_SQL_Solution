#generate month from Jan to Dec
WITH RECURSIVE temp_month AS(SELECT 1 AS month UNION ALL SELECT month+1 FROM temp_month WHERE month <= 11),
#calculate the number of active drivers for each month
active_drivers_table AS
(SELECT month, MAX(active_drivers) AS active_drivers
FROM
(SELECT month, 
    @active_drivers:=CAST(IF(month = MONTH(join_date),@active_drivers+1,@active_drivers)AS UNSIGNED) AS active_drivers
FROM
   (SELECT *, MONTH(join_date) AS join_month FROM Drivers WHERE join_date REGEXP '2020' ORDER BY join_date)a 
	 RIGHT JOIN temp_month ON a.join_month = temp_month.month, 
   (SELECT @active_drivers:= (SELECT COUNT(driver_id) AS pre_active_driver FROM Drivers 
     WHERE join_date < '2020-1-1')) temp)b 
GROUP BY  month),
#calculate the number of accepted rides for each month
accepted_rides AS
(SELECT DISTINCT month, COUNT(a.ride_id) AS accepted_rides
FROM
    AcceptedRides a INNER JOIN (SELECT *, MONTH(requested_at) AS request_month FROM Rides WHERE requested_at                                     REGEXP '2020' ORDER BY requested_at )r ON a.ride_id = r.ride_id 
                    RIGHT JOIN temp_month ON r.request_month= temp_month.month
GROUP BY month)
# merge the two tables above to generate the results
SELECT
a1.month, active_drivers,accepted_rides
FROM 
active_drivers_table a1 INNER JOIN accepted_rides a2 ON a1.month = a2.month