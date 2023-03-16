function s = cf_load(filename)
    [y, Fs] = audioread(filename);
    s = struct("y", y, "Fs", Fs);
end