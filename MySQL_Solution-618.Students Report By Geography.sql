SELECT 
    MAX(America) AS America,
    MAX(Asia) AS Asia,
    MAX(Europe) AS Europe
FROM
    (SELECT
        CASE continent 
        WHEN 'America' THEN name END America,
        CASE continent 
        WHEN 'Asia' THEN name END Asia,
        CASE continent 
        WHEN 'Europe' THEN name END Europe,
        ROW_NUMBER()OVER (PARTITION BY continent ORDER BY name ASC) as rank_num
    FROM
        student) a
GROUP BY 
    rank_num