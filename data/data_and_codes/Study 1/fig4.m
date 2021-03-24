%% Figure 4

clear all
close all
clc
load_variables

%% Big-five Personality variables

O = nanzscore(OCEAN(:,1)); % z-scored Openness
C = nanzscore(OCEAN(:,2)); % z-scored Conscientiousness
E = nanzscore(OCEAN(:,3)); % z-scored Extraversion
A = nanzscore(OCEAN(:,4)); % z-scored Agreeableness
N = nanzscore(OCEAN(:,5)); % z-scored Neuroticism


%% Principal Component Analysis on COVID-19 moral problems

MAT = [accept(:,2),accept(:,3),accept(:,4),accept(:,1),accept(:,5)]; % Re-arrange dilemmas as in Figure 1C
[coeff,score,latent,tsquared,explained,mu] = pca(MAT);
pca1 = zscore(score(:,1)); % z-scored projection onto 1st principal component
pca2 = -zscore(score(:,2)); % z-scored projection onto 2nd principal component

%% Moral variables

zIB = zscore(IB); % z-scored impartial beneficence
zIH = zscore(IH); % z-scored instrumental harm
zBH = zscore(IH.*IB); % interaction

%% Figure 4B: correlation between deaths per million and projection onto PCs

g1 = 236; % Group 1 - URU: less than 10 deaths per million
g2 = [11,27,44,89]; % Group 2 - ARG,BOL,COL,HON: [10-50] deaths per million
g3 = [40,140]; % Group 3 - CHI,MEX: [50-100] deaths per million
g4 = [56,178]; % Group 4 - ECU,PER: more than 100 deaths per million

i1 = ismember(country,g1); % indexes of participants in group 1
i2 = ismember(country,g2); % indexes of participants in group 2
i3 = ismember(country,g3); % indexes of participants in group 3
i4 = ismember(country,g4); % indexes of participants in group 4

mP1 = [mean(pca1(i1)),mean(pca1(i2)),mean(pca1(i3)),mean(pca1(i4))]; % mean projection onto PC1
mP2 = [mean(pca2(i1)),mean(pca2(i2)),mean(pca2(i3)),mean(pca2(i4))]; % mean projection onto PC2
eP1 = [sem(pca1(i1)),sem(pca1(i2)),sem(pca1(i3)),sem(pca1(i4))]; % SEM of projection onto PC1
eP2 = [sem(pca2(i1)),sem(pca2(i2)),sem(pca2(i3)),sem(pca2(i4))]; % SEM of projection onto PC2

figure('color','w','paperposition',[1 1 12 7])
bar([1:4]-.18,mP1,.3,'edgecolor','k','linewidth',2,'facecolor','w');hold on;
for ip=1:4
plot(ip*[1,1]-.18,[mP1(ip)-eP1(ip),mP1(ip)+eP1(ip)],'k-','linewidth',2);hold on;
end
bar([1:4]+.18,mP2,.3,'edgecolor',.4*[1,1,1],'linewidth',2,'facecolor','w');hold on;
for ip=1:4
plot(ip*[1,1]+.18,[mP2(ip)-eP2(ip),mP2(ip)+eP2(ip)],'-','color',.4*[1,1,1],'linewidth',2);hold on;
end
ylim([-.5 .35])
set(gca,'xtick',[1:4],'xticklabel',{''},'ytick',[-.4:.2:.4])
box off

cd figures
print -dpdf fig4b.pdf
cd ..


%% Tables S1 and S2

mdl1=fitlm([zIH,zIB,zBH,... % moral regressors
    nanzscore(log10(dpmall)),zscore(had_covid),zscore(know_covid),... % contextual
    O,C,E,A,N,... % personality
    zscore(fem),zscore(age),... % demographic
    type,order,... % experimental
    ],pca1,'RobustOpts','talwar');

mdl2=fitlm([zIH,zIB,zBH,... % moral regressors
    nanzscore(log10(dpmall)),zscore(had_covid),zscore(know_covid),... % contextual
    O,C,E,A,N,... % personality
    zscore(fem),zscore(age),... % demographic
    type,order,... % experimental
    ],pca2,'RobustOpts','talwar');


%% Figure 4C

b1 = mdl1.Coefficients.Estimate([2,3,5]); % coefficient estimates for IB, IH and DPM against PC1
eb1 = mdl1.Coefficients.SE([2,3,5]); % SEM of coefficient estimates for IB, IH and DPM against PC1
tb1 = mdl1.Coefficients.tStat([2,3,5]); % t-value of coefficient estimates for IB, IH and DPM against PC1
b2 = mdl2.Coefficients.Estimate([2,3,5]); % coefficient estimates for IB, IH and DPM against PC2
eb2 = mdl2.Coefficients.SE([2,3,5]); % SEM of coefficient estimates for IB, IH and DPM against PC2
tb2 = mdl2.Coefficients.tStat([2,3,5]); % t-value of coefficient estimates for IB, IH and DPM against PC2

figure('color','w','paperposition',[1 1 10 6])
plot([.5 3.5],[0,0],'k-','linewidth',2);hold on
scatter([1:length(b1)]-.1,b1,70,tb1,'filled');
scatter([1:length(b2)]+.1,b2,70,tb2,'s','filled');
for ib=1:3
plot(ib*[1,1]-.1,[b1(ib)-eb1(ib),b1(ib)+eb1(ib)],'k-');hold on;
plot(ib*[1,1]+.1,[b2(ib)-eb2(ib),b2(ib)+eb2(ib)],'k-');hold on;
end
zlim = 5.5;
caxis([0 6])
J = customcolormap([0 (zlim-2)/zlim 1], {'#006d2c','#969696','#252525'});  % colormap between red and green  
h=colorbar; colormap(J)
ylabel(h,'t-value');
set(h,'ytick',[0 2 4])
ylabel 'Estimate'
set(gca,'xtick',[1:3],'xticklabel',{''},...
    'ytick',[-.1:.1:.3]);
box off
ylim([-.12 .34])
xlim([.5 3.5])
cd figures
print -dpdf fig4c.pdf
cd ..

