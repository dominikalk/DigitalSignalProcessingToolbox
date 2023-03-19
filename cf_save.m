function cf_save(filename, s)
    
    audiowrite(filename, s.y, s.Fs); % Ref: https://uk.mathworks.com/help/matlab/ref/audiowrite.html 
end