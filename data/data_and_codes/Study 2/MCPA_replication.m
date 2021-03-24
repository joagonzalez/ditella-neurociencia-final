%% 

clear all
close all
clc
load_variables


%% All data: Principal Component Analysis on COVID-19 moral problems

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

%% Monte Carlo Power Analysis (MCPA) 
% Only if do_MCPA is set to 'true', if not, simply load data.
do_MCPA = false;
if do_MCPA
    ns = [100:100:4000];
    Nexp = 10000;
    
    for in=1:length(ns)
        Nsyn  = ns(in);
        for j=1:Nexp
            if mod(j,1000)==0 || j==1
                [Nsyn,j]
            end
            indi  = randperm(Ns);
            indi  = indi(1:Nsyn);
            MATs  = MAT(indi,:);
            [coeff,score,latent,tsquared,explained,mu] = pca(MATs);
            w1   = coeff(:,1); % loadings associated to 1st PC
            w2   = -coeff(:,2); % loadings associated to 2nd PC
            myexp = explained; % variance explained by each of the 5 components
            sPC1 = zscore(score(:,1)); % z-scored projection onto 1st principal component
            sPC2 = -zscore(score(:,2)); % z-scored projection onto 2nd principal component
            
            
            
            R2D(j,in) = sum(myexp(1:2))>45.1;
            
            
            HLE1 = sum((w1.*[1,1,1,1,1]')>0)==5 | sum((w1.*[1,1,1,1,1]')<0)==5;
            HLE2 = sum((w2.*[1,1,1,1,1]')>0)==5 | sum((w2.*[1,1,1,1,1]')<0)==5;
            EPH1 = sum((w1.*[1,1,1,-1,-1]')>0)==5 | sum((w1.*[1,1,1,-1,-1]')<0)==5;
            EPH2 = sum((w2.*[1,1,1,-1,-1]')>0)==5 | sum((w2.*[1,1,1,-1,-1]')<0)==5;
            
            RHLE(j,in) = HLE1 | HLE2;
            REPH(j,in) = EPH1 | EPH2;
            
            [~,pIH1]=corr(IH(indi),sPC1);
            [~,pIH2]=corr(IH(indi),sPC2);
            [~,pIB1]=corr(IB(indi),sPC1);
            [~,pIB2]=corr(IB(indi),sPC2);
            
            RIH(j,in) = pIH1<.05 | pIH2<.05;
            RIB(j,in) = pIB1<.05 | pIB2<.05;
            
            
        end
    end
    
    save MCPA.mat
    
else
    load MCPA.mat
end

%% Power as a function of sample size for most restrictive hypothesis (RHLE)
figure('color','w','paperposition',[1,1,7,5]);
mRHLE = mean(RHLE);
plot(ns,mRHLE,'b-','linewidth',2);hold on;
plot(xlim,.8*[1,1],'k--');
myNs = ns==1300;
plot(1300*[1,1],mRHLE(myNs),'ko','markersize',5,'markerfacecolor','k')
xlabel 'Sample Size';
ylabel 'Power';
box off
print -dpdf power_analysis_Study2.pdf
print -djpeg -r600 power_analysis_Study2.jpeg;
