function cf_play(s, v)
% TODO: add checks for volume bounds
    if nargin < 2
        v = 100;
    end

    sound(s{1} * (v / 100), s{2});
end