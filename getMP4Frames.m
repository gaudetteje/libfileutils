function varargout = getMP4Frames(varargin)
% GETMP4FRAMES  extracts/converts frames from an MP4 video
%
% F = getMP4Frames(vidname,fNum) returns a single frame number as an
%   image matrix, F
% getMP4Frames(vidname,fNum) without specifying a return variable
%   converts the frames to TIFF images stored in the same directory as the
%   MP4 file

% set default parameters to be empty
params = {'',[],false};

%nArgs = numel(varargin);

params(1:nargin) = varargin;

% assign input variables
[vidname,fNum,PLOTFLAG] = params{:};

% specify file name
if isempty(vidname)
    vidname = uigetfile('*.MP4','Select a video file');
end

% split path and file name
[pname,prefix,ext] = fileparts(vidname);
if ~existfile(vidname)
    error('Try entering the right filename, dumbass!')
end

% prompt for frame number if not entered as input
if isempty(fNum)
    fNum = inputdlg('Enter the frame number(s) to extract');
    fNum = str2num(fNum{1});
end
fNum = unique(round(fNum));

% load file
obj = VideoReader(vidname);

% iterate over each frame
for n = 1:numel(fNum)
 
    % read frame number
    F = read(obj,fNum(n));

    % show image in new figure window
    if PLOTFLAG
        figure(n)
        imshow(F)
        title(sprintf('%s - frame %d', vidname, fNum(n)),'interpreter','none')
    end
    
    % write image file
    if ~nargout
        imname = sprintf('%s_%d.tiff', prefix, fNum(n));
        imwrite(F,imname,'TIFF')
    end
end

% assign output variable
if nargout == 1
    F = varargout{1};
end
