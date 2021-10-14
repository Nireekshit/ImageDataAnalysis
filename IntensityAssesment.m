addpath(genpath(path)); 

d = dir(path); % create variable called path in workspace. Give fullpath length to the folder to be assesed. 

[~,~,ext] = cellfun(@fileparts,{d.name},'UniformOutput',false);

d = d(contains(ext,'jpg'));

for i = 1:length(d)
    Image(i).Name = d(i).name;
    Image(i).Data = reshape(im2double(rgb2gray((imread(Image(i).Name)))),1,[]);
    Image(i).Mean = mean(Image(i).Data);
    Image(i).Std = std(Image(i).Data);  
end


h1 = gscatter([Image.Mean],[Image.Std]);
grid on

DivisionNumber = input('Enter the number of divisions you want'); % Divides the data into these many parts. 

figure
H = histogram([Image.Mean],DivisionNumber);
grid on
ax = gca;
ax.XTick = H.BinEdges;

for i = 1:length(H.BinEdges)-1
    F{i} =  find( [Image.Mean] > H.BinEdges(i) & [Image.Mean] < H.BinEdges(i+1) );
    FolderName{i} = num2str(i);
    mkdir(path,FolderName{i});
    addpath(genpath(strcat(path,'/',FolderName{i})));
end

for i = 1:length(H.BinEdges)-1

    for j = 1:length(F{i})
       
    movefile(strcat(path,'/',Image(F{i}(j)).Name),strcat(path,'/',FolderName{i}));
    
    end

end


