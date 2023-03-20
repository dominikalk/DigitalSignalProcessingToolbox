function cf_display(s, domain)
    % 
    % Given an audio signal as structure s with fields y and Fs, it will 
    % display the signal on a graph in the time or frequency domain.
    %
    % Usage:     cf_display(s);
    %            cf_display(s, domain);
    %
    %            s: The signal as a structure with fields y and Fs
    %            domain: A character string defining the domain the graph
    %               should be plotted in. 
    %               Choices are: 't' (time) or 'f' (frequency).
    %               Default: 't'.
    %
    % Author:   Dominik Alkhovik

    % Default domain to t (time) if not provided
    if nargin < 2
        domain = 't';
    end

    %Error Check
    if ~(ischar(domain) || isstring(domain))
        error(['Unsupported Domain Class Type: ', class(domain)]);
    elseif((strcmp(domain,'t') ~= 1) && (strcmp(domain,'f') ~= 1)) % Ref: https://uk.mathworks.com/help/matlab/ref/strcmp.html
        error(['Unsupported Domain Type: ', convertStringsToChars(domain)]); % Ref: https://uk.mathworks.com/help/matlab/ref/convertstringstochars.html
    end

    % Plot signal in time of frequency domain depending on input
    figure();
    if strcmp(domain,'t')
        % Logic to plot signal in time domain
        N = size(s.y,1);
        x = (0:N-1)/s.Fs;
        y = s.y;
        plot(x,y);

        ylim([-1 1]);
        title('Plot of Signal in the Time domain');
        xlabel('Time / s');
        ylabel('Amplitude');
    else
        % Logic to plot signal in frequency domain
        % Ref: 4th Lecture (20/2)
        y = s.y;
        N = size(y, 1);
        % Add 0 to end if odd number of amplitudes
        if mod(N, 2) ~= 0 
            y = [y;0]; 
            N = N + 1; 
        end
        % Get magnitude of frequencies
        Y = fftshift(fft(y));
        x = [-N/2:N/2-1]*s.Fs/N;
        plot(x, abs(Y));

        title('Plot of Signal in the Frequency domain');
        xlabel('Frequency / Hz');
        ylabel('Magnitude');
    end 
end