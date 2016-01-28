function varargout = pdftops(cmd)
%PDFTOPS  Calls a local pdftops executable with the input command.
%   [status result] = pdftops(cmd)
% cmd    - Command string to be passed into pdftops.
% status - 0 iff command ran without problem.
% result - Output from pdftops.
% 
% This function requires that you have pdftops (from the Xpdf package)
% installed on your system. You can download this from:
% http://www.foolabs.com/xpdf
%
% Copyright: Oliver Woodford, 2009-2010

    % Call pdftops
    [varargout{1:nargout}] = system(sprintf('"%s" %s', xpdf_path, cmd));
end

function path_ = xpdf_path
    % Return a valid path
    % Start with the currently set path
    path_ = user_string('pdftops');
    % Check the path works
    if check_xpdf_path(path_)
        return
    end
    % Check whether the binary is on the path
    if ispc
        bin = 'pdftops.exe';
    else
        bin = 'pdftops';
    end
    if check_store_xpdf_path(bin)
        path_ = bin;
        return
    end
    % Search the obvious places
    if ispc
        path_ = 'C:\Program Files\xpdf\pdftops.exe';
    else
        path_ = '/usr/local/bin/pdftops';
    end
    if check_store_xpdf_path(path_)
        return
    end
    % Ask the user to enter the path
    while 1
        errMsg = 'Pdftops not found. Please locate the program, or install xpdf-tools from ';
        url = 'http://foolabs.com/xpdf';
        fprintf(2, '%s\n', [errMsg '<a href="matlab:web(''-browser'',''' url ''');">' url '</a>']);
        errMsg = [errMsg url]; %#ok<AGROW>
        if strncmp(computer,'MAC',3) % Is a Mac
            % Give separate warning as the MacOS uigetdir dialogue box doesn't have a title
            uiwait(warndlg(errMsg))
        end
        base = uigetdir('/', errMsg);
        if isequal(base, 0)
            % User hit cancel or closed window
            break;
        end
        base = [base filesep]; %#ok<AGROW>
        bin_dir = {'', ['bin' filesep], ['lib' filesep]};
        for a = 1:numel(bin_dir)
            path_ = [base bin_dir{a} bin];
            if exist(path_, 'file') == 2
                break;
            end
        end
        if check_store_xpdf_path(path_)
            return
        end
    end
    error('pdftops executable not found.');
end

function good = check_store_xpdf_path(path_)
    % Check the path is valid
    good = check_xpdf_path(path_);
    if ~good
        return
    end
    % Update the current default path to the path found
    if ~user_string('pdftops', path_)
        warning('Path to pdftops executable could not be saved. Enter it manually in %s.', fullfile(fileparts(which('user_string.m')), '.ignore', 'pdftops.txt'));
        return
    end
end

function good = check_xpdf_path(path_)
    % Check the path is valid
    [good, message] = system(sprintf('"%s" -h', path_)); %#ok<ASGLU>
    % system returns good = 1 even when the command runs
    % Look for something distinct in the help text
    good = ~isempty(strfind(message, 'PostScript'));
end
