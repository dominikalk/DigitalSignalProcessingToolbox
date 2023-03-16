function cf_display(s, domain)

    % Default domain to t (time) if not provided
    if nargin < 2
        domain = 't';
    end

    % Error check to make sure domain is a character and equal
    % to either 't' of 'f'
    if ~ischar(domain)
        error("Domain must be of type char, not %s.", class(domain));
    elseif domain ~= 't' && domain ~= 'f'
        error("Domain must be char 't' (Time) or 'f' (Frequency).");
    end

    figure();
    if domain == 't'
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
        y = s.y;
        N = size(y, 1);
        if mod(N, 2) ~= 0 
            y = [y;0]; 
            N = N + 1; 
        end
        Y = fftshift(fft(y));
        x = [-N/2:N/2-1]*s.Fs/N;
        plot(x, abs(Y));

        ylabel('Magnitude');
        title('Plot of Signal in the Frequency domain');
        xlabel('Frequency / Hz');
    end 

    % Check for multiple signals and subplot
end