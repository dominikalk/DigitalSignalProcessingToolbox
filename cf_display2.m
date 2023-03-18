function cf_display2(s, domain)

    % Default domain to t (time) if not provided
    if nargin < 2
        domain = 's';
    end

    %Error Check
    if ~(ischar(domain) || isstring(domain))
        error(['Unsupported Domain Class Type: ', class(domain)]);
    elseif((strcmp(domain,'s') ~= 1) && (strcmp(domain,'f') ~= 1))
        error(['Unsupported Domain Type: ', convertStringsToChars(domain)]);
    end

    if strcmp(domain,'s')
        imshow(s);
    else
        imhist(s);
    end
end