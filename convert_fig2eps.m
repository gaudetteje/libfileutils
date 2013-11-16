function convert_fig2eps(varargin)
% CONVERT_FIG2EPS  Converts MATLAB figures to EPS format using the built-in
% print utility
%
% convert_fig2eps - scans current directory for all .fig files and converts
%     them to .eps in the same directory
% convert_fig2eps(SRCPATH) - scans the directory, SRCPATH, for .fig files
% convert_fig2eps(SRCNAME) - accepts a single filename as a string, or
%     multiple filenames as a cell array of strings
% convert_fig2eps(SRCNAME,DSTPATH) - saves converted files to the
%     destination directory, DSTPATH
% convert_fig2eps(SRCNAME,DSTNAME) - saves each converted file to the
%     filename in DSTNAME.  If a cell array of strings, DSTNAME must match
%     the length of SRCNAME.  Relative or absolute paths may be included.


% default processing options
EPS = true;
PDF = false;
res = 300;

% default paths
src = '.';
dst = '.';

switch nargin
    case 2
        src = varargin{1};
        dst = varargin{2};
    case 1
        src = varargin{1};
        dst = src;
    case 0
    otherwise
        error('Incorrect number of parameters entered')
end


% parse input parameters
if ischar(src)
    % if path entered, locate all files in specified path
    if exist(src,'dir')
        src = findfiles(src,'\.fig$');
    % if filename entered, verify it exists
    elseif exist(src,'file')
        src = {src};
        %[pname,fname,~] = fileparts(src);
        %if isempty(pname)
        %    pname = '.';
        %end
    % otherwise, locate full or partial filename matches
    else
        [pname,fname,ext] = fileparts(src);
        if isempty(pname); pname = '.'; end
        if isempty(strfind(ext,'fig')); fname = [fname ext]; end
        src = findfiles('.',[fname '\.fig$']);
    end
end

if ischar(dst)
    if exist(dst,'dir')
        dst = repmat({dst},numel(src),1);
    else
        dst = {dst};
    end
end

assert(all(size(dst) == size(src)),'Source and destination arrays must have an equal number of elements!')


% iterate over each file
for f = 1:numel(src)
    srcname = src{f};
    dstname = dst{f};
    
    % reuse src filename if dstname is a path
    if exist(dstname,'dir')
        [~,prefix,~] = fileparts(srcname);
        dstname = fullfile(dstname,prefix); % omit extension for now
    end
    
    if ~existfile(srcname)
        warning('CONVERT_FIG2EPS:FileNotFound','Could not find source file "%s"!',srcname)
        continue
    end
    
    % open figure
    fh = openfig(srcname,'new','invisible');
    fPos = get(gcf, 'Position');
    set(gcf, 'PaperPositionMode', 'auto');
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperSize', fPos(3:4)/72);
    
    if EPS
        dstname = [dstname '.eps'];
        fprintf('Converting "%s" to "%s"...',srcname,dstname);
        
        eval(sprintf('print -depsc2 -r%d %s', res, dstname));
        
        fprintf('  Done!\n');
    end
    if PDF
        dstname = [dstname '.pdf'];
        fprintf('Converting "%s" to "%s"...',srcname,dstname);
        
        eval(sprintf('print -dpdf -r%d %s', res, dstname));
        
        fprintf('  Done!\n');
    end
    
    close(fh)
end
