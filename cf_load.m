function s = cf_load(filename)
    
    [y, Fs] = audioread(filename);  % Ref: 4th Lecture (20/2)

    % Return s as a structure with fields y and Fs
    s = struct("y", y, "Fs", Fs);
end