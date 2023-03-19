function s = cf_load(filename)
    % 
    % Given a file name, the function will return an audio signal in a
    % structure s with fields y and Fs.
    %
    % Usage:     s = cf_load(filename);
    %
    %            filename: a filename or local path to a file as a string.
    %
    % Author:   Dominik Alkhovik

    [y, Fs] = audioread(filename);  % Ref: 4th Lecture (20/2)

    % Return s as a structure with fields y and Fs
    s = struct("y", y, "Fs", Fs);
end