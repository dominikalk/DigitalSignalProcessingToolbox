function ss = cf_equalise(s, b)
    % 
    % This function performs multiband equalisation on a signal s based on
    % the input vector b containing the gain in decibels. It uses a
    % combination of shelving and peaking filters written by Jeff Tackett
    % (referenced where used) which are IIR filters. For each frequency 
    % band, either a shelving IIR filter is applied (lowest and highest 
    % bands) or a peaking IIR filter is applied (middle bands). The 
    % equalised signal is normalised and returned in the same format as 
    % the input.
    %
    % Usage:     ss = cf_equalise(s, b);
    %
    %            s: The signal as a structure with fields y and Fs
    %            b: 1D vector with 11 numeric elements that correspond to
    %               each of the 11 frequency bands. Each element is the gain
    %               in decibels.
    %
    % Author:   Dominik Alkhovik

    % Error check to ensure b is 1D vector of 11 numeric elements
    if ~all(size(b) == [1, 11])
        error('b must be a 1D vector with 11 elements.');
    elseif ~isnumeric(b)
        error('All elements of b must be numeric.');
    end

    % Initialise band frequencies
    bf = [16, 31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];

    % Deconstruct s for readability
    y = s.y;
    Fs = s.Fs;
    Q = 3;

    % Apply Base_Shelf filter to lowest band
    % Ref: https://uk.mathworks.com/matlabcentral/fileexchange/16568-bass-treble-shelving-filter
    % Ref: 4th Lecture (20/2)
    [c, a] = shelving(b(1), bf(1), Fs, Q, 'Base_Shelf');
    y = filter(c, a, y);

    % Apply peaking filter for middle bands
    % Ref: https://uk.mathworks.com/matlabcentral/fileexchange/16567-peaking-notch-iir-filter
    for i = 2:10
        [c, a] = peaking(b(i), bf(i), Q, Fs);
        y = filter(c, a, y);
    end

    % Apply Base_Treble filter to highest band
    % Ref: https://uk.mathworks.com/matlabcentral/fileexchange/16568-bass-treble-shelving-filter
    % Ref: 4th Lecture (20/2)
    [c, a] = shelving(b(11), bf(11), Fs, Q, 'Treble_Shelf');
    y = filter(c, a, y);

    % Normalise
    maxy = max(abs(y));
    y = y/maxy;

    ss = struct("y", y, "Fs", Fs);
end