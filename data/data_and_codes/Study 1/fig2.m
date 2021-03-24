%% Figure 2

clear all
close all
clc
load_variables

%% 3D maps of acceptability as a function of IB and IH

zIB = zscore(IB); % z-scored impartial beneficence
zIH = zscore(IH); % z-scored instrumental harm
binsize = .5; % bin size to create 3D map
bins = [-2:binsize:2]; % bins
MA_imp = nan(length(bins)-1); % mean acceptability for impersonal trolley dilemma
MA_per = nan(length(bins)-1);% mean acceptability for personal trolley dilemma
for i=1:length(bins)-1
    for j=1:length(bins)-1
        indx = zIH>=bins(i) & zIH<bins(i+1);
        indy = zIB>=bins(j) & zIB<bins(j+1);
        MA_imp(i,j)=nanmean(accept(indx & indy,6));        
        MA_per(i,j)=nanmean(accept(indx & indy,7));        
    end
    cx(i) = .5*(bins(i)+bins(i+1)); % bin centers
end

%% Trolley - Impersonal

figure('color','w','paperposition',[1 1 10 7])
imagesc(cx,cx,MA_imp,[0 100]);
J = customcolormap([0 0.5 1], {'#2ca25f','#ffffff','#e34a33'});   % colormap between red and green
colorbar; colormap(J)
hold on;
plot(xlim,[0 0],'k--')
plot([0 0],ylim,'k--')
axis xy
ylabel 'Instrumental Harm (z-score)'
xlabel 'Impartial Beneficence (z-score)'
title 'Trolley Dilemma (Impersonal)'
cd figures
print -dpdf fig2b.pdf
cd ..

%% Trolley - Personal

figure('color','w','paperposition',[1 1 10 7])
imagesc(cx,cx,MA_per,[0 100]);
J = customcolormap([0 0.5 1], {'#2ca25f','#ffffff','#e34a33'});  % colormap between red and green  
h=colorbar; colormap(J)
set(h,'ytick',[0 50 100])
hold on;
plot(xlim,[0 0],'k--')
plot([0 0],ylim,'k--')
axis xy
ylabel 'Instrumental Harm (z-score)'
xlabel 'Impartial Beneficence (z-score)'
title 'Trolley Dilemma (Personal)'
cd figures
print -dpdf fig2c.pdf
cd ..

