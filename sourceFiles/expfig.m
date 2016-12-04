function [path] = expfig(varargin)
%EXPFIG - Exports figures in a publication-quality format.
%
% filename      - export filename without extension (string).
% -{format}     - required export extension (multiple possible).
% nocrop        - skip figure border cropping.
% <render>      - option to force type of renderer.
% <colorspace>  - option to define colorspace (rgb, mcyk, grey).
% -m<val>       - optional magnification value of on-screen figure 
%                 pixels to bitmap output file.
% -r<val>       - optional resolution settings value (vector).
% -q<val>       - optional quality settings value (bitmap).
% -p<val>       - optional border box padding (percentage). 
% handle        - handle of figure object to export.
%
% Author: Thomas Beauduin, The University of Tokyo, 2016

drawnow; pause(0.05);
fig = get(0, 'CurrentFigure');
[fig,options] = parse_args(nargout, fig, varargin{:});

if isequal(fig,-1),  return;                % Ensure figure handle
elseif isempty(fig), error('No figure found');
end

set(fig,'Units','pixels');                  % Ghostscript crash otherwise
set(fig, 'InvertHardcopy', 'off');

switch options.renderer                     % Set the renderer
    case 1,     renderer = '-opengl';
    case 2,     renderer = '-zbuffer';
    case 3,     renderer = '-painters';     % Default for vectors
    otherwise,  renderer = '-opengl';       % Default for bitmaps
end

% PART 1
% figure bitmap formats settings and export
if isbitmap(options)
    magnify = options.magnify * options.aa_factor;
    [A, tcol] = print2array(fig, magnify, renderer);    % 1. large version to array
    if options.crop                                     % 2. crop image
        A = crop_borders(A, tcol, options.bb_padding);
    end

    A = downsize(A, options.aa_factor);                 % 3. downscale the image
    if options.colourspace==2, A = rgb2grey(A);         % 4. color options
    else                       A = check_greyscale(A);
    end

    if options.png                                      % 5. generate image
        if exist(strcat(pwd,'/plot/png'),'dir') == 0
            mkdir('plot/png');
        end
        res = options.magnify * get(0, 'ScreenPixelsPerInch') / 25.4e-3;
        imwrite(A,[options.name,'.png'],'ResolutionUnit','meter',...
                                      'XResolution',res,'YResolution',res);
    end
    
    if options.bmp
        if exist(strcat(pwd,'/plot/bmp'),'dir') == 0
            mkdir('plot/bmp');
        end
        bmp_nam = ['plot/bmp/',options.name,'.bmp'];
        imwrite(A, bmp_nam); 
    end
end

% PART 2
% figure vector formats settings and export
if isvector(options)
    if ~options.renderer, renderer = '-painters'; end
    options.rendererStr = renderer;

    tmp_nam = [tempname '.eps'];        % Generate some filenames
    try                                 % Ensure temp dir is writable
        fid = fopen(tmp_nam,'w');
        fwrite(fid,1); fclose(fid);
        delete(tmp_nam);
        isTempDirOk = true;
    catch                               % use user-specified folder
        [~,fname,fext] = fileparts(tmp_nam);
        fpath = fileparts(options.name);
        tmp_nam = fullfile(fpath,[fname fext]);
        isTempDirOk = false;
    end
    if isTempDirOk, pdf_nam_tmp = [tempname '.pdf'];
    else            pdf_nam_tmp = fullfile(fpath,[fname '.pdf']);
    end
    
    if options.pdf                      % generate pdf
        if exist(strcat(pwd,'/plot/pdf'),'dir') == 0
            mkdir('plot/pdf');
        end
        pdf_nam = ['plot/pdf/' options.name '.pdf'];
        try copyfile(pdf_nam, pdf_nam_tmp, 'f'); catch, end
    else
        pdf_nam = pdf_nam_tmp;
    end

    p2eArgs = {renderer,sprintf('-r%d',options.resolution)}; %print options
    try
        print2eps(tmp_nam, fig, options, p2eArgs{:});
        if options.colourspace==1, rgb2cmyk(tmp_nam); end
        eps2pdf(tmp_nam,pdf_nam_tmp,1,false, ...
                options.colourspace==2,options.quality,options.gs_options);
        try movefile(pdf_nam_tmp, pdf_nam, 'f'); catch, end
    catch ex
        delete(tmp_nam);
        rethrow(ex);
    end
    delete(tmp_nam);

    if options.eps              % Generate eps from pdf
        if exist(strcat(pwd,'/plot/eps'),'dir') == 0
            mkdir('plot/eps');
        end
        try
            eps_nam_tmp = strrep(pdf_nam_tmp,'.pdf','.eps');
            pdf2eps(pdf_nam, eps_nam_tmp);
            eps_nam = ['plot/eps/' options.name '.eps'];
            movefile(eps_nam_tmp, eps_nam, 'f');
        catch ex
            if ~options.pdf
                delete(pdf_nam); % Delete the pdf
            end
            try delete(eps_nam_tmp); catch, end
            rethrow(ex);
        end
        if ~options.pdf
            delete(pdf_nam);    % Delete the pdf
        end
    end
    
    if options.emf              % Generate emf from pdf
        if exist(strcat(pwd,'/plot/emf'),'dir') == 0
            mkdir('plot/emf');
        end
        emf_nam = ['plot/emf/' options.name '.emf'];
        print(emf_nam,'-dmeta',sprintf('-r%d',600));
    end
    
    if options.fig
        if exist(strcat(pwd,'/plot/fig'),'dir') == 0
            mkdir('plot/fig');
        end
        fig_nam = ['plot/fig/' options.name '.fig'];
        saveas(fig,fig_nam,'fig');
    end
    
    if options.png
        if exist(strcat(pwd,'/plot/png'),'dir') == 0
            mkdir('plot/png');
        end
        png_nam = ['plot/png/' options.name '.png'];
        saveas(fig,png_nam,'png');
    end    
