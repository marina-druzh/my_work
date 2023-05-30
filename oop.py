'''
4. Начните работу над проектом «Склад оргтехники». Создайте класс, описывающий склад.
А также класс «Оргтехника», который будет базовым для классов-наследников.
Эти классы — конкретные типы оргтехники (принтер, сканер, ксерокс).
В базовом классе определить параметры, общие для приведенных типов. В классах-наследниках реализовать
параметры, уникальные для каждого типа оргтехники.
5. Продолжить работу над первым заданием. Разработать методы, отвечающие за приём оргтехники на
склад и передачу в определенное подразделение компании. Для хранения данных о наименовании и
количестве единиц оргтехники, а также других данных, можно использовать любую подходящую
структуру, например словарь.
6. Продолжить работу над вторым заданием. Реализуйте механизм валидации вводимых
пользователем данных. Например, для указания количества принтеров, отправленных на склад,
нельзя использовать строковый тип данных.

'''


# class MyException(Exception):
#     def __init__(self, txt):
#         self.txt = txt


class OfficeEqStore:

    my_store = {
        1: {'модель': [], 'цена': [], 'количество': [], 'цвет': []},
        2: {'модель': [], 'цена': [], 'количество': [], 'тип': []},
        3: {'модель': [], 'цена': [], 'количество': [], 'тип': []}
    }

    '''  Место на складе - идея на этапе разработки
        def __init__(self, place):
            self.place = place
    '''

    def add(self):
        inp = input('Хотите добавить товар на склад?\nДля выхода из программы нажмите "Q", для продолжения "Enter": ')
        if inp.upper() != 'Q':
            return OfficeEqStore.reception(OrgTech.add(0))
        else:
            return OfficeEqStore.my_store

    @staticmethod
    def reception(*unit):
        try:
            for unit in [*unit]:
                # data = unit.__dict__['unit']
                data = unit.unit
                i = 1
                add_dict = OfficeEqStore.my_store.get(data[0])
                for k in add_dict:
                    # OfficeEqStore.my_store.get(data[0])[k].append(int(data[i]) if k == 'цена' or k == 'количество' else data[i])
                    if k == 'цена':
                        OfficeEqStore.my_store.get(data[0])[k].append(float(data[i]))
                    elif k == 'количество':
                        OfficeEqStore.my_store.get(data[0])[k].append(int(data[i]))
                    else:
                        OfficeEqStore.my_store.get(data[0])[k].append(data[i])
                    i += 1
            if input('Товар успешно добавлен!\nЕсли хотите добавить еще, нажмите "Enter", для выхода - любую клавишу: ') == '':
                return OfficeEqStore.add(0)
            else:
                return OfficeEqStore.my_store
        except AttributeError:
            print('Ничего не вышло...\nСледуйте инструкциям при вводе данных')

    def make_order(self):
        pass


class OrgTech:
    def __init__(self, model, price, quantity, id):
        self.model = model
        self.price = float(price)
        self.quantity = int(quantity)
        self.id = id

    def add(self):
        my_org = {1: Printer, 2: Scanner, 3: Copier}
        try:
            id = int(input('Для добавления принтера введите "1", сканера = "2", копира - "3" '))
            if id > len(my_org.keys()):
                raise print('ERROR')
            model = input('Введите модель: ')
            price = float(input('Введите цену (число): '))
            quantity = int(input('Введите количество единиц товара (целое число): '))
        except (ValueError, TypeError):
            return f'Ошибка ввода данных'
        return my_org.get(id).add_unit(0, model, price, quantity)


class Printer(OrgTech):
    def __init__(self, model, price, quantity, color, id=1):
        super().__init__(model, price, quantity, id)
        self.color = color
        self.unit = (self.id, self.model, self.price, self.quantity, self.color)

    def add_unit(self, model, price, quantity):
        color = input('Введите цвет печати принтера: ')
        return Printer(model, price, quantity, color)

    def __str__(self):
        return f'Принтер:\nМодель устройства: {self.model}\n' \
               f'Цена за ед: {self.price}\nКоличество: {self.quantity}\nЦвет: {self.color}'


class Scanner(OrgTech):
    def __init__(self, model, price, quantity, type, id=2):
        super().__init__(model, price, quantity, id)
        self.type = type
        self.unit = (self.id, self.model, self.price, self.quantity, self.type)

    def add_unit(self, model, price, quantity):
        type = input('Введите тип сканера: ')
        return Scanner(model, price, quantity, type)

    def __str__(self, ):
        return f'Сканер:\nМодель устройства: {self.model}\n' \
               f'Цена за ед: {self.price}\nКоличество: {self.quantity}\nЦвет: {self.type}'


class Copier(OrgTech):
    def __init__(self, model, price, quantity, type, id=3):
        super().__init__(model, price, quantity, id)
        self.type = type
        self.unit = (self.id, self.model, self.price, self.quantity, self.type)

    def add_unit(self, model, price, quantity):
        type = input('Введите тип копира: ')
        return Copier(model, price, quantity, type)

    def __str__(self):
        return f'Копир:\nМодель устройства: {self.model}\n' \
               f'Цена за ед: {self.price}\nКоличество: {self.quantity}\nЦвет: {self.type}'


""" Тест программы"""


def my_print(b):
    org = {1: 'printer', 2: 'scanner', 3: 'copier'}
    for k, v in b.items():
        if isinstance(v, dict):
            print(org.get(k))
            my_print(v)
        else:
            print(f'{k[:15]:>20}: {v}')
    print("*" * 30)


print_1 = Printer('hp', 5000, 5, 'ч/б')
print_2 = Printer('hp', 6000, 2, 'цветной')
unit_2 = Scanner('Canon', 4500, 5, 'fhh')
unit_3 = Copier('Xerox', 8000, 1, 'ggg')

store = OfficeEqStore.reception(print_1, print_2, unit_2, unit_3)

try:
    my_print(store)
except AttributeError:
    print('Для того, что напечатать склад надо завершить работу успешным добавлением товара на склад')






