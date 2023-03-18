function cf_display2(s, domain)

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

    figure();
    if strcmp(domain,'s')
        imshow(s);
    else
        s = rgb2gray(s);
        f=fft2(s);
        S=fftshift(log(1+abs(f)));
        imshow(S, []);
    end
end