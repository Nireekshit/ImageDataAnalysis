function [ProteinQuantificationData] = ProteinQuantificationBC(path); % give the path to the folder containing the analysis of each of the spheroids. 

addpath(genpath(path)); 

d = dir(path); % path refers to the input directory. 
dirFlags = [d.isdir]; % indices of only the directories
d = d(dirFlags); % picks only the directories.
d = d(~strncmp({d.name},'.',1)); % removes the files starting with '.'


for i = 1:length(d)
    
    Data(i).TreatmentName = d(i).name; % extracts the names of each folder. 
    
    str = strcat(path,'/',Data(i).TreatmentName);
    
    subdir = dir(str);
    subdir = subdir(~strncmp({subdir.name},'.',1)); % removes files with names contaning '.' at the start from the directory d;
    [~,Names,Ext] = cellfun(@fileparts,{subdir.name},'UniformOutput',false);
    DataFiles = subdir(contains(Ext,'.txt'));
    
    FileNames = {DataFiles.name};
        
    Q = cell(3,1); 
    clear W m n p idx
    
    for j = 1:length(FileNames)
    
    % Here we are dealing with 3 txt files for 3 channels. 
    
    if j == 1 % this part is for the nuclei count. 
    
    Q{j,1} = table2array(readtable(FileNames{j}));
    
    [m,n] = size(Q{j,1});
    
    W(j) = m;
       
    else
        
    Q{j,1} = table2array(readtable(FileNames{j}));    
        
    W(j) = sum(Q{j,1}(:,2).*Q{j,1}(:,3));  
    
    end
    
    end 
   
    Data(i).CellNumber = W(1);
    Data(i).GreenChannelIntSum = W(2);
    Data(i).NormalizedGreen = W(2)/W(1);
    Data(i).RedChannelIntSum = W(3); % Comment these out if the image has only the green channel or vice versa. 
    Data(i).NormalizedRed = W(2)/W(1); % Comment these out if the image has only the green channel or vice versa. 
end
        

    
    
    
    
    

