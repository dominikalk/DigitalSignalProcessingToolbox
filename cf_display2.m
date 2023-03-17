function cf_display2(s, domain)

    % Default domain to t (time) if not provided
    if nargin < 2
        domain = 's';
    end

    % Error check to make sure domain is a character and equal
    % to either 's' of 'f'
    if ~ischar(domain)
        error("Domain must be of type char, not %s.", class(domain));
    elseif domain ~= 's' && domain ~= 'f'
        error("Domain must be char 's' (Spatial) or 'f' (Frequency).");
    end

    if domain == 's'
        imshow(s);
    else
    end
end