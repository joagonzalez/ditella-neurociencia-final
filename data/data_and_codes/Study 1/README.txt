
DATA AND CODES SUPPORTING THE FINDINGS IN NAVAJAS ET AL., "UTILITARIAN REASONING ABOUT MORAL PROBLEMS OF THE COVID-19 CRISIS"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAIN DATA (data.csv & data.xlsx)
Columns A to U: acceptability, confidence and distress ratings for the five main scenarios related to the COVID-19 crisis + the two versions of the trolley problem (missing values in the Trolley Problem are coded as -999).
Column V (scenarios_order): order of presentation of scenarios
Column W (condition): : Personal Trolley Problem shown before (1), Impersonal Trolley Problem shown before (2), Personal Trolley Problem shown after (3), Impersonal Trolley Problem shown after (4).
Column X to AF (1_oxford_n): 9 items of Oxford Utilitarianism Scale (OUS). 1 to 5 are the five items to compute OUS-IB and 6 to 9 are the four items to compute OUS-IH. The items are in the same order as in Methods section of the paper. 
Column AG (oxford_order): presentation order of OUS items.
Column AH (age): participants' age
Column AI (gender): participants' gender, 1: female, 2: male, 3: non-binary, 4: genderfluid, 5: none of the above, 6: I'd rather not say.
Column AJ (country): participants' countries of residence, Argentina (11), Uruguay (236), Chile (40), Bolivia (27), Peru (178), Ecuador (56), Colombia (44), Panama (175), Honduras (89), Mexico (140).
Column AK (covid): personal closeness to COVID-19, diagnosed with COVID-19 (1), someone close diagnosed with COVID-19 (2), an acquaintance diagnosed with COVID-19 (3), do not know anyone diagnosed with COVID-19 (-999). Participants could report all combinations of 1, 2, and 3.
Columns AL to AP (Big Five): for participants who accepted to complete the personnality inventory, these columns show scores for each of the Big Five Personality Traits. 

Column AQ (timestamp): time at which the study was completed.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Scenarios: 
1: Treating all patients equally vs. priority to younger patients (scenario #4 in Figure 1C)
2: Data protection vs. effective virus tracing (scenario #1 in Figure 1C)
3: Economic activity vs. Physical distancing (scenario #2 in Figure 1C)
4: Protecting a friend vs. Informing a COVID-19 protocol breach (scenario #3 in Figure 1C)
5: Animal rights vs. Vaccine development (scenario #5 in Figure 1C)
6: Impersonal Trolley Problem
7: Personal Trolley Problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
COVID-19 DATA (covid_owid.xlsx & covid_owid.csv)
Column A: country name
Column B: country ID
Column C: total number of COVID-19 confirmed cases per million people
Column D: total number of COVID-19 confirmed deaths per million people
Column E: date of May 2020 (study lauched on 6 May 2020 and ran until 31 May 2020)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MATLAB CODES
load_variables.m: This script loads to the Workspace all variables needed to reproduce the analysis and main figures of the manuscript
figN.m: Script to create all panels in Figure N (N=2,3,4).
Other functions:
nannzscore.m: compute z-score for vector with NaN values
customcolormap.m: create custom colormaps
sem.m: compute standard error of the mean






