function m = cf_segment(s, thresh_type, thresh)
    % Thresh_Adapt, Thresh_Fixed

    % Default thresh_type to Thresh_Fixed if not provided
    if nargin < 2
        thresh_type = 'Thresh_Fixed';
    end

    %Error Check
    if ~(ischar(thresh_type) || isstring(thresh_type))
        error(['Unsupported Threshold Class Type: ', class(thresh_type)]);
    elseif((strcmp(thresh_type,'Thresh_Adapt') ~= 1) && (strcmp(thresh_type,'Thresh_Fixed') ~= 1))
        error(['Unsupported Threshold Type: ', convertStringsToChars(thresh_type)]);
    elseif strcmp(thresh_type,'Thresh_Adapt') && nargin > 2
        error('Cannot provide custom threshold with thresh_type of Thresh_Adapt.');
    elseif nargin > 2 && (~isscalar(thresh) || ~isnumeric(thresh) || thresh < 0 || thresh > 1)
        error('Threshold must be a scalar numeric value between 0 and 1.');
    end

    % Make sure that s is grayscale
    s = rgb2gray(s);

    if strcmp(thresh_type,'Thresh_Fixed') && nargin < 3
        thresh = graythresh(s); % Ref: 5th Lecture (27/2)
    elseif strcmp(thresh_type,'Thresh_Adapt')
        thresh = adaptthresh(s); % Ref: 5th Lecture (27/2)
    end

    m = imbinarize(s, thresh); % Ref: 5th Lecture (27/2)
end