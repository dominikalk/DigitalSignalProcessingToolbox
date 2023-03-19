function cf_play(s, v)
    % 
    % Given an audio signal, it will play the audio at volume v, where v is
    % the percentage of the volume.
    %
    % Usage:     cf_play(s, v);
    %
    %            s: The signal as a structure with fields y and Fs
    %            v: The volume of the signal as a percentage.
    %               Default: 100.
    %
    % Author:   Dominik Alkhovik


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
    sound(s.y * (v / 100), s.Fs); % Ref: 4th Lecture (20/2)
end