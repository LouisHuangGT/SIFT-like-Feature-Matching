% Local Feature Stencil Code
% CS 4476 / 6476: Computer Vision, Georgia Tech
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the interest points as additional features.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
num_features = min(size(features1, 1), size(features2,1));
matches = zeros(0, 2);
confidences = zeros(0,1);
count = 0;

allfeatures = [features1;features2];
pcafeatures = PCAscore(allfeatures);
features2 = pcafeatures(size(features1,1)+1:size(pcafeatures,1),:);
features1 = pcafeatures(1:size(features1,1),:);

matchind = zeros(0);
%parfor i = 1:size(features1, 1)
%Use parfor for the parallel processing
for i = 1:size(features1, 1)
    d = zeros(0,1);
    dmin = 0;
    minj = 0;
    for j = 1:size(features2,1)
        d = [d norm(features1(i,:)-features2(j,:),2)];
    end
    [temp ind] = sort(d,'ascend');
    dmin = temp(1);
    dmin2 = temp(2);
    confidence = dmin2/dmin;
    confidences = [confidences confidence];
    matchind = [matchind ind(1)];
end

for i = 1: size(features1,1)
    matches(i,1) = i;
    matches(i,2) = matchind(i);
end
    
[confidences, ind] = sort(confidences, 'descend');
matches = matches(ind,:);
matches = matches(1:100,:);
end