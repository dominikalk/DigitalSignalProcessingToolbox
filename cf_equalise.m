function ss = cf_equalise(s, b)

    % Error check to ensure b is 1D vector of 11 numeric elements
    err = size(b);
    if err(1) ~= 1 || err(2) ~= 11
        error('b must be a 1D vector with 11 elements.');
    elseif ~isnumeric(b)
        error('All elements of b must be numeric.');
    end

    bf = [16, 31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];

    y = s.y;
    Fs = s.Fs;
    Q = 3;

    % Apply Base_Shelf filter to lowest band
    % Shelving filter from https://uk.mathworks.com/matlabcentral/fileexchange/16568-bass-treble-shelving-filter
    [c, a] = shelving(b(1), bf(1), Fs, Q, 'Base_Shelf');
    y = filter(c, a, y);

    % Apply peaking filter for middle bands
    % Peaking filter from https://uk.mathworks.com/matlabcentral/fileexchange/16567-peaking-notch-iir-filter
    for i = 2:10
        [c, a] = peaking(b(i), bf(i), Q, Fs);
        y = filter(c, a, y);
    end

    % Apply Base_Treble filter to highest band
    % Shelving filter from https://uk.mathworks.com/matlabcentral/fileexchange/16568-bass-treble-shelving-filter
    [c, a] = shelving(b(11), bf(11), Fs, Q, 'Treble_Shelf');
    y = filter(c, a, y);

    ss = struct("y", y, "Fs", Fs);
end