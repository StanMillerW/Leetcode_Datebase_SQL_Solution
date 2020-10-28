SELECT
    item_category AS Category,
    SUM(IF(WEEKDAY(order_date)=0,quantity,0)) AS Monday,
    SUM(IF(WEEKDAY(order_date)=1,quantity,0)) AS Tuesday,
    SUM(IF(WEEKDAY(order_date)=2,quantity,0)) AS Wednesday,
    SUM(IF(WEEKDAY(order_date)=3,quantity,0)) AS Thursday,
    SUM(IF(WEEKDAY(order_date)=4,quantity,0)) AS Friday,
    SUM(IF(WEEKDAY(order_date)=5,quantity,0)) AS Saturday,
    SUM(IF(WEEKDAY(order_date)=6,quantity,0)) AS Sunday
FROM
    Orders o RIGHT JOIN Items i ON o.item_id = i.item_id
GROUP BY 
    i.item_category
ORDER BY 
    i.item_category ASC