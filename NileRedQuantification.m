function [NileRedQuantificationData] = NileRedQuantification(path); % give the path to the folder containing the analysis of each of the spheroids. 

addpath(genpath(path));

d = dir(path); % path refers to the input directory. 
dirFlags = [d.isdir]; % indices of only the directories
d = d(dirFlags); % picks only the directories.
d = d(~strncmp({d.name},'.',1)); % removes the files starting with '.'


for i = 1:length(d)
    
    Data(i).TreatmentName = d(i).name; % extracts the names of each folder. 
    
    str = strcat(path,'/',Data(i).TreatmentName); % getting the absolute path to each folder
    
    subdir = dir(str); % gets the files within this folder. 
    subdir = subdir(~strncmp({subdir.name},'.',1)); % removes files with names contaning '.' at the start from the directory d;
    [~,Names,Ext] = cellfun(@fileparts,{subdir.name},'UniformOutput',false);
    DataFiles = subdir(contains(Ext,'.txt')); % obtain data files with .txt extension. These are the files that contain results from the ImageJ Macros. 
    
    FileNames = {DataFiles.name}; % Names of all the .txt files. 
        
    Q = cell(2,1); % We did not use the blue channel as the DAPI staining was bad. 
    clear W m n p
    
    for j = 1:length(FileNames)
        
    % Here we are dealing with 2 txt files for 2 channels. 
    
    Q{j,1} = table2array(readtable(FileNames{j}));
    [m,n] = size(Q{j,1});
    p = 1:Q{j,1}(end); % we obtain the total number of slices. 
    [sharedvals,idx] = intersect(Q{j,1}(:,n),p,'stable');  
    
    for k = 1:length(p)-1 % we have length(p) number of stacks. 
        W(j,k) = sum(Q{j,1}(idx(k):idx(k+1),2).*Q{j,1}(idx(k):idx(k+1),3)); % multiply mean intensity with are and get the sum. 
    end
    
    W(j,length(p)) = sum(Q{j,1}(idx(k+1):m,2).*Q{j,1}(idx(k+1):m,3));   
    
    end
    
    Data(i).GreenChannelIntSum = W(1,:);
    Data(i).RedChannelIntSum = W(2,:);    
    Data(i).NormalizedIntensity = W(2,:)./W(1,:);
       
end 

end
        

    
    
    
    
    

