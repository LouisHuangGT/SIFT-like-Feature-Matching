% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'feature_width', in pixels, is the local feature width. It might be
%   useful in this function in order to (a) suppress boundary interest
%   points (where a feature wouldn't fit entirely in the image, anyway)
%   or (b) scale the image filters being used. Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, threshold,window)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

% Placeholder that you can delete -- random points

R = zeros(size(image,1),size(image,2));
sigma=0.3;  

    Ix = imfilter(image,[-1 0 1],'symmetric');
    Iy = imfilter(image,[-1;0;1],'symmetric');
    window=double(uint8(3*sigma)*2+1);
    H=fspecial('gaussian', window, sigma);

    A = Ix .* Ix;
    C = Iy .* Iy;
    B = Ix .* Iy;
    A = imfilter(A,H);
    B = imfilter(B,H);
	C = imfilter(C,H);

    detM = A.*C-B.*B;
    traceM = A+C;
    alpha = 0.05;
    R = detM-alpha*traceM.*traceM;

count = 0;
maxR = max(R(:));

res = zeros(size(image));

radius = 5;

se = strel('square',window);
R1 = imdilate(R,se);

for i = 1:size(R,1)
      for j = 1:size(R,2)
          if ((R(i,j)-R1(i,j))*10000==0 && R1(i,j)~=0 )
                res(i,j) = R(i,j);
          else
             res(i,j) = 0;
          end
      end
end

res = im2bw(res,max(res(:))*threshold);
   
figure();
imshow(res);
[y x] = find(res~=0);
end

