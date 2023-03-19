function ss = cf_ext_a(s, varargin)
    % 
    % Generates an audio signal with the Wah Wah effect applied to it given 
    % different input parameters. It implements a BandPass filter with a
    % narrow pass band using a wave that oscillates up and down thespectrum.
    % Takes an input of a wave s as a structure with fields y and Fs.
    %
    % Usage:        ss = cf_ext_a(s);
    %               ss = cf_ext_a(s, PARAM1, VAL1, PARAM2, VAL2...);
    %
    % Optional Parameters:
    %
    % 'wave_type'   The type of wave to be applied as part of the Wah Wah
    %               effect onto the input signal. Possible types are:
    %               'Wave_Triangle','Wave_Sawtooth','Wave_Square','Wave_Sin'.
    %
    %               Default: 'Wave_Triangle'.
    % 
    % 'Fw'          Wah frequency: how many Hz per secondare cycled through.
    %
    %               Default: 1.
    %
    % 'damp'        Damping factor: the lower the smaller the pass band.
    %
    %               Default: 0.05.
    %
    % 'minf'        Min centre cutoff frequency of variable bandpass filter.
    %
    %               Default: 300.
    %
    % 'maxf'        Max centre cutoff frequency of variable bandpass filter.
    %
    %               Default: 3000.
    %
    % Author:    Dominik Alkhovik

    % Define default values for input parsing
    wave_type = 'Wave_Triangle';
    expected_wave_types = {'Wave_Triangle','Wave_Sawtooth','Wave_Square','Wave_Sin'};
    Fw = 1; % wah frequency, how many Hz per secondare cycled through
    damp = 0.05; % Damping factor: the lower the smaller the pass band
    minf=300; % Min and max centre cutoff frequency of variable bandpass filter
    maxf=3000;

    % Input Parsing to allow for multiple optional parameters
    p = inputParser; % Ref: https://uk.mathworks.com/help/matlab/ref/inputparser.html
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x > 0);
    addRequired(p,'s');
    addParameter(p,'wave_type',wave_type, @(x) any(validatestring(x, expected_wave_types)));
    addParameter(p,'Fw',Fw,validScalarPosNum);
    addParameter(p,'damp',damp,validScalarPosNum);
    addParameter(p,'minf',minf,validScalarPosNum);
    addParameter(p,'maxf',maxf,validScalarPosNum);
    parse(p,s,varargin{:});

    % Set parameters to default or custom
    s = p.Results.s;
    wave_type = p.Results.wave_type;
    Fw = p.Results.Fw;
    damp = p.Results.damp;
    minf = p.Results.minf;
    maxf = p.Results.maxf;

    % Deconstruct structure for readability
    Fs = s.Fs;
    x = s.y;

    % Reference for Code below on Wah Wah effect
    % live4.zip -> four3.mlx
    % code was taken and manipulated to add functionality

    % Create wave
    Cf = (maxf + minf)/2; % Centre Frequency
    offset = maxf - Cf; % Offset
    Wx = 2*pi*(1:length(x))*Fw/Fs; % Wave X - Value to input into wave function
    if strcmp(wave_type,'Wave_Triangle')
        Fc = Cf + offset * sawtooth(Wx,1/2);
    elseif strcmp(wave_type,'Wave_Sawtooth')
        Fc = Cf + offset * sawtooth(Wx);
    elseif strcmp(wave_type,'Wave_Square')
        Fc = Cf + offset * square(Wx); % Ref: https://uk.mathworks.com/help/signal/ref/square.html
    else
        Fc = Cf + offset * sin(Wx);
    end

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

    % Create structure to be returned
    ss = struct("y", yb, "Fs", Fs);
end