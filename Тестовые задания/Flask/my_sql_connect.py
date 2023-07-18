from getpass import getpass
from mysql.connector import connect, Error
import pandas as pd

select_top_industry_query = """
SELECT  d.Industry_ID,
        i.Industry,
        ROUND(AVG(d.Salary)) AS avr_salary
FROM data_ AS d
JOIN industry AS i
WHERE d.Industry_ID = i.ID
GROUP BY d.Industry_ID
ORDER BY  avr_salary desc
limit 3
"""

salary_range_query = """
SELECT 
  salary_range,
  all_graduates,
  ROUND(all_graduates/CNT*100, 2) as Percentage
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
"""

try:
    with connect(
        host="localhost",
        user='root',  # input("Имя пользователя: "),
        password='***',  # getpass("Пароль: "),
        database="employees_test_work",
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute(select_top_industry_query)
            for industry in cursor.fetchall():
                print(industry)
            print('*'*100, '\n')
        with connection.cursor() as cursor:
            cursor.execute(salary_range_query)
            for row in cursor.fetchall():
                print(row)
except Error as e:
    print(e)

# read rows from DB into Pandas DataFrame
connection = connect(
        host="localhost",
        user='root',  # input("Имя пользователя: "),
        password='***',  # getpass("Пароль: "),
        database="employees_test_work",
    )
engine = connection
df = pd.read_sql(salary_range_query, engine)

# export/write DataFrame to JSON file
df.to_json(r'db_export.json', orient='records', force_ascii=False)

