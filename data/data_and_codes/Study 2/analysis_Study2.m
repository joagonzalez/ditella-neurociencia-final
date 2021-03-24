clear all
close all
clc

A = importdata('data_Study2.xlsx');
data = A.data;
accept = data(:,5:3:17);

age = data(:,30);
sex = data(:,31); % 1: male, 0: female
eth = data(:,32); % 0: black, 1: white, 2: hispanic, 3: asian, 4: other
edu = data(:,33); % 0: less than high-school, 1: less than complete college, 2: at least complete college
vot = data(:,34); % 0: Trump, 1: Biden, 2: None
OUS = data(:,20:28); % Oxford Utilitarianism Scale
IH = sum(OUS(:,[1,2,3,8]),2); % Instrumental Harm
IB = sum(OUS(:,[4:7,9]),2); % Impartial Beneficence

%% Principal Component Analysis

MAT = accept;
MAT(:,[1,5])=100-MAT(:,[1,5]); % reverse-coding of scenarios #1 and #5

[coeff,score,latent,tsquared,explained,mu] = pca(MAT);

pca1 = zscore(score(:,1)); % z-scored projection onto 1st principal component
pca2 = zscore(score(:,2)); % z-scored projection onto 2nd principal component
myexp = explained; % variance explained by each of the 5 components
w1   = coeff(:,1); % loadings associated to 1st PC
w2   = coeff(:,2); % loadings associated to 2nd PC

% The first component is consistent with an interest in Equitable Public
% Health (i.e., the pre-registered dimension with positive loading in the
% first three scenarios, and negative loadings in the last two).
% The second component is consistent with an interest in Human Life
% Expectanncy (i.e., the pre-registered dimension with positive loadings in
% all scenarios). 


%% Random permutation analysis of PCA
Ns = 1300;
Nsim = 1000; % Number of simulations. 
rexp=nan(Nsim,5);rvsc=rexp;
for s=1:Nsim
    if mod(s,100)==0
        disp(['simulation ',num2str(s),'/',num2str(Nsim)])
    end
    % randomly shuffle all dilemmas independently
    ir1 = randperm(Ns);
    ir2 = randperm(Ns);
    ir3 = randperm(Ns);
    ir4 = randperm(Ns);
    ir5 = randperm(Ns);
    % create surrogate matrix to perform PCA
    rMAT = [accept(ir1,2),accept(ir2,3),accept(ir3,4),accept(ir4,1),accept(ir5,5)];
    [coeff,score,latent,tsquared,explained,mu] = pca(rMAT);
    rexp(s,:)=explained; % variance explained by each component in surrogate data
end

%% Figure 3E - main panel

figure('color','w','paperposition',[1 1 8 7])
aux=prctile(rexp,[0,100]); % max  and min, to obtain 95-percentiles change [0,100] to [5,95].
l_rexp = aux(1,:); % lower bound for variance explained of PCs obtained using surrogate data
u_rexp = aux(2,:); % upper bound for variance explained of PCs obtained using surrogate data
m_rexp = mean(rexp); % average variance explained of PCs obtained using surrogate data
plot([1:5],myexp,'ks-','markersize',10,...
    'linewidth',1,'markerfacecolor','k');hold on;
plot([1:5],l_rexp,'-','color',.6*[1,1,1])
plot([1:5],u_rexp,'-','color',.6*[1,1,1])
xlim([0 6])
ylim([8 32])
set(gca,'xtick',[1:5],'ytick',[10:5:35])
box off
xlabel 'component number'
ylabel '% of variance explained'
print -dpdf fig3E-main.pdf


%% Figure 3E - insets
% colors
cc = {[100 20 0]/100,[0 60 50]/100,[0 45 70]/100,[75 0 130]/255,[255 215 0]/255};
gg = .6*[1,1,1];
% Loadings of First PC
figure('color','w','paperposition',[1 1 7 4])
for d=1:5
    stem(d,w1(d),'color',cc{d},'markersize',2,...
        'markerfacecolor',cc{d},'linewidth',2);hold on
    xlim([0 6])
    ylim([-1 1])
    xlabel 'dilemma'
    ylabel 'loading'
    set(gca,'xtick',[1:5],'xticklabel',{''},'ytick',[-.8:.4:.8])
end
box off
print -dpdf fig3E-inset1.pdf
% Loadings of Second PC
figure('color','w','paperposition',[1 1 7 4])
for d=1:5
    stem(d,w2(d),'color',cc{d},'markersize',2,...
        'markerfacecolor',cc{d},'linewidth',2);hold on
    xlim([0 6])
    ylim([-1 1])
    xlabel 'dilemma'
    ylabel 'loading'
    set(gca,'xtick',[1:5],'xticklabel',{''},'ytick',[-.8:.4:.8])
end
box off
print -dpdf fig3E-inset2.pdf


%% Compute maps for both Principal Components

zIB = zscore(IB);
zIH = zscore(IH);
binsize = 1;
bins = [-2:binsize:2];
MA_switch = nan(length(bins)-1);
MA_fat = nan(length(bins)-1);
MD = nan(length(bins)-1);MPCA1=MD;MPCA2=MD;MC=MD;MOUS=MD;HH=MD;CT1=MD;CT2=MD;DT1=MD;DT2=MD;
clear cx
for i=1:length(bins)-1
    for j=1:length(bins)-1
        indx = zIH>=bins(i) & zIH<bins(i+1);
        indy = zIB>=bins(j) & zIB<bins(j+1);
        HH(i,j)=sum(indx & indy);
        MPCA1(i,j)=nanmean(pca1(indx & indy));
        MPCA2(i,j)=nanmean(pca2(indx & indy));
    end
    cx(i) = .5*(bins(i)+bins(i+1));
end


%% Figure 3F: Human Life Expectancy

figure('color','w','paperposition',[1 1 10 7])
imagesc(cx,cx,MPCA2,[-.35 .35]);
J = customcolormap([0 0.5 1], {'#3f007d','#9e9ac8','#fcfbfd'});   

colorbar; colormap(J)
hold on;
plot(xlim,[0 0],'k--')
plot([0 0],ylim,'k--')
axis xy
ylabel 'Instrumental Harm (z-score)'
xlabel 'Impartial Beneficence (z-score)'
print -dpdf fig3F.pdf

%% Figure 3G: Equitable Public Health

figure('color','w','paperposition',[1 1 10 7])
imagesc(cx,cx,MPCA1,[-.35 .35]);
J = customcolormap([0 0.5 1], {'#3f007d','#9e9ac8','#fcfbfd'});   

colorbar; colormap(J)
hold on;
plot(xlim,[0 0],'k--')
plot([0 0],ylim,'k--')
axis xy
ylabel 'Instrumental Harm (z-score)'
xlabel 'Impartial Beneficence (z-score)'
print -dpdf fig3G.pdf

