function Im = fstack(Scene, varargin)
%fstack
%Focus stacking.
%
%SINTAX:
%   Im = focus(Images)
%   Im = focus(Images, 'focus', u, ...)
%   Im = focus(Images, opt1, val1, opt2, val2,...)
%
%DESCRIPTION:
%Generate all-in-focus (AIF) image from focus sequence.
%
%OUTPUTS:
% Im,       is the AIF image
%INPUTS:
% images,   is a cell array where each cell is an image 
%           (or a string with the path of an image).
% Options and their values (default in perenthesis)
% may be any of the following:
%   'FSize',      Size of focus measure window (9).
%   'Focus',      Vector with the focus of each frame.
%   'Alpha',      Parameter of the AIF algorithm (0.2).
%   'Sth',        Parameter of the AIF algorithm (13).%   
%
%For further details, see:
%Pertuz et. al. "Generation of all-in-focus images by
%noise-robust selective fusion of limited depth-of-field
%images" IEEE Trans. Image Process (in print).
%
%Said Pertuz
%Sep14/2011



%Parse inputs:
Options = ParseImdata(Scene);
Options = ParseInputs(Options, varargin{:});
M = Options.Size(1);
N = Options.Size(2);
P = Options.Size(3);

%********* Read images and compute fmeasure **********
%Initialize:
FM = zeros(Options.Size);
if Options.RGB
    ImagesR = zeros(Options.Size);
    ImagesG = zeros(Options.Size);
    ImagesB = zeros(Options.Size);    
else
    ImagesG = zeros(Options.Size);
end

%Read:
% fprintf('Fmeasure     ')
for p = 1:P
    if Options.STR, Im = (imread(Scene{p}));
    else Im = Scene{p};
    end
    if Options.RGB
        ImagesR(:,:,p) = Im(:,:,1);
        ImagesG(:,:,p) = Im(:,:,2);
        ImagesB(:,:,p) = Im(:,:,3);
        Im = rgb2gray(Im);
    else
        ImagesG(:,:,p) = Im;
    end
    FM(:,:,p) = gfocus(im2double(Im), Options.WSize);
%     fprintf('\b\b\b\b\b[%2.0i%%]',round(100*p/P))
end

%********** Compute Smeasure ******************
% fprintf('\nSMeasure     ')
[u s A Fmax] = gauss3P(Options.Focus, FM);
%Aprox. RMS of error signal as sum|Signal-Noise|
%instead of sqrt(sum(Signal-noise)^2):
Err = zeros(M,N);
for p = 1:P
    Err = Err + abs( FM(:,:,p) - ...
        A.*exp(-(Options.Focus(p)-u).^2./(2*s.^2)));
    FM(:,:,p) = FM(:,:,p)./Fmax;
%     fprintf('\b\b\b\b\b[%2.0i%%]',round(100*p/P))
end
H = fspecial('average', Options.WSize);
inv_psnr = imfilter(Err./(P*Fmax), H, 'replicate');

S = 20*log10(1./inv_psnr);
% S(isnan(S))=min(S(:));
% fprintf('\nWeights      ')
Phi = 0.5*(1+tanh(Options.Alpha*(S-Options.Sth)))/...
   Options.Alpha;
% Phi = 0.5*(1+tanh(Options.Alpha*(S-Options.Sth)));
% Phi(isnan(Phi)) = min(Phi(:));
% Phi = medfilt2(Phi, [3 3]);
%********** Compute weights: ********************
fun = @(phi,fm) 0.5+0.5*tanh(phi.*(fm-1));
for p = 1:P    
    FM(:,:,p) = feval(fun, Phi, FM(:,:,p));
%     fprintf('\b\b\b\b\b[%2.0i%%]',round(100*p/P))
end

%********* Fuse images: *****************
% fprintf('\nFusion ')
FMn = sum(FM,3);
if Options.RGB
    Im(:,:,1) = uint8(sum((ImagesR.*FM), 3)./FMn);
    Im(:,:,2) = uint8(sum((ImagesG.*FM), 3)./FMn);
    Im(:,:,3) = uint8(sum((ImagesB.*FM), 3)./FMn);
else
    Im = uint16(sum((ImagesG.*FM), 3)./FMn);
