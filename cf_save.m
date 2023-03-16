function cf_save(filename, s)
    audiowrite(filename, s.y, s.Fs);
end