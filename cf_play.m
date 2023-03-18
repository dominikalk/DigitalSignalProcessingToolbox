function cf_play(s, v)

    % Default volume to 100 if not provided
    if nargin < 2
        v = 100;
    end
    
    % Error checks to ensure v is a scalar number between 0 and 100;
    if ~isscalar(v) || ~isnumeric(v)
        error('v must be a scalar number.');
    elseif v < 0 || v > 100
        error('v must be between 0 and 100.');
    end

    % Play sound at volume v
    sound(s.y * (v / 100), s.Fs);
end