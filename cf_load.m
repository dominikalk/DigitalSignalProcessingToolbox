function s = cf_load(filename)
    [y, Fs] = audioread(filename);
    s = {y, Fs};
end