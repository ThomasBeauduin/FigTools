%% Matlab plot gallery
% https://www.mathworks.com/products/matlab/plot-gallery.html
clearvars; close all; clc;

list = dir('Advanced Plots');    %Standard Plots  %Advanced Plots
list = struct2table(list);
figs = find(list.isdir==0);

for i=1:length(figs)
    filename = [list.folder{figs(i)},filesep,list.name{figs(i)}];
    [filepath,name,ext] = fileparts(filename);
    if strcmp(ext,'.m')
        run(filename);
        pubfig(gcf);
        drawnow;
    end
end
