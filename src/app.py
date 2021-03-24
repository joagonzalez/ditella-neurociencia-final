import csv
import numpy as np
from scipy import stats
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator

# TODO: Histogramas para las 5 variables a estudiar
# TODO: Separar informacion por dilema (5 en total con 3 respuestas cada uno)
# TODO: Calcular perfiles de personas segun indice oxford

class Final():
    '''
    Clase que modela la resolución del final de la materia Neurociencia y Toma de Decisiones
    '''

    DIR = '/home/jgonzalez/dev/ditella-neurociencia-final/data/'
    FILENAME = 'data_Study2.csv'

    
    def __init__(self):
        self.data = self.load_data(self.DIR, self.FILENAME)
        self.results = {}


    def __str__(self):
        return str(self.data)


    def load_data(self, dir, filename):
        '''
        Carga de datos de archivos .csv
        '''
        data = {}
        data['columns'] = []
        data['rows'] = []

        with open(f'{dir}{filename}') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=',')
            
            line_count = 0
            for row in csv_reader:
                if line_count == 0:
                    for column in row:
                        data['columns'].append(column)
                    line_count += 1
                else:
                    data['rows'].append(row)
                    line_count += 1

            self.age = np.array([ int(x[29]) for x in data['rows'] ])
            self.sex = np.array([ int(x[30]) for x in data['rows'] ])
            self.ethnicity = np.array([ int(x[31]) for x in data['rows'] ])
            self.education = np.array([ int(x[32]) for x in data['rows'] ])
            self.party = np.array([ int(x[33]) for x in data['rows'] ])
            
            return data


    def get_data(self):
        '''
        Se imprimen los datos obtenidos del archivo .csv
        '''
        print('Columns....')
        for column in self.data['columns']:
            print(f'{column}')
        print('Data....')
        for row in self.data['rows']:
            print(f'\t{row}')


    def data_analysis(self):
        self.calculate_statistical('age', self.age)
        self.calculate_statistical('sex', self.sex)
        self.calculate_statistical('ethnicity', self.ethnicity)
        self.calculate_statistical('education', self.education)
        self.calculate_statistical('party', self.party)


    def calculate_statistical(self, var, array):
        if var not in self.results:
            self.results[var] = {}
            self.results[var]['mean'] = 0
            self.results[var]['std'] = 0

        self.results[var]['mean'] = np.mean(array)
        self.results[var]['std'] = np.std(array)


    def get_age(self):
        return self.age


    def get_sex(self):
        return self.sex


    def get_ethnicity(self):
        return self.ethnicity


    def get_education(self):
        return self.education


    def get_party(self):
        return self.party

    def get_results(self):
        self.data_analysis()
        return self.results


if __name__ == '__main__':
    app = Final()
    # print(app)
    app.get_data()
    print(app.get_age())
    print(app.get_sex())
    print(app.get_ethnicity())
    print(app.get_education())
    print(app.get_party())
    print(app.get_results())
    
