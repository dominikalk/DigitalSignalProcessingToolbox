function ss = cf_ext_a(s)
    Fs = s.Fs;
    x = s.y;
    
    % EFFECT COEFFICIENTS
    % Damping factor: the lower the smaller the pass band
    damp = 0.05;
    % Min and max centre cutoff frequency of variable bandpass filter
    minf=300;
    maxf=3000;
    % wah frequency, how many Hz per secondare cycled through
    Fw = 1;
    
    % Create triangle wave
    Centre_freq = (maxf + minf)/2;
    offset = maxf - Centre_freq;
    Fc = Centre_freq + offset*sin(2*pi*(1:length(x))*Fw/Fs);
    
    figure();
    plot(Fc);
    title('Modulating Frequency Plot');

    % Difference equation coefficients
    F1 = 2*sin((pi*Fc(1))/Fs);  % must be recalculated each time Fc changes
    Q1 = 2*damp;                % this dictates size of the pass bands
    
    yh = zeros(size(x));        % create empty out vectors
    yb = zeros(size(x));
    yl = zeros(size(x));
    
    % First sample, to avoid referencing of negative signals
    yh(1) = x(1);
    yb(1) = F1*yh(1);
    yl(1) = F1*yb(1);
    
    % Apply difference equation to the sample
    for n=2:length(x)
      yh(n) = x(n) - yl(n-1) - Q1*yb(n-1);
      yb(n) = F1*yh(n) + yb(n-1);
      yl(n) = F1*yb(n) + yl(n-1);
    
      F1 = 2*sin((pi*Fc(n))/Fs);
    end
    
    % Normalise
    maxyb = max(abs(yb));
    yb = yb/maxyb;
    
    % Plot
    figure()
    hold on
    plot(x,'r');
    plot(yb,'g');
    title('Wah-wah and original Signal (Blue - Wah-Wah, Red - original)');
    
    sound(yb, Fs);

    ss = struct("y", yb, "Fs", Fs);
end