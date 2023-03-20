function cf_save2(filename, s)
    % 
    % Given a file name and an image as an MxN or MxNx3 array, it will save 
    % the image to a file with the name specified.
    %
    % Usage:     cf_save2(filename, s);
    %
    %            filename: The name of the file. Must include the file type
    %               suffix.
    %            s: image as an MxN or MxNx3 array.
    %
    % Author:   Dominik Alkhovik

    % Write to file with name equal to filename and content s
    imwrite(s, filename); % Ref: https://uk.mathworks.com/help/matlab/ref/imwrite.html
end