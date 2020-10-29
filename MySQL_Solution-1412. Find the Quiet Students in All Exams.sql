
WITH reference AS
(SELECT
        *,
        RANK()OVER (PARTITION BY exam_id ORDER BY score ASC) AS rank_num_low,
        RANK()OVER (PARTITION BY exam_id ORDER BY score DESC) AS rank_num_high
    FROM
        exam )
SELECT
    *
FROM
    Student
WHERE 
    student_id IN (SELECT student_id FROM Exam)  # student who take exam
AND
    student_id NOT IN                            # student who are not quiet 
                    (SELECT
                        DISTINCT student_id
                    FROM
                        reference
                    WHERE rank_num_low =1
                    UNION
                    SELECT
                        DISTINCT student_id
                    FROM
                        reference
                    WHERE rank_num_high = 1)