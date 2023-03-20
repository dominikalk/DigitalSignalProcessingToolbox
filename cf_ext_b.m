function ss = cf_ext_b(s, f, b, Q)
    % 
    % This function performs variable band equalisation on a signal s 
    % based on the input vector f containing the center frequencies and 
    % the input vector b containing the gain in decibels. It uses a
    % combination of shelving and peaking filters written by Jeff Tackett
    % (referenced where used) which are IIR filters. For each frequency 
    % band, either a shelving IIR filter is applied (lowest and highest 
    % bands) or a peaking IIR filter is applied (middle bands or if only 
    % 1 band is given). The equalised signal is normalised and returned in 
    % the same format as the input.
    %
    % Usage:     ss = cf_ext_b(s, f, b);
    %            ss = cf_ext_b(s, f, b, Q);
    %
    %            s: The signal as a structure with fields y and Fs
    %            f: 1D vector with 1xN numeric elements that correspond to
    %               the central frequencies to be equalised. 
    %            b: 1D vector with 1xN numeric elements that correspond to
    %               each of the central frequencies in f. Each element is 
    %               the gain in decibels.
    %            Q: adjusts the slope of equalisation.
    %               Default: 3.
    %
    % Author:   Dominik Alkhovik

    if nargin < 4
        Q = 3;
    end

    % Error check
    if any([size(b, 1) ~= 1, size(f, 1) ~= 1, size(b) ~= size(f), size(f, 2) == 0]) 
        error('f and b must be 1xN sized vectors with at least 1 element and be the same size.');
    elseif ~isnumeric(b)
        error('All elements of f and b must be numeric.');
    elseif ~isscalar(Q) || ~isnumeric(Q) || ~(Q > 0)
        error('Q must be a positive, scalar, numeric value.');
    end

    % Deconstruct s for readability
    y = s.y;
    Fs = s.Fs;

    % Apply peaking filter if only 1 frequency, 2 shelving filters if 2
    % frequencies, and a combination if 3 or greater.
    if size(f, 2) == 1
        % Apply peaking filter for sole band
        % Ref: https://uk.mathworks.com/matlabcentral/fileexchange/16567-peaking-notch-iir-filter
        [c, a] = peaking(b(1), f(1), Q, Fs);
        y = filter(c, a, y);
    else
        % Apply Base_Shelf filter to lowest band
        % Ref: https://uk.mathworks.com/matlabcentral/fileexchange/16568-bass-treble-shelving-filter
        % Ref: 4th Lecture (20/2)
        [c, a] = shelving(b(1), f(1), Fs, Q, 'Base_Shelf');
        y = filter(c, a, y);
    
        if size(f, 2) > 2
            % Apply peaking filter for middle bands
            % Ref: https://uk.mathworks.com/matlabcentral/fileexchange/16567-peaking-notch-iir-filter
            for i = 2:size(f, 2) - 1
                [c, a] = peaking(b(i), f(i), Q, Fs);
                y = filter(c, a, y);
            end
        end
    
        % Apply Base_Treble filter to highest band
        % Ref: https://uk.mathworks.com/matlabcentral/fileexchange/16568-bass-treble-shelving-filter
        % Ref: 4th Lecture (20/2)
        [c, a] = shelving(b(size(f, 2)), f(size(f, 2)), Fs, Q, 'Treble_Shelf');
        y = filter(c, a, y);
    end

    % Normalise
    maxy = max(abs(y));
    y = y/maxy;

    ss = struct("y", y, "Fs", Fs);
end