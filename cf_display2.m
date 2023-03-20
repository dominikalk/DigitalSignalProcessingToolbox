function cf_display2(s, domain)
    % 
    % Given an image, it will display the image in either spacial or
    % frequency domain.
    %
    % Usage:     cf_display2(s);
    %            cf_display2(s, domain);
    %
    %            s: image as an MxN or MxNx3 array.
    %            domain: A character string defining the domain the image
    %               should be displayed in. 
    %               Choices are: 's' (spacial) or 'f' (frequency).
    %               Default: 's'.
    %
    % Author:   Dominik Alkhovik

    % Default domain to s (spacial) if not provided
    if nargin < 2
        domain = 's';
    end

    % Error Check
    if ~(ischar(domain) || isstring(domain))
        error(['Unsupported Domain Class Type: ', class(domain)]);
    elseif((strcmp(domain,'s') ~= 1) && (strcmp(domain,'f') ~= 1))
        error(['Unsupported Domain Type: ', convertStringsToChars(domain)]);
    end

    % Display image in spacial or frequency domain depending on input
    figure();
    if strcmp(domain,'s')
        imshow(s); % Ref: 5th Lecture (27/2)
    else
        % Ref: https://uk.mathworks.com/matlabcentral/answers/261707-how-to-convert-an-image-to-frequency-domain-in-matlab
        % Convert to grayscale
        s = rgb2gray(s);
        % Show image in frequency domain
        f=fft2(s);
        S=fftshift(log(1+abs(f)));
        imshow(S, []);
    end
end