USE employees_test_work;

SELECT  d.Industry_ID, 
        i.Industry, 
        AVG(d.Salary) AS avr_salary   
FROM data_ AS d
JOIN industry AS i  
WHERE d.Industry_ID = i.ID 
GROUP BY d.Industry_ID
ORDER BY  avr_salary desc limit 3


# Рассчитывать распределение зарплат (поле Salary) по следующим диапазаонам:
# менее 10 000 [0.. 10000)
# 10 000 - 15 000 руб [10000 ... 15000).
# 15 000 - 30 000 руб. [15000 ... 30000)
# 30 000 - 50 000 руб. [30000 ... 50000)
# 50 000 - 80 000 руб. [50000 ... 80000)
# более 80 000 [80000 ... бесконечности)
# Для каждого диапазона необходимо рассчитать количество выпускников (Graduates_Amount) и их процент, от общего количества

SELECT 
  salary_range,
  all_graduates,
  all_graduates/CNT*100 as Percentage
FROM 
(
SELECT
  sum(d1.Graduates_Amount) AS CNT
FROM
  data_ AS d1
) AS Total
JOIN 
(
SELECT 
  sum(d.Graduates_Amount) AS all_graduates,
  CASE 
       WHEN d.Salary BETWEEN 0 AND 10000 THEN '<10000' 
       WHEN d.Salary BETWEEN 10000 AND 15000 THEN '10000-15000' 
       WHEN d.Salary BETWEEN 15000 AND 30000 THEN '15000-30000'
       WHEN d.Salary BETWEEN 30000 AND 50000 THEN '30000-50000'
       WHEN d.Salary BETWEEN 50000 AND 80000 THEN '50000-80000'
       ELSE  '>80000'
 END AS salary_range 
FROM data_ AS d
GROUP BY salary_range) AS RangeTotals
ORDER BY  percentage  desc





