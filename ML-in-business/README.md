# ML-in-business

python-flask
Итоговый проект курса "Машинное обучение в бизнесе"

Стек:

ML: sklearn, pandas, numpy, API: flask  

Данные: данные первичного медицинского осмотра

Задача: определить вероятность наличия сердечно-сосудистых заболеваний (поле cardio). Бинарная классификация

Используемые признаки:

age (int64)
gender (int64)
height (int64)
weight (float64)
ap_hi (int64)
ap_lo (int64)
cholesterol (int64)
gluc (int64)
smoke (int64)
alco (int64)
active (int64)
Преобразования признаков: StandardScaler, OHEEncoderBin

Модель: CatBoost

## Описание:
Аналитика и очистка данных приведена в ноутбуке - course_project_ml_in_business_ipynb__.ipynb  
Серверная часть - run_server.py  
Проверка - PY Client POST.ipynb  

Клонировать репозиторий:  

$ git clone https://github.com/marina-druzh/ML-in-business.git
