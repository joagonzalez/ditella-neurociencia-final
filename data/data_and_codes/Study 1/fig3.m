%% Figure 3

clear all
close all
clc
load_variables


%% Principal Component Analysis on COVID-19 moral problems

MAT = [accept(:,2),accept(:,3),accept(:,4),accept(:,1),accept(:,5)]; % Re-arrange dilemmas as in Figure 1C
[coeff,score,latent,tsquared,explained,mu] = pca(MAT);
pca1 = zscore(score(:,1)); % z-scored projection onto 1st principal component
pca2 = -zscore(score(:,2)); % z-scored projection onto 2nd principal component
myexp = explained; % variance explained by each of the 5 components
w1   = coeff(:,1); % loadings associated to 1st PC
w2   = -coeff(:,2); % loadings associated to 2nd PC
% The negative sign ensures that the first three dilemmas have positive
% loading as in the first PC. This procedure is justified given that PCs
% reflect directions and the sign only changes the sense, but not the direction.



%% Random permutation analysis of PCA

Nsim = 1000; % Number of simulations. For simplicity, we run 1,000.
% To reproduce the analysis in the paper, please change this value to 10,000. Results remain identical.
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

%% Figure 3B - Main

% colors
cc = {[100 20 0]/100,[0 60 50]/100,[0 45 70]/100,[75 0 130]/255,[255 215 0]/255};
gg = .6*[1,1,1];


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
ylim([12 27])
set(gca,'xtick',[1:5],'ytick',[10:5:35])
box off
xlabel 'component number'
ylabel '% of variance explained'
cd figures
print -dpdf fig3b_main.pdf
cd ..

%% Figure 3B insets
% Loadings of First PC
figure('color','w','paperposition',[1 1 7 4])
for d=1:5
    stem(d,w1(d),'color',cc{d},...
        'markerfacecolor',cc{d},'linewidth',2);hold on
    xlim([0 6])
    ylim([-.72 .72])
    xlabel 'dilemma'
    ylabel 'loading'
    set(gca,'xtick',[1:5],'xticklabel',{''},'ytick',[-.6:.3:.6])
end
box off
cd figures
print -dpdf fig3b_upperleft.pdf
cd ..
% Loadings of Second PC
figure('color','w','paperposition',[1 1 7 4])
for d=1:5
    stem(d,w2(d),'color',cc{d},...
        'markerfacecolor',cc{d},'linewidth',2);hold on
    xlim([0 6])
    ylim([-.72 .72])
    xlabel 'dilemma'
    ylabel 'loading'
    set(gca,'xtick',[1:5],'xticklabel',{''},'ytick',[-.6:.3:.6])
end
box off
cd figures
print -dpdf fig3b_upperright.pdf
cd ..

%% Compute maps for both Principal Components

close all
zIB = zscore(IB);
zIH = zscore(IH);
binsize = 1;
bins = [-2:binsize:2];
MPCA1 = nan(length(bins)-1);MPCA2=MPCA1;
clear cx
for i=1:length(bins)-1
    for j=1:length(bins)-1
        indx = zIH>=bins(i) & zIH<bins(i+1);
        indy = zIB>=bins(j) & zIB<bins(j+1);
        MPCA1(i,j)=nanmean(pca1(indx & indy));
        MPCA2(i,j)=nanmean(pca2(indx & indy));
    end
    cx(i) = .5*(bins(i)+bins(i+1));
end


%% Figure 3C: Human Life Expectancy

figure('color','w','paperposition',[1 1 10 7])
imagesc(cx,cx,MPCA1,[-.35 .35]);
J = customcolormap([0 0.5 1], {'#3f007d','#9e9ac8','#fcfbfd'});   %

colorbar; colormap(J)
hold on;
plot(xlim,[0 0],'k--')
plot([0 0],ylim,'k--')
axis xy
ylabel 'Instrumental Harm (z-score)'
xlabel 'Impartial Beneficence (z-score)'
cd figures
print -dpdf fig3c.pdf
cd ..

%% Figure 3D: Equitable Public Health

figure('color','w','paperposition',[1 1 10 7])
imagesc(cx,cx,MPCA2,[-.35 .35]);
J = customcolormap([0 0.5 1], {'#3f007d','#9e9ac8','#fcfbfd'});   %

h=colorbar; colormap(J)
set(h,'ytick',[-.3:.3:.3])
hold on;
plot(xlim,[0 0],'k--')
plot([0 0],ylim,'k--')
axis xy
ylabel 'Instrumental Harm (z-score)'
xlabel 'Impartial Beneficence (z-score)'
cd figures
print -dpdf fig3d.pdf
cd ..


