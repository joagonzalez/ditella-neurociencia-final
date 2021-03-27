import csv
import numpy as np
from statistics import mean
from scipy import stats
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
import pandas as pd
from sklearn import linear_model
import statsmodels.api as sm


# TODO: Histogramas para las 5 variables a estudiar
# TODO: Separar informacion por dilema (5 en total con 3 respuestas cada uno)
# TODO: Calcular perfiles de personas segun indice oxford

class Final():
    '''
    Clase que modela la resolución del final de la materia Neurociencia y Toma de Decisiones
    '''

    DIR = '/home/jgonzalez/dev/ditella-neurociencia-final/data/'
    FILENAME = 'data_Study2.csv'
    SAVE_PLOT_AS_FILE = True

    
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

            self.age = [ int(x[29]) for x in data['rows'] ]
            self.sex = [ int(x[30]) for x in data['rows'] ]
            self.ethnicity = [ int(x[31]) for x in data['rows'] ]
            self.education = [ int(x[32]) for x in data['rows'] ]
            self.party = [ int(x[33]) for x in data['rows'] ]
            # Se normaliza OUS a un valor entre [1-7]
            self.oxford = [mean([int(x[19]) , int(x[20]) , int(x[21]) ,
                                    int(x[22]) , int(x[23]) , int(x[24]) ,
                                    int(x[25]) , int(x[26]) , int(x[27])]) for x in data['rows']]

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

        print('Generating charts....')
        # sexo
        labels = ['mujer', 'hombre']
        sizes = [0, 0]

        for element in self.sex:
            if element == 1:
                sizes[0] += 1
            else:
                sizes[1] += 1

        self.plot_charts('sexo', labels, sizes)

        # etnia
        labels = ['black', 'white', 'hispanic', 'asian', 'other']
        sizes = [0, 0, 0, 0, 0]

        for element in self.ethnicity:
            if element == 0:
                sizes[0] += 1
            elif element == 1:
                sizes[1] += 1
            elif element == 2:
                sizes[2] += 1
            elif element == 3:
                sizes[3] += 1
            else:
                sizes[4] += 1

        self.plot_charts('etnia', labels, sizes)

        # partido politico
        labels = ['Trump', 'Biden', 'None']
        sizes = [0, 0, 0]

        for element in self.party:
            if element == 0:
                sizes[0] += 1
            elif element == 1:
                sizes[1] += 1
            else:
                sizes[2] += 1

        self.plot_charts('partido', labels, sizes)

        # educacion
        labels = ['Secundaria Incompleta', 'Universidad incompleta', 'Universidad completa o +']
        sizes = [0, 0, 0]

        for element in self.education:
            if element == 0:
                sizes[0] += 1
            elif element == 1:
                sizes[1] += 1
            else:
                sizes[2] += 1

        self.plot_charts('educacion', labels, sizes)

        print('Calculating linear regression....')
        self.linear_regression()

    def plot_charts(self, subject, labels, sizes):
        fig1, ax1 = plt.subplots()
        ax1.pie(sizes, labels=labels, autopct='%1.1f%%',
                shadow=True, startangle=90)
        ax1.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle.
        
        if self.SAVE_PLOT_AS_FILE:
            image_name = f'../results/{subject}.png'
            plt.savefig(image_name)
        
        plt.show()       


    def calculate_statistical(self, var, array):
        if var not in self.results:
            self.results[var] = {}
            self.results[var]['mean'] = 0
            self.results[var]['std'] = 0

        self.results[var]['mean'] = np.mean(np.array(array))
        self.results[var]['std'] = np.std(np.array(array))


    def linear_regression(self):
        data = {
            'sex': self.sex,
            'education': self.education,
            'ethnicity': self.ethnicity,
            'age': self.age,
            'ous': self.oxford
        }

        df = pd.DataFrame(data ,columns=['sex','education','ethnicity','age','ous'])

        X = df[['sex','education','ethnicity','age']] # 4 variables para la regresion
        Y = df['ous']
        
        # with sklearn
        regr = linear_model.LinearRegression()
        regr.fit(X, Y)

        print('Intercept: \n', regr.intercept_)
        print('Coefficients: \n', regr.coef_)

        # prediction with sklearn
        # New_Interest_Rate = 2.75
        # New_Unemployment_Rate = 5.3
        # print ('Predicted Stock Index Price: \n', regr.predict([[New_Interest_Rate ,New_Unemployment_Rate]]))

        # with statsmodels
        X = sm.add_constant(X) # adding a constant
        
        model = sm.OLS(Y, X).fit()
        predictions = model.predict(X) 
        
        print_model = model.summary()
        print(print_model)

    def get_oxford(self):
        return self.oxford


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
    # app.get_data()
    print(f'Age: {app.get_age()}')
    print(f'Sex: {app.get_sex()}')
    print(f'Ethnic: {app.get_ethnicity()}')
    print(f'Education: {app.get_education()}')
    print(f'Party: {app.get_party()}')
    print(f'OUS: {app.get_oxford()}')
    print(f'Results: {app.get_results()}')
    #app.linear_regression()

    