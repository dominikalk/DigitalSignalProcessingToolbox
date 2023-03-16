function cf_play(s, v)
% TODO: add checks for volume bounds
    if nargin < 2
        v = 100;
    end

    sound(s.y * (v / 100), s.Fs);
end