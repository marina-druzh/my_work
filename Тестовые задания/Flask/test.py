import pandas as pd
import datetime


def read_data():
    data = pd.read_csv("Data.csv")
    federal_district = pd.read_csv("Federal_District.csv")
    industry = pd.read_csv("Industry.csv")
    regions = pd.read_csv("Regions.csv")
    return data, federal_district, industry, regions


"""
1. Возвращать среднюю зарплату в разрере отрасли (Industry_ID) и 
выводить 3 отпрасли с наибольше средней зарплатой 
(взять для рассчёта среднее значение поля Salary).

{"id": 1, "name": "Отрасль 1", "value": 35000},  
  {"id": 41, "name": "Отрасль 2", "value": 25000},  
  {"id": 21, "name": "Отрасль 3", "value": 15000},
"""


# Фильтрация
def filter_data(data, graduation_year=None, region_id=None, age_from='0', age_to='100'):
    now = datetime.datetime.now()
    if region_id:
        try:
            region_id = list(map(int, region_id))
        except:
            return f'Ошибка в значении  Region_ID = {region_id}'

        data = data.loc[data['Region_ID'].isin(region_id)]
        if len(data) == 0:
            return f'Нет данных для Region_ID = {region_id}'

    if graduation_year:
        try:
            graduation_year = list(map(int, graduation_year))
        except:
            return f'Ошибка в значении  Graduation_Year = {graduation_year}'
        data = data[data['Graduation_Year'].isin(graduation_year)]
        if len(data) == 0:
            return f'Нет данных для Graduation_Year = {graduation_year}'

    if age_from.isdigit() and age_to.isdigit():
        data = data.loc[(now.year - data['Birthday'] <= int(age_to)) & (now.year - data['Birthday'] >= int(age_from))]
        if len(data) == 0:
            return f'Нет данных для значений возраста от {age_from} до {age_to}'
    else:
        return f'Ошибка в значении age_to = {age_to} или age_from ={age_from}'
    return data


def show_top_industries_salary(data, industry, graduation_year=None, region_id=None, age_from='0', age_to='100'):
    try:
        data = filter_data(data, graduation_year=graduation_year, region_id=region_id, age_from=age_from, age_to=age_to)
        if type(data) == str:
            return data

        mean_salary = data.groupby('Industry_ID').agg({'Salary': 'mean'}).sort_values(by='Salary',
                                                                                      ascending=False).reset_index()
        mean_salary.columns = ['Industry_ID', 'Salary_mean']
        mean_salary['Industry'] = mean_salary['Industry_ID'].apply(
            lambda x: ' '.join(industry.loc[industry['ID'] == x, 'Industry'].values))
        return mean_salary.head(3).to_json(orient='records')
    except Exception as e:
        return e


"""## 2. Рассчитывать распределение зарплат (поле Salary) 
по следующим диапазаонам:  
менее 10 000 [0.. 10000)  
10 000 - 15 000 руб [10000 ... 15000).  
15 000 - 30 000 руб. [15000 ... 30000)  
30 000 - 50 000 руб. [30000 ... 50000)  
50 000 - 80 000 руб. [50000 ... 80000)  
более 80 000 [80000 ... бесконечности)  

Для каждого диапазона необходимо рассчитать количество   
выпускников (Graduates_Amount) и их процент, от общего количества

Каждый метод должен принимать в качестве фильтра одно или 
несколько значений любого поля из таблицы 
Data (кроме Salary Graduates_Amount, Birthday)"

Реализовать фильтр AgeFrom и AgeTo (основываясь на поле Birthday)
"""

def show_graduates(data, graduation_year='', region_id='', age_from='0', age_to='100'):
    salary_range = [0, 10000, 15000, 30000, 50000, 80000]
    try:
        df = filter_data(data, graduation_year=graduation_year, region_id=region_id, age_from=age_from, age_to=age_to)
        if type(df) == str:
            return df
        all_graduates = int(df.agg({'Graduates_Amount': 'sum'}))
        df_select = pd.DataFrame()
        for i in range(len(salary_range)):
            if i == 0:
                df_select['salary_range'] = [f'{salary_range[0]}-{salary_range[1]}']
                df_select['graduates_amount'] = [int(df.loc[df['Salary'] < salary_range[1], 'Graduates_Amount'].sum())]
            elif i < (len(salary_range) - 1):
                df_select.loc[-1] = [f'{salary_range[i]}-{salary_range[i + 1]}', '']  # adding a row
                df_select.index = df_select.index + 1
                df_select.loc[
                    df_select['salary_range'] == f"{salary_range[i]}-{salary_range[i + 1]}", 'graduates_amount'] = [int(
                    df.loc[(df['Salary'] >= salary_range[i]) & (
                                df['Salary'] < salary_range[i + 1]), 'Graduates_Amount'].sum())]
            else:
                df_select.loc[-1] = [f'> {salary_range[i]}', '']
                df_select.index = df_select.index + 1
                df_select.loc[df_select['salary_range'] == f"> {salary_range[i]}", 'graduates_amount'] = [
                    int(df.loc[df['Salary'] >= salary_range[i], 'Graduates_Amount'].sum())]
        df_select['percentage'] = df_select['graduates_amount'] * 100 / all_graduates
        return df_select.reset_index(drop=True).to_json(orient='records')
    except Exception as e:
        print(e)


# data, federal_district, industry, regions = read_data()
# # now = datetime.datetime.now()
# # salary_range = [0, 10000, 15000, 30000, 50000, 80000]
# print(show_graduates(data, graduation_year='', region_id='45', age_from='0', age_to='100'))
