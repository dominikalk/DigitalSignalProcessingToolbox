function ss = cf_ext_a2(s, noise_filter, noise)
    % 
    % Given an image as an MxN or MxNx3 array, it will enhance the image 
    % by increasing its contrast and reducing its noise. The image must be 
    % grayscale, or it will be converted to it. The image follows one round 
    % of noise reduction, followed by the contrast being increased, followed 
    % by another round of noise reduction. The two rounds of noise reduction
    % gave the best results when the function was being created. The user
    % has a choice between 3 different types of noise reduction, as well as
    % the level of noise reduction. The enhanced image is returned.
    %
    % Usage:     ss = cf_ext_a2(s);
    %            ss = cf_ext_a2(s, noise_filter, noise);
    %
    %            s: image as an MxN or MxNx3 array.
    %            noise_filter: A character string defining the type of
    %               noise reduction filter that should be performed on the image.
    %               Choices are: 'Noise_Adp' (Adaptive), 'Noise_Avg' 
    %                   (Average), or 'Noise_Med' (Median).
    %               Default: 'Noise_Adp'.
    %            noise: Level of noise reduction.
    %               Default: 2.
    %
    % Author:   Dominik Alkhovik
    %
    % Notes:
    % 
    % Not all images seem to be enhanced with this function and those that
    % do may require some manipulation of the noise_filter and noise
    % parameters. E.g. The brain.jpg image given in the lectures can be
    % enhanced with 'Noise_Avg' and noise=3. 

    % Default inputs if not provided
    if nargin < 2
        noise_filter = 'Noise_Adp';
        noise = 2;
    elseif nargin < 3
        noise = 2;
    end

    % Error Checking
    if ~(ischar(noise_filter) || isstring(noise_filter))
        error(['Unsupported Noise Filter Class Type: ', class(noise_filter)]);
    elseif ~strcmp(noise_filter,'Noise_Adp') && ~strcmp(noise_filter,'Noise_Avg') && ~strcmp(noise_filter,'Noise_Med')
        error(['Unsupported Noise Filter Type: ', convertStringsToChars(noise_filter)]);
    elseif ~isnumeric(noise) ||~isscalar(noise) || mod(noise, 1) ~= 0 || noise <= 0
        error('Noise must be a positive integer.');
    end

    % Convert image to grayscale
    s = rgb2gray(s); % Ref: 5th Lecture (27/2) Video: rgb2gray
    % First pass of removing noise
    sn = removenoise(s, noise_filter, noise);
    % Increase contrast of the image
    sae = adapthisteq(sn); % Ref: 5th Lecture (27/2) Video: adapthisteq
    % Second pass of removing noise
    if ~strcmp(noise_filter,'Noise_Avg')
        % Ignored for Noise_Avg as 2nd pass of filtering would make the
        % image blank
        sae = removenoise(sae, noise_filter, noise);
    end

    ss = sae;
end

% Reused code as noise removal is done twice
function s = removenoise(s, noise_filter, noise)
    if strcmp(noise_filter,'Noise_Adp')
        % Ref: https://uk.mathworks.com/help/images/ref/wiener2.html
        s = wiener2(s, [noise noise]);
    elseif strcmp(noise_filter,'Noise_Med')
        % Ref: https://uk.mathworks.com/help/images/noise-removal.html
        s = medfilt2(s, [noise noise]);
    elseif strcmp(noise_filter,'Noise_Avg')
        % Ref: https://uk.mathworks.com/help/images/noise-removal.html
        s = filter2(fspecial('average',noise),s)/255;
    end
end