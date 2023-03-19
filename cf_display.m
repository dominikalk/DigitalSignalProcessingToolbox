function cf_display(s, domain)

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
        y = s.y;
        N = size(y, 1);
        if mod(N, 2) ~= 0 
            y = [y;0]; 
            N = N + 1; 
        end
        Y = fftshift(fft(y));
        x = [-N/2:N/2-1]*s.Fs/N;
        plot(x, abs(Y));

        title('Plot of Signal in the Frequency domain');
        xlabel('Frequency / Hz');
        ylabel('Magnitude');
    end 

    % Check for multiple signals and subplot
end