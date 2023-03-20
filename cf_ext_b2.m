function ss = cf_ext_b2(s, noise) 
    % Generates an image in the style of the Marilyn Monroe 4 multicoloured
    % tiles (2x2 tiled image of the input image where each tile shows the 
    % segmented image with a different iteration of 3 colours and black). 
    % The function removes noise and increases the contrast of the input
    % image to ensure the values worked with will vary enough to show the
    % multiple colours, whilst not being noisy. It then generates 3
    % threshold levels dynamically with multithresh to separate the 4 
    % colours. These are then used to create 4 binary masks which are in
    % turn used in combination to create the colours on each of the r, g, 
    % and b matrices of the 4 tiles. These r, g, and b matrices are then
    % concatonated to create the final image which is returned as an MxNx3
    % array.
    %
    % Usage:     ss = cf_ext_b2(s);
    %            ss = cf_ext_b2(s, noise);
    %
    %            s: image as an MxN or MxNx3 array.
    %            noise: level of noise reduction on image.
    %               Default: 5.
    %
    % Author:    Dominik Alkhovik

    % Default noise if not set
    if nargin < 2
        noise = 5;
    end

    % Error checks
    if ~isnumeric(noise) ||~isscalar(noise) || mod(noise, 1) ~= 0 || noise <= 0
        error('noise must be a positive integer.');
    end

    % Format s to make grayscale, remove noise, and increase contrast
    s = rgb2gray(s); % Ref: 5th Lecture (27/2)
    s = wiener2(s, [noise noise]); % Ref: https://uk.mathworks.com/help/images/ref/wiener2.html
    s = adapthisteq(s); % Ref: 5th Lecture (27/2)

    % Generate threshold levels
    tm = cast(multithresh(s, 3), 'double') ./ 256; % Ref: https://uk.mathworks.com/help/images/ref/multithresh.html
    [Y, X] = size(s);

    % Initialise binary masks
    m4 = imbinarize(s, tm(1)); % Black
    m1 = imbinarize(s, tm(3)) .* m4; % Foreground
    m2 = (imbinarize(s, tm(2)) - m1) .* m4; % Middleground
    m3 = (ones([Y, X]) - (m1 + m2)) .* m4; % Background

    % Initialise rgb matrices of image
    sr = zeros([Y * 2, X * 2]);
    sg = zeros([Y * 2, X * 2]);
    sb = zeros([Y * 2, X * 2]);

    % Initialise "pink" colour structure
    pink = struct('r', (248 / 255), 'g', (185 / 255), 'b', (232 / 255));

    % Edit RGB values in each of the 4 squares
    % By combining the same mask into different colours of RGB, we get
    % cyan, magenta, and yellow. Pink is created by adding fractions of the
    % mask to get the desired colour. This is done to each of the four
    % corners of the final image with different mask combinations to get
    % different colours for the foreground - background layers.

    % Top Left
    sr(1:Y, 1:X) = m1 + m2 + m3 .* pink.r;
    sg(1:Y, 1:X) = m1 + m3 .* pink.g;
    sb(1:Y, 1:X) = m2 + m3 .* pink.b;

    % Bottom Left
    sr(Y+1:Y*2, 1:X) = m3 + m1;
    sg(Y+1:Y*2, 1:X) = m2 + m3;
    sb(Y+1:Y*2, 1:X) = m2 + m1;

    % Top Right
    sr(1:Y, X+1:X*2) = m2 + m1 .* pink.r;
    sg(1:Y, X+1:X*2) = m2 + m3 + m1 .* pink.g;
    sb(1:Y, X+1:X*2) = m3 + m1 .* pink.b;

    % Bottom Right
    sr(Y+1:Y*2, X+1:X*2) = m3 + m2 .* pink.r;
    sg(Y+1:Y*2, X+1:X*2) = m1 + m2 .* pink.g;
    sb(Y+1:Y*2, X+1:X*2) = m3 + m1 + m2 .* pink.b;

    % Concatonate RGB matrices for the final image
    ss = cat(3, sr, sg, sb); % Ref: https://uk.mathworks.com/help/matlab/ref/double.cat.html
end