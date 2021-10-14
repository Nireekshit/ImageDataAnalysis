% This script can be used to bar plot comparisons of the intensities b/w
% different treatments which are not grouped. For grouped plots refer to
% 'plottinggroup.m'. 

str = {'CYP RG1 Healthy-BSA-2','CYP_RG2 Rev Control-1','CYP_RG3 HGF001-1','CYP_RG6  Exo Naive','CYP_RG7  Exo DMF'}; % Enter the names of folders as wild card. For example, 
% if you want to extract data and plot BSA vs Control vs HGF etc enter the
% partial folder names in the variable 'str'. That way it will pick all
% folders (representing one spheroid each) corresponding to each treatment.

Treatments = {'Healthy-BSA','Reversal Control','HGF','Naive Exo','DMF Exo'}; % Enter names of treatments as you would like to appear in the plot. 

Names = {ProteinQuantification2.TreatmentName}; % This extracts the names of all folder as stored in the variable ProteinQuantification2. This variable is generated from the 
% 'ProteinQuantification.m' script. 

% The next for-loop extracts the intensity data of those folders whose name
% matches to the ones specified by the variable 'str'. It is stored into
% the variable 'Data'. If for example, HGF treatments has two folders, then
% the corresponding index in Data will have results from two folders. 

for i = 1:length(str)

A = contains(Names,str{i});
Data{i} = ProteinQuantification2(A);

end

% Next we obtain the mean intensity values from the number of spheroid
% corresponding to each treatment. 

% In general, the blue channel is the nuclei stain. So, we are concerned
% with the green channel and red channel intensity normalized by the total
% number of cells extracted from the blue channel. If there is only green
% or red channel present comment it out in the for-loop. 

% See 'ProteinQuantification.m' script for normalization details. 

for i  = 1:length(str)
    yGreen(i) = mean([Data{i}.NormalizedGreen]); % Mean intensity
    % yRed(i)   = mean([Data{i}.NormalizedRed]);
    
    yGreenStd(i) = std([Data{i}.NormalizedGreen]); % Standard deviation
    % yRedStd(i)   = std([Data{i}.NormalizedRed]);      
    
end

b = bar(yGreen); % plots a barplot of the green channel intensities. Change to yRed if you want the plot of protein stained in red. 

% The next section is for plot aesthetics. 

axis square
set(gcf,'Position',[800 800 800 800]) % size of the plot
set(gca,'FontSize',14) % font size
ylabel('Normalized intensity') 
xlabel('Treatments')
ax = gca;
ax.XTickLabel = Treatments; % Names of the treatments. See line 11. 
title('Protein Quantification') % Give the plot title as a string. 

hold on

errorbar(yGreen,yGreenStd,'*') % plots the errorbars