end
% fprintf('[100%%]\n')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u s A Ymax] = gauss3P(x, Y)
%Internal parameter:
STEP = 2;
%%%%%%%%%%%%%%%%%%%
[M,N,P] = size(Y);
[Ymax, I] = max(Y,[ ], 3);
[IN,IM] = meshgrid(1:N,1:M);
Ic = I(:);
Ic(Ic<=STEP)=STEP+1;
Ic(Ic>=P-STEP)=P-STEP;
Index1 = sub2ind([M,N,P], IM(:), IN(:), Ic-STEP);
Index2 = sub2ind([M,N,P], IM(:), IN(:), Ic);
Index3 = sub2ind([M,N,P], IM(:), IN(:), Ic+STEP);
Index1(I(:)<=STEP) = Index3(I(:)<=STEP);
Index3(I(:)>=STEP) = Index1(I(:)>=STEP);
x1 = reshape(x(Ic(:)-STEP),M,N);
x2 = reshape(x(Ic(:)),M,N);
x3 = reshape(x(Ic(:)+STEP),M,N);
y1 = reshape(log(Y(Index1)),M,N);
y2 = reshape(log(Y(Index2)),M,N);
y3 = reshape(log(Y(Index3)),M,N);
c = ( (y1-y2).*(x2-x3)-(y2-y3).*(x1-x2) )./...
    ( (x1.^2-x2.^2).*(x2-x3)-(x2.^2-x3.^2).*(x1-x2) );
b = ( (y2-y3)-c.*(x2-x3).*(x2+x3) )./(x2-x3);
s = sqrt(-1./(2*c));
u = b.*s.^2;
a = y1 - b.*x1 - c.*x1.^2;
A = exp(a + u.^2./(2*s.^2));
% Fmax = x(I);
% IDX = imag(u)~=0|isnan(u);
% u(IDX) = Fmax(IDX);
% A(IDX) = 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function FM = gfocus(Image, WSize)
MEANF = fspecial('average',[WSize WSize]);
U = imfilter(Image, MEANF, 'replicate');
FM = (Image-U).^2;
FM = imfilter(FM, MEANF, 'replicate');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Options = ParseInputs(Opts,varargin) 
Options = Opts;
N = length(varargin);
Options.Alpha = 0.2;
Options.Sth = 13;
Options.Focus = 1:Opts.Size(3);
Options.WSize = 9;
Params = {'alpha','sth','focus',...
    'fsize'};
if (N==1)
    eid = 'DepthMap:InputCheck';
    warning(eid, 'missing parameter, setting to deffault')
    return
end
for n = 1:2:N
    if ~ischar(varargin{n})
        error('Please check input arguments. Probably one value is missing')
    elseif isempty(strmatch(lower(varargin{n}), Params))
        error('Unknown option %s.', upper(varargin{n}))
    elseif (N < n + 1)
        error('Value for option %s is missing', upper(varargin{n}))
    else
        Select = strmatch(lower(varargin{n}), Params, 'exact');
        str = Params{Select};
        Value = varargin{n+1};
    end
    if strcmpi(str,'fsize')
        if ~isnumeric(Value)
            error('Value for parameter FOCUSSIZE must be numeric');
        elseif numel(Value)~=1
            error('Value for parameter FOCUSSIZE must be a scalar');
        else
            Options.WSize = Value;
        end
    elseif strcmp(str,'focus')
        if ~isnumeric(Value)
            error('FOCUS vector must be numeric')
        elseif numel(Value)~=Opts.Size(3)
            error('FOCUS vector must have %s elements',Opts.Size(3))
        else
            Options.Focus = Value;
        end    
    elseif strcmp(str,'alpha')
        if ~isnumeric(Value)
            error('ALPHA must be numeric')
        elseif (Value>1)||(Value<=0)
            error('ALPHA must be in (0,1]')
        else
            Options.Alpha = Value;
        end
    elseif strcmp(str, 'sth')
        if ~isnumeric(Value)
            error('STH must be numeric')
        else
            Options.Sth = Value;
        end           
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Options = ParseImdata(Imdata)
P = length(Imdata);
if ~iscell(Imdata)
    error('First input must be a cell array')
end

Options.RGB = false;
Options.STR = false;
if ischar(Imdata{1})
    Options.STR = true;
    if ~exist(Imdata{1},'file')
        error('File %s doesnt exist!',Imdata{1})
    else
        %Im = imread(Imdata{1});
        Im = imread(Imdata{1});
        Options.Size(1) = size(Im, 1);
        Options.Size(2) = size(Im, 2);
        Options.Size(3) = P;
    end
else
    Im = Imdata{1};
end
if (ndims(Im)==3)
    Options.RGB = true;
elseif (ndims(Im)~=2)
    error('Images must be RGB or grayscale!')
end
end