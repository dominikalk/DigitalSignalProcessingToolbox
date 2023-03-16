function cf_save(filename, s)
    audiowrite(filename, s{1}, s{2});
end