%% Loads all variables 

% This .m file loads to the Workspace all variables needed to reproduce the
% analysis and main figures in Navajas et al., Utilitarian Reasoning About
% Moral Problems of the COVID-19 Crisis.

%% Read Data from Excel file
clear;close all;clc
A = importdata('data.xlsx');

%% Define all variables
data = A.data;
country=data(:,36); % country code, see README.txt for definition
j_accept = [1:3:19]; % columns with acceptability judgements
j_conf  = [2:3:20]; % columns with confidence judgements
j_dist = [3:3:21]; % columns with distress judgements
accept = data(:,j_accept); % acceptability judgements
accept(accept<-100)=NaN; % missing values (-999) re-coded to NaNs
conf = data(:,j_conf); % confidence judgements
conf(conf<-100)=NaN; % missing values (-999) re-coded to NaNs
dist = data(:,j_dist); % distress judgements
dist(dist<-100)=NaN; % missing values (-999) re-coded to NaNs
Ns = size(data,1); % Number of subjects
OUS_items = data(:,24:32); % Items of the Oxford Utilitarianism Scale
IB = sum(OUS_items(:,1:5),2); % Impartial Beneficence Score
IH = sum(OUS_items(:,6:9),2); % Instrumental Harm Score
covid=data(:,37); % Personal closeness to COVID
cond = data(:,23); % Trolley Dilemma Condition
gen = data(:,35); % Gender (1: female, 2: male, 3+: other)
fem = gen==1; % Binary value indicating female participant
age = data(:,34); % Age
order = cond<3; % Order in which the Trolley Dilemma was shown (1:before, 0: after COVID-19 problems)
type  = cond==1 | cond==3; % Version of the Trolley Dilemma (0: Impersonal, 1: Personal)
accept(:,[2,5])=100-accept(:,[2,5]); % reverse coding of two scenarios with different framing
OCEAN = data(:,end-4:end); % Big-Five Personality Inventory
distress = mean(dist(:,1:5),2); % Average distress across COVID-19 problems

%% Closeness to COVID-19
% 1: The participant reported being diagnosed with COVID-19 
% 2-3: The participant reported knowing someone diagnosed with COVID-19 (2 if someone close, 3: if an acquaintance)
% -999: Missing value if the participant did not know anyone diagnosed with COVID-19
% Participants could report all combinations of 1, 2, and 3.

had_covid = covid==1 | covid==12 | covid==13 | covid==21 | ...
    covid==123 | covid==213 | covid==231; % all combinations where the participant reported being diagnosed with COVID-19
know_covid = covid==2 | covid==23 | covid==32 | covid==3; % all combinations where they know someone diagnosed with COVID-19
no_covid = covid==-999; % if they do not know anyone diagnosed with COVID-19

%% Load COVID data from OWID

AA=importdata('covid_owid.xlsx');

country_id = reshape(AA.data(:,1),26,10); % Country ID coded as in the Study
idpm = reshape(AA.data(:,3),26,10); % Deaths per million
icpm = reshape(AA.data(:,2),26,10); % Cases per million

covid_data = [country_id(end,:)',idpm(end,:)',icpm(end,:)']; % Last data point

dpmall = nan(size(covid_data,1),1); 
cpmall = nan(size(covid_data,1),1);

for p=1:size(covid_data,1)
    ind = country==covid_data(p,1);
   dpmall(ind)=covid_data(p,2); % Deaths per million associated to each participant
   cpmall(ind)=covid_data(p,3); % Cases per million associated to each participant
end

cname = {'ARG','URU','CHI','BOL','PER','ECU','COL','PAN','HON','MEX',};



%% Clear variables to avoid overloading memory
clear AA A data
