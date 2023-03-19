function s = cf_load2(filename)
    % 
    % Given a file name, the function will return an image s. The return 
    % value s is an array containing the image data. If the file contains a 
    % grayscale image, s is an M-by-N array. If the file contains a 
    % truecolor image, s is an M-by-N-by-3 array.
    %
    % Usage:     s = cf_load2(filename);
    %
    %            filename: a filename or local path to a file as a string.
    %
    % Author:   Dominik Alkhovik

    s = imread(filename); % Ref: 5th Lecture (27/2)
end