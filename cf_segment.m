function m = cf_segment(s, thresh_type, thresh)
    % 
    % Given an image as an MxNx3 or MxN array, it will segment it into the
    % foreground and background aspects by producing a binary mask m 
    % labelling foreground pixels 1 and background pixels 0. m is then
    % returned.
    %
    % Usage:     m = cf_segment(s, thresh_type, thresh)
    %
    %            s: image as an MxN or MxNx3 array.
    %            thresh_type: A character string defining the type of
    %               threshold to be generated or used for segmenting the
    %               image.
    %               Choices are: 'Thresh_Adapt' (Adaptive) or 
    %                   'Thresh_Fixed' (Fixed).
    %               Default: 'Thresh_Fixed'.
    %            thresh: Given thresh_type has been manually set to be
    %               'Thresh_Fixed', you can specify a custom threshold 
    %               between 0 and 1 for the segmentation.
    %               Default: generated with "graythresh"
    %
    % Author:   Dominik Alkhovik

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

    % Define the threshold for the segmentation if not manually provided
    if strcmp(thresh_type,'Thresh_Fixed') && nargin < 3
        thresh = graythresh(s); % Ref: 5th Lecture (27/2)
    elseif strcmp(thresh_type,'Thresh_Adapt')
        thresh = adaptthresh(s); % Ref: 5th Lecture (27/2)
    end

    % Generate the binary mask
    m = imbinarize(s, thresh); % Ref: 5th Lecture (27/2)
end