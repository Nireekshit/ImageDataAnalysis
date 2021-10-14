function [Data] = LiveDeadAnalysis(path); % give the path to the folder containing the analysis of each of the spheroids. 

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
    Channel1 = contains(FileNames,'C1'); % Channel1 is that of nuclei stained by Hoechst. (Live+Dead cells)
    Channel3 = contains(FileNames,'C3'); % Channel3 is that of nuceli stained by EtBR. (Dead cells)
    
    C1FileNames = FileNames(Channel1);
    C3FileNames = FileNames(Channel3);
    
    TotalImages = length(FileNames)/2;
    
    Q = cell(2,TotalImages);
    W = zeros(2,TotalImages);
    
    for j = 1:TotalImages
    
    Q{1,j} = table2array(readtable(C1FileNames{j}));
    [m,n]  = size(Q{1,j});
    W(1,j) = m;
    
    Q{2,j} = table2array(readtable(C3FileNames{j}));
    [m,n]  = size(Q{2,j});
    W(2,j) = m;
    
    end
    
    Data(i).ROIData = Q;
    Data(i).NucleiData = W;
    Data(i).DeadFraction = W(2,:)./W(1,:);  % nuclei in red channel/nuclei in green channel. 
       
end    
end
        
       
    
    