end
% https://wiki.iac.ethz.ch/IT/LinuxConvertFiles#Convert_Matlab_EPS_Files

% PART 3
% Output path to created files
path=[];
if options.png, path=[path;strcat(pwd,png_nam)]; end
if options.bmp, path=[path;strcat(pwd,bmp_nam)]; end
if options.pdf, path=[path;strcat(pwd,pdf_nam)]; end
if options.eps, path=[path;strcat(pwd,eps_nam)]; end
if options.emf, path=[path;strcat(pwd,emf_nam)]; end
if options.fig, path=[path;strcat(pwd,fig_nam)]; end
end

function [fig, options] = parse_args(nout, fig, varargin)
% PARSE_ARGS - Set the default options for expfig.

options = struct(...
    'name', 'expfig_out', ...
    'crop', true, ...
    'renderer', 0, ... % 0:default, 1:OpenGL, 2:ZBuffer, 3:Painters
    'pdf', false, ...
    'eps', false, ...
    'png', false, ...
    'bmp', false, ...
    'emf', false, ...
    'fig', true, ...
    'colourspace', 0, ... % 0:RGB, 1:CMYK, 2:gray
    'im', nout == 1, ...
    'aa_factor', 0, ...
    'bb_padding', 0.01, ...
    'magnify', [], ...
    'resolution', [], ...
    'quality', [], ...
    'gs_options', {{}});

% Go through the arguments
for a = 1:nargin-2
    if all(ishandle(varargin{a}))
        fig = varargin{a};
    elseif ischar(varargin{a}) && ~isempty(varargin{a})
        if varargin{a}(1) == '-'
            switch lower(varargin{a}(2:end))
                case 'nocrop',  options.crop = false;
                case 'pdf',     options.pdf = true;
                case 'eps',     options.eps = true;
                case 'png',     options.png = true;
                case 'bmp',     options.bmp = true;
                case 'emf',     options.emf = true;
                case 'fig',     options.fig = true;
                case 'rgb',     options.colourspace = 0;
                case 'cmyk',    options.colourspace = 1;
                case 'grey',    options.colourspace = 2;
                case 'gray',    options.colourspace = 2;    
                otherwise
                    if strcmpi(varargin{a}(1:2),'-d')
                        varargin{a}(2) = 'd';
                        options.gs_options{end+1} = varargin{a};
                    else
                        val = str2double(regexp(varargin{a}, '(?<=-(m|M|r|R|q|Q|p|P))-?\d*.?\d+', 'match'));
                        switch lower(varargin{a}(2))
                            case 'm', options.magnify = val;
                            case 'r', options.resolution = val;
                            case 'q', options.quality = max(val, 0);
                            case 'p', options.bb_padding = val;
                        end
                    end
            end
        else
            [p, options.name, ext] = fileparts(varargin{a});
            if ~isempty(p)
                options.name = [p filesep options.name];
            end
            switch lower(ext)
                case '.png', options.png = true;
                case '.bmp', options.bmp = true;
                case '.eps', options.eps = true;
                case '.pdf', options.pdf = true;
                case '.emf', options.emf = true;
                case '.fig', options.fig = true;
                otherwise,   options.name = varargin{a};
            end
        end
    end
