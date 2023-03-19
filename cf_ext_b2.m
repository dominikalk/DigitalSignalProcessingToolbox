function ss = cf_ext_b2(s) 
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
    % concatonated to create the final image.
    %
    % Requires an image loaded with cf_load_2
    % Returns an image that can be displayed with cf_display2
    %
    % Usage:     ss = cf_ext_b2(s);
    %
    %            s: image loaded with cf_load_2
    %
    % Author:    Dominik Alkhovik

    % Format s to make grayscale, remove noise, and increase contrast
    s = rgb2gray(s); % Ref: 5th Lecture (27/2)
    s = wiener2(s, [5 5]); % Ref: https://uk.mathworks.com/help/images/ref/wiener2.html
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

    % Concatonate RGB matrices
    ss = cat(3, sr, sg, sb); % Ref: https://uk.mathworks.com/matlabcentral/answers/285410-free-hand-drawing-on-photo-matlab
end