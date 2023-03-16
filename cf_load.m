function s = cf_load(filename)
    [y, Fs] = audioread(filename);

    % Return s as a structure with fields y and Fs
    s = struct("y", y, "Fs", Fs);
end