end

% Do border padding with repsect to a cropped image
if options.bb_padding, options.crop = true; end

% Set default anti-aliasing now we know the renderer
if options.aa_factor == 0
    try isAA = strcmp(get(ancestor(fig, 'figure'), 'GraphicsSmoothing'), 'on'); catch, isAA = false; end
    options.aa_factor = 1 + 2 * (~(using_hg2(fig) && isAA) | (options.renderer == 3));
end

% Convert user dir '~' to full path
if numel(options.name) > 2 && options.name(1) == '~' && (options.name(2) == '/' || options.name(2) == '\')
    options.name = fullfile(char(java.lang.System.getProperty('user.home')), options.name(2:end));
end

% Compute the magnification and resolution
if isempty(options.magnify)
    if isempty(options.resolution)
        options.magnify = 1;
        options.resolution = 864;
    else
        options.magnify = options.resolution ./ get(0,'ScreenPixelsPerInch');
    end
elseif isempty(options.resolution)
    options.resolution = 864;
end

if ~isvector(options) && ~isbitmap(options)     % default format
    options.pdf = true;
end
end

function A = downsize(A, factor)
if factor == 1, return 
end
try
    % Faster, but requires image processing toolbox
    A = imresize(A, 1/factor, 'bilinear');
catch
    % No image processing toolbox - resize manually
    % Lowpass filter - use Gaussian as is separable, so faster
    % Compute the 1d Gaussian filter
    filt = (-factor-1:factor+1) / (factor * 0.6);
    filt = exp(-filt .* filt); filt = single(filt / sum(filt));
    padding = floor(numel(filt) / 2);
    for a = 1:size(A, 3)
        A(:,:,a)=conv2(filt,filt',single(A([ones(1, padding) 1:end repmat(end, 1, padding)],...
                                           [ones(1, padding) 1:end repmat(end, 1, padding)],a)), 'valid');
    end
    A = A(1+floor(mod(end-1, factor)/2):factor:end,1+floor(mod(end-1, factor)/2):factor:end,:);
end
end

function A = rgb2grey(A)
A = cast(reshape(reshape(single(A), [], 3) * single([0.299; 0.587; 0.114]), ...
                         size(A, 1), size(A, 2)), class(A));
end

function A = check_greyscale(A)
    if size(A, 3) == 3 && ...
            all(reshape(A(:,:,1) == A(:,:,2), [], 1)) && ...
            all(reshape(A(:,:,2) == A(:,:,3), [], 1))
        A = A(:,:,1); % Save only one channel for 8-bit output
    end
end

function b = isvector(options)
    b = options.pdf || options.eps || options.emf || options.fig; 
end

function b = isbitmap(options)
    b = options.png || options.bmp || options.im;
end

function rgb2cmyk(fname)
try
    % Read the EPS file into memory
    fstrm = read_write_entire_textfile(fname);

    % Replace all gray-scale colors
    fstrm = regexprep(fstrm, '\n([\d.]+) +GC\n', '\n0 0 0 ${num2str(1-str2num($1))} CC\n');

    % Replace all RGB colors
    fstrm = regexprep(fstrm, '\n[0.]+ +[0.]+ +[0.]+ +RC\n', '\n0 0 0 1 CC\n');  % pure black
    fstrm = regexprep(fstrm, '\n([\d.]+) +([\d.]+) +([\d.]+) +RC\n', '\n${sprintf(''%.4g '',[1-[str2num($1),str2num($2),str2num($3)]/max([str2num($1),str2num($2),str2num($3)]),1-max([str2num($1),str2num($2),str2num($3)])])} CC\n');

    % Overwrite the file with the modified contents
    read_write_entire_textfile(fname, fstrm);
catch
end
end

function fstrm = read_write_entire_textfile(fname, fstrm)
    modes = {'rt', 'wt'};
    writing = nargin > 1;
    fh = fopen(fname, modes{1+writing});
    if fh == -1
        error('Unable to open file %s.', fname);
    end
    try
        if writing, fwrite(fh, fstrm, 'char*1');
        else        fstrm = fread(fh, '*char')';
        end
    catch ex
        fclose(fh);
        rethrow(ex);
    end
    fclose(fh);
end
