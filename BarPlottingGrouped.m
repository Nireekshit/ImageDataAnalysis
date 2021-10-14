% This script can be used to bar plot comparisons of the intensities b/w
% different treatments which are grouped. For non-grouped plots refer to
% 'BarPlotting.m'. 

str = {'BC G2 4D TGFB  SMA-VIMENTIN','BC G2 4D CONT  SMA-VIMENTIN';...
    'BC G2 7d TGFb1 SMA-VIMENTIN','BC G2 7d Cont SMA-VIMENTIN'}; % Enter the names of folders as wild card. For example, 
% if you want to extract data and plot BSA vs Control vs HGF etc enter the
% partial folder names in the variable 'str'. That way it will pick all
% folders (representing one spheroid each) corresponding to each treatment.

% For example, if you want to compare Day4 (Control,HGF) and
% Day7 (Control,HGF) the first row elements of str should be folders correspsonding to Day4
% and the next row should be of Day7. 

Treatments = {'TGF','Control'}; % Enter names of treatments. Example control vs TGF. These should be correspoding to the folder in one row of the variable 'str';
GroupingVariable = 'Days';
GroupingVariableValues = {'Day4','Day7'}; % If the bar plots are grouped Days. 


Names = {ProteinQuantificationDataBC.TreatmentName}; % This extracts the names of all folder as stored in the variable ProteinQuantification2. This variable is generated from the 
% 'ProteinQuantification.m' script. 

% The next for-loop extracts the intensity data of those folders whose name
% matches to the ones specified by the variable 'str'. It is stored into
% the variable 'Data'. If for example, HGF treatments has two folders, then
% the corresponding index in Data will have results from two folders. 

% Next we obtain the mean intensity values from the number of spheroid
% corresponding to each treatment. 

% In general, the blue channel is the nuclei stain. So, we are concerned
% with the green channel and red channel intensity normalized by the total
% number of cells extracted from the blue channel. If there is only green
% or red channel present comment it out in the for-loop. 

% See 'ProteinQuantification.m' script for normalization details. 


[m,n] = size(str);

clear yGreen yRed GreenStd yRedStd

for i = 1:m
    for j = 1:n

A = contains(Names,str{i,j});
Data{i,j} = ProteinQuantificationDataBC(A);
yGreen(i,j) = mean([Data{i,j}.NormalizedGreen]);
yRed(i,j) = mean([Data{i,j}.NormalizedRed]);
yGreenStd(i,j) = std([Data{i,j}.NormalizedGreen]);
yRedStd(i,j) = std([Data{i,j}.NormalizedRed]);
    end
   
end

b = bar(yGreen,'grouped'); % plots a barplot of the green channel intensities. Change to yRed if you want the plot of protein stained in red. 

% The next section is for plot aesthetics. 

axis square
set(gcf,'Position',[800 800 800 800]) % size of the plot
set(gca,'FontSize',14) % font size
ylabel('Normalized intensity') 
xlabel(GroupingVariable)
ax = gca;
ax.XTickLabel = GroupingVariableValues; % Names of the treatments. See line 11. 
title('Protein Quantification') % Give the plot title as a string. 

hold on

% The next section is for erro bars to be centered on each bar. 

% Calculate the width for each bar group
groupwidth = min(0.8, n/(n + 1.5));
% Set the position of each error bar in the centre of the main bar
% Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
for i = 1:n
    % Calculate center of each bar
    x = (1:m) - groupwidth/2 + (2*i-1) * groupwidth / (2*n);
    errorbar(x, yGreen(:,i), yGreenStd(:,i), 'k', 'linestyle', 'none'); % change to green or red accordingly. 
end

legend(Treatments)