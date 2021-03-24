# ditella-neurociencia-final
Trabajo practico final de la materia Neurociencia y Toma de Decisiones de la maestría MiM+Analytics

Tema: Dilemas Morales
Un dilema moral es una situación en la que se debe tomar una decisión difícil, entre dos o más cursos de acción, cualquiera de los cuales involucra transgredir un principio moral de la persona.

Preguntas:
- Que relación hay entre confianza/aceptabilidad y confianza/distress en distintos escenarios morales. Es siempre la misma relación?

- Existe correlación entre las opiniones morales en respuestas a distintos escenarios morales? Es siempre la misma relación?

- Hay una correlación entre partidos políticos (democratas/republicanos) y grupos de opiniones morales?


Estructura Trabajo:
- Introducción
    - Preguntas a responder
    - Seccion descripción dataset
        - sex 0=male 1=female
        - age 
        - ethnicity
        - level of education
        - elections candidate

- Métodos
    Distribuciones, histogramas y test estadisticos aplicados para correlacionar datos.

- Resultados
    - Output del procesamiento

- Discusión
- Bibliografía
    - Paper de Joaquin Navajas (https://osf.io/mwe9r/)

Conceptos: 
- Deontologismo
- Utilitarismo


### Dataset 

```
age = data(:,30);
sex = data(:,31); % 1: male, 0: female
eth = data(:,32); % 0: black, 1: white, 2: hispanic, 3: asian, 4: other
edu = data(:,33); % 0: less than high-school, 1: less than complete college, 2: at least complete college
vot = data(:,34); % 0: Trump, 1: Biden, 2: None
OUS = data(:,20:28); % Oxford Utilitarianism Scale
IH = sum(OUS(:,[1,2,3,8]),2); % Instrumental Harm
IB = sum(OUS(:,[4:7,9]),2); % Impartial Beneficence
```