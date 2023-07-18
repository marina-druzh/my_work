from flask import Flask
from flask import request
import pandas as pd
from test import show_top_industries_salary, show_graduates  # read_data


def read_data():
    data = pd.read_csv("Data.csv")
    federal_district = pd.read_csv("Federal_District.csv")
    industry = pd.read_csv("Industry.csv")
    regions = pd.read_csv("Regions.csv")
    return data, federal_district, industry, regions

data, federal_district, industry, regions = read_data()


app = Flask(__name__)


@app.route("/")
def root():
    return '<h1>Hello</h1>'


@app.route("/api/widgets/WidgetName1")
def show_graduates_salary():
    # graduation_year = request.args.get('GraduationYear', default='')
    # region_id = request.args.get('Region_ID', default='')
    graduation_year = request.args.getlist('GraduationYear')
    region_id = request.args.getlist('Region_ID')
    age_from = request.args.get('AgeFrom', default='0')
    age_to = request.args.get('AgeTo', default='100')
    df_salary = show_graduates(data, region_id=region_id,
                               graduation_year=graduation_year,
                               age_from=age_from, age_to=age_to)
    return df_salary


@app.route("/api/widgets/WidgetName2")
def show_mean_top_industries_salary():
    # graduation_year = request.args.get('GraduationYear', default='')
    # region_id = request.args.get('Region_ID', default='')
    age_from = request.args.get('AgeFrom', default='0')
    age_to = request.args.get('AgeTo', default='100')
    graduation_year = request.args.getlist('GraduationYear')
    region_id = request.args.getlist('Region_ID')

    df_salary = show_top_industries_salary(data, industry, region_id=region_id,
                                           graduation_year=graduation_year,
                                           age_from=age_from, age_to=age_to)
    return df_salary


if __name__ == "__main__":
    app.run()
