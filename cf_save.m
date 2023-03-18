function cf_save(filename, s)
    
    % Ref: https://uk.mathworks.com/help/matlab/ref/audiowrite.html 
    audiowrite(filename, s.y, s.Fs);
end