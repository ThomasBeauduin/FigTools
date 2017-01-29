function [file] = expfig(varargin)
%EXPFIG - Exports figures in a publication-quality format.
%
% filename      : export filename without extension (string).
%   -<format>   : required export extension (multiple possible).
%   -nocrop     : skip figure border cropping.
%   -<render>   : option to force type of renderer.options.im
%   -grey       : option to define colorspace (rgb, mcyk, grey).
%   -m<val>     : optional magnification value of on-screen figure
%   -p<val>     : optional border box padding (percentage). 
% handle        : handle of figure object to export.
%
% Author: Thomas Beauduin, The University of Tokyo, 2016

% User requirements
[hfig, options] = parse_args(varargin{:});
file = [];

% Ghostscript requirements
set(hfig,'Units','pixels');
set(hfig, 'InvertHardcopy', 'off');


%% PART 1 - BITMAP
% test transparent background color
if isbitmap(options)
    switch options.renderer
        case 1,     renderer = '-opengl';
        case 2,     renderer = '-zbuffer';
        case 3,     renderer = '-painters';
        otherwise,  renderer = '-opengl';       % default for bitmap
    end
    
    A = print2array(hfig, options.magnify, renderer);
    if options.grey, A = rgb2grey(A); end
    if options.crop, A = cropfig(A, [], options.padding); end

    if options.png
        fld_nam = [pwd,filesep,options.folder,filesep,'png'];
        if exist(fld_nam,'dir') == 0, mkdir(fld_nam); end
        png_nam = [fld_nam, filesep, options.name, '.png'];
        
        try imwrite(A, png_nam); catch, end
        file = [file; png_nam];
    end
    
    if options.bmp
        fld_nam = [pwd,filesep,options.folder,filesep,'bmp'];
        if exist(fld_nam,'dir') == 0, mkdir(fld_nam); end
        bmp_nam = [fld_nam, filesep, options.name, '.bmp'];
        
        try imwrite(A, bmp_nam); catch, end
        file = [file; bmp_nam];
    end
end

%% PART 2 - VECTOR
if isvector(options)
    switch options.renderer
        case 1,     renderer = '-opengl';
        case 2,     renderer = '-zbuffer';
        case 3,     renderer = '-painters';
        otherwise,  renderer = '-painters';     % default for vector
    end
    
    eps_tmp = print2eps(hfig, options.padding, renderer);
    pdf_tmp = eps2pdf(eps_tmp, options.crop, options.grey);
    
    if options.eps
        fld_nam = [pwd,filesep,options.folder,filesep,'eps'];
        if exist(fld_nam,'dir') == 0, mkdir(fld_nam); end
        eps_nam = [fld_nam, filesep, options.name, '.eps'];
        
        try pdf2eps(pdf_tmp, eps_nam); catch, end
        file = [file; eps_nam];
    end

    if options.pdf
        fld_nam = [pwd,filesep, options.folder, filesep, 'pdf'];
        if exist(fld_nam,'dir') == 0, mkdir(fld_nam); end
        pdf_nam = [fld_nam, filesep, options.name, '.pdf'];
        
        try copyfile(pdf_tmp, pdf_nam, 'f'); catch, end
        file = [file; pdf_nam];
    end
    
    if options.emf
        fld_nam = [pwd,filesep,options.folder,filesep,'emf'];
        if exist(fld_nam,'dir') == 0, mkdir(fld_nam); end
        emf_nam = [fld_nam, filesep, options.name, '.emf'];
        
        set(hfig,'Color','none'); set(hfig,'InvertHardcopy','off');
        print(emf_nam,'-dmeta',sprintf('-r%d',864));
        set(hfig,'Color','white'); set(hfig,'InvertHardcopy','on');
        file = [file; emf_nam];
    end
    
    if options.fig
        fld_nam = [pwd,filesep,options.folder,filesep,'fig'];
        if exist(fld_nam,'dir') == 0, mkdir(fld_nam); end
        fig_nam = [fld_nam, filesep, options.name, '.fig'];
        
        try saveas(hfig, fig_nam, 'fig'); catch, end
        file = [file; fig_nam];
    end
    delete(eps_tmp); delete(pdf_tmp);
    
end
end


function [hfig,options] = parse_args(varargin)          
% Handle
if ishandle(varargin{end}), hfig = varargin{end};
else                        hfig = get(0, 'CurrentFigure');
end

% Properties
if isstruct(varargin{end}), options = varargin{end};
else                        options = load('figDefaultProperties.mat');
end

% Output name
[options.folder, options.name, ext] = fileparts(varargin{1});
if isempty(options.folder), options.folder = 'plot'; end
switch lower(ext)
    case '.png', options.png = true;
    case '.bmp', options.bmp = true;
    case '.eps', options.eps = true;
    case '.pdf', options.pdf = true;
    case '.emf', options.emf = true;
    case '.fig', options.fig = true;
end

% Options
for a = 2:nargin
    if ischar(varargin{a})
        val = str2double(regexp(varargin{a},'(?<=-(m|p))-?\d*.?\d+','match'));
        if ~isempty(val), inp = varargin{a}(1:2);
        else              inp = varargin{a};
        end
        switch lower(inp(2:end))
            case 'nocrop',  options.crop = false;
            case 'pdf',     options.pdf = true;
            case 'eps',     options.eps = true;
            case 'png',     options.png = true;
            case 'bmp',     options.bmp = true;
            case 'emf',     options.emf = true;
            case 'fig',     options.fig = true;
            case 'rgb',     options.grey = false;
            case 'grey',    options.grey = true;
            case 'gray',    options.grey = true;    
            case 'm',       options.magnify = val;
            case 'p',       options.padding = val;
        end
    end
end
end


function A = rgb2grey(A)
A = cast(reshape(reshape(single(A), [], 3) * single([0.299; 0.587; 0.114]), ...
                         size(A, 1), size(A, 2)), class(A));
end


function b = isvector(options)
    b = options.pdf || options.eps || options.emf || options.fig; 
end


function b = isbitmap(options)
    b = options.png || options.bmp;
end

