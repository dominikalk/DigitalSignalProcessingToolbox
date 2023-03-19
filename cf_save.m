function cf_save(filename, s)
    % 
    % Given a file name and an audio signal, it will save the signal to a
    % file with the name specified.
    %
    % Usage:     cf_save(filename, s);
    %
    %            filename: The name of the file. Must include the file type
    %               suffix.
    %            s: The signal as a structure with fields y and Fs
    %
    % Author:   Dominik Alkhovik
    
    audiowrite(filename, s.y, s.Fs); % Ref: https://uk.mathworks.com/help/matlab/ref/audiowrite.html 
end