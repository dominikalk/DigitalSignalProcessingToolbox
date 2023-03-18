function s = cf_ext_a2(s, noise_filter, noise)

    % Default inputs if not provided
    if nargin < 2
        noise_filter = 'Noise_Adp';
        noise = 5;
    elseif nargin < 3
        noise = 5;
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
    % Ref: 5th Lecture (27/2) Video: rgb2gray
    s = rgb2gray(s);
    % First pass of removing noise
    sn = removenoise(s, noise_filter, noise);
    % Increase contrast of the image
    % Ref: 5th Lecture (27/2) Video: adapthisteq
    sae = adapthisteq(sn);
    % Second pass of removing noise
    if ~strcmp(noise_filter,'Noise_Avg')
        sae = removenoise(sae, noise_filter, noise);
    end

    s = sae;
end

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