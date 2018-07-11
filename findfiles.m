function files = findfiles(wdir,pat,varargin)
% FINDFILES  Recursive path searching using regular expression
%   FILES = FINDFILES(PATH, EXPR) returns a cell array of all filenames
%   matching EXPR found in PATH and any subdirectories of PATH.
%
%   FILES = FINDFILES(PATH, EXPR, MAXDEPTH) will prevent the function from
%   searching greater than MAXDEPTH subdirectories.
%
%   FILES = FINDFILES(PATH, EXPR, 0) prevents recursive directory
%   searching.
%
%   FILES = FINDFILES(PATH, EXPR, MAXDEPTH, true) allows case insensitive
%   regular expression searching
%
%   Note:  The regular expression only searches the filename, and not the entire
%   path as returned

files={};

subdirs = Inf;
icase = false;

% accept optional arguments
switch nargin
    case 2
    case 3
        subdirs = varargin{1};
    case 4
        subdirs = varargin{1};
        icase = varargin{2};
    otherwise
        error('Incorrect number of input parameters entered')
end

% ensure proper path construction
if (wdir(end) ~= filesep)
    wdir = [wdir filesep];
end

list = dir(wdir);
for N = 1:length(list)
    if (~list(N).isdir)
        % check for matching regex
        if icase
            res = regexpi(list(N).name, pat);
        else
            res = regexp(list(N).name, pat);
        end

        % append name if match was found
        if (length(res))
            files = [files ; cellstr([wdir list(N).name])];
        end
    elseif subdirs && ~any(strcmp(list(N).name, {'.' '..'}))
        subdir = [wdir list(N).name];
        files = [files ; findfiles(subdir,pat,subdirs-1,icase)];
    end
end
