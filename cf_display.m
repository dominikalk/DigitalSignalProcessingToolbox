function cf_display(s, domain)
    if nargin < 2
        domain = "t";
    end

    if domain == "t"
        N = size(s.y,1);
        x = (0:N-1)/s.Fs;
    elseif domain == "f"
        N = size(s.y,1);
        x = (0:N-1)/s.Fs;
    else
        % Edge Case Check
    end 
    
    y = s.y;
    plot(x,y);
    % Check for multiple signals and subplot

    ylabel('Amplitude');
    if domain == "t"
        title('Plot of Signal in the Time domain');
        xlabel('Time / S');
    elseif domain == "f"
        title('Plot of Signal in the Frequency domain');
        xlabel('Frequency / Hz');
    else
        % Edge Case Check
    end 
end