% This is a function written to collate data from a wound healing assay. 
% The data are stores as .xls files each file corresponds to a particular
% field from a particular time point. The idea is to collate all the data
% belonging to one treatment into one .xls file

function [FinalData] = ScratchAssayData()

prompt = 'Enter the folder path to be processed';
inputdirectory = input(prompt);
addpath(genpath(inputdirectory));

prompt = 'Enter the folder path to store data';
outputdirectory = input(prompt);
addpath(genpath(outputdirectory));

prompt = 'Enter how the time point is stored. Example - 0 h, 24 h, 48 h; Seperated by commas';
tp = input(prompt);



% The 'inputdirectory' is the folder containing the results from one
% paticular type of treatment. For example this could be DMF treatment, EVD
% or NAIVE. 

% The 'outputdirectory' is the folder where the concetanated results from one
% paticular type of treatment are stored.

Treatments = dir(inputdirectory); % Gets all the folders present in this directory. Each of the 
% folders correspond to one of the treatments. 

Treatments(strncmp({Treatments.name}, '.', 1)) = []; % Removes some extra files present due to file managemenet systems. 
Treatments(strncmp({Treatments.name}, '~', 1)) = [];

CombinedData = table(tp','VariableNames',{'TimePoints'}); % This creates a table which will store the final wound healing percentages.  

for j = 1:length(Treatments)
    
    Timepoints = dir(strcat(Treatments(j).folder,'/',Treatments(j).name)); % Looking for the files representng different time points. 
    
    Timepoints(strncmp({Timepoints.name}, '.', 1)) = []; % removes some extra files present due to file managemenet systems. 
    Timepoints(strncmp({Timepoints.name}, '~', 1)) = []; 
    
    for i = 1:length(Timepoints)
    
    [~,name,~] = fileparts(Timepoints(i).name); % gets the names of the files. 
    
    Measurement{i} = name;
    
    t{i} = readtable(Timepoints(i).name); % reads the data contained into a table in MATLAB. 
    
    [m,~] = size(t{i}); C = cell(m,1); C(:) = {name}; M = zeros(m,1); % some processing.
    
    t{i}.Source = C; % Adding the name of the file to one column of the table. Helps in keeping
    % a track of where the data came from.
    
    M(1) = mean(t{i}.Length); t{i}.MeanWidthOfField = M;
    M(1) = std(t{i}.Length); t{i}.SDWithinField = M;
       
    end
    
    clear M
    
    T = vertcat(t{1:end}); % All the data from one particular type of treatment are concetanted into a 
                           % single table.  
                           
    for z = 1:length(tp)
        u{z} = contains(T.Source, tp{z}); % obtains the location of the data from respective time points. Like 0h, 24h.
        l = nnz(u{z}); % Each entry has a different length. For example (2 fields and 5/field) O h observations will be of length x{z};     
        M{z} = zeros(l,1); S{z} = zeros(l,1); % create those entries in M 
        
        B = T.MeanWidthOfField(u{z}); % The next 2 lines  
        B = B(find(B));
        
        M{z}(1) = mean(B); % this will calculate the mean of the width in respective hour time points and input in M;
        S{z}(1) = std(B); % this will calculate the SD. 
    end 
    
    G = []; H = []; % Empty vectors to make processing easier. 
    
    for r = 1:length(M)
        G = [G,M{r}']; % Concetanating values.
        H = [H,S{r}'];
    end
       
    T.MeanWidthAtTimePoint = G'; % Assigning the concetanated values to the table. 
    T.SDwithinTimePoint = H'; % Assigning the concetanated values to the table.
    [m,n] = size(T);
    
    Elements = find(T.MeanWidthAtTimePoint);
    Values = T.MeanWidthAtTimePoint(Elements);
    NormDiff = (Values(1)-Values)/Values(1);
    PercentageWoundClosure = NormDiff*100;
    
    T.PercentageWoundClosure = zeros(m,1);
    T.PercentageWoundClosure(Elements) = PercentageWoundClosure;
    
   
    
    string = strcat(outputdirectory,'/',Treatments(j).name,'.xls');

    writetable(T,string) % saves the table to output directory. 
    
    Q = T.PercentageWoundClosure;
    Q = [0,Q(find(Q))']';
    
    P = Treatments(j).name;
    
    CombinedData.(P) = Q;
    
    FinalData{j} = T;
    
end


   string = strcat(outputdirectory,'/','CombinedDataWoundClosure','.xls');
   writetable(CombinedData,string) % saves the table to output directory. 
   


   


   