function Pout = cp_nrrd2nifti(Pin,opt)
% Function to convert one (or more) NRRD image(s) into NIFTI formt.
%
% First the header and data from the NRRD images is read in then is written
% into a (.nii) Nifti file. This relies on the NRRD reader functions from
% Gregory Jefferis (https://github.com/jefferis) and SPM12.
%_______________________________________________________________________
% Copyright (C) 2016 Cyclotron Research Centre

% Written by C. Phillips.
% Cyclotron Research Centre & % GIGA in silico medicine
% University of Liege, Belgium

% NOTE:
% Not happy with the way the orientation of the axis is defined!
% There is a very ad hoc hack for the MS data to treat... :-(

if nargin<2, opt = []; end %#ok<*NASGU>

if nargin<1
    Pin = spm_select(Inf, 'any', 'Select NRRD image(s)','' ,pwd, ...
        '\.[nn][hr][dr][rd]');
end
nImg = size(Pin,1);
Po = cell(nImg,1);

for ii=1:nImg
    Po{ii} = convert1NRRDimage(deblank(Pin(ii,:)),opt);
end
Pout = char(Po);

end
%%
%% SUBFUNCTION doing the job for 1 image
function Po = convert1NRRDimage(Pi,opt) %#ok<*INUSD>

% Read data & header with readnrrd functions
[ data, info ] = readnrrd( Pi );

% Collect image information
dt(1) = spm_type(info.type);
switch info.endian % checking endian-ness
    case 'l', dt(2) = 0; % little
    case 'b', dt(2) = 1; % big
end

sc = diag([info.Delta 1]);
rot = eye(4);
if isfield(info.nrrdfields,'space')
    switch deblank(info.nrrdfields.space)
        case 'left-posterior-superior' %| 'LPS'
            rot(1,1) = -1 ; rot(2,2) = -1;
            rot = rot * [0 1 0 0 ; 1 0 0 0 ; 0 0 1 0 ; 0 0 0 1];
        case 'right-anterior-superior' | 'RAS'
            % do nothing
        otherwise
            errors('nrrd2nifti','Can''t deal with this orientation.')
    end
else
    warning('Assuming LPS orientation')
    rot(1,1) = -1 ; rot(2,2) = -1;
    rot = rot * [0 1 0 0 ; 1 0 0 0 ; 0 0 1 0 ; 0 0 0 1];
end

trans = eye(4); trans(1:3,4) = -info.size'/2;
mtx = rot * sc * trans;

% Create spm_vol info
V = struct('fname',   spm_file(info.Filename,'ext','nii'),...
    'dim',     info.size,...    % image size
    'dt',      dt,...           % format
    'pinfo',   [1 0 352]',...    % scaling and hdr size
    'mat',     mtx,...
    'n',       [1 1],...
    'descrip', 'NIFTI imported from NRRD',...
    'private', []);
V = spm_create_vol(V);
V = spm_write_vol(V,data);

% Ooutput
Po = V.fname;

end