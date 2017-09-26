function features = get_GLOH_features(image, x, y, feature_width)
features = zeros(0, 272);
imaget = padarray(image,[floor(feature_width/2) floor(feature_width)],'replicate','both');
[dx dy] = gradient(imaget);
theta = rad2deg(atan2(dy,dx))+180;
r = zeros(size(feature_width));
alpha = zeros(size(feature_width));
 for m = -floor(feature_width/2):floor(feature_width/2)
     for n = -floor(feature_width/2):floor(feature_width/2)
        r(m+floor(feature_width/2)+1,n+floor(feature_width/2)+1) = distance([m n],[0 0]);
        alpha(m+floor(feature_width/2)+1,n+floor(feature_width/2)+1) = rad2deg(atan2(n,m))+180;
     end
 end
alpha611 = find(r<11&r>=6);
alpha1116 = find(r<=16&r>=11);
for i = 1:size(x,1)
    center = zeros(1,16);
    mid = zeros(16,16);
    boundary = zeros(16,16);
    s = theta(y(i):y(i) + floor(feature_width),x(i):x(i) + floor(feature_width));
    c = [y(i) x(i)];
    
    catc = ceil(s(find(r<6))/360*16);
    catm1 = ceil(alpha(alpha611)/360*8);
    catm2 = ceil(s(alpha611)/360*16);
    catb1 = ceil(alpha(alpha1116)/360*8);
    catb2 = ceil(s(alpha1116)/360*16);
    
    for k = 1:size(catc,1)
        center(1,catc(k)) = center(1,catc(k))+1;
    end
    for k = 1:size(catm1,1)
        mid(catm1(k),catm2(k)) =  mid(catm1(k),catm2(k))+1;
    end
    for k = 1:size(catb1,1)
        boundary(catb1(k),catb2(k)) = boundary(catb1(k),catb2(k))+1;
    end
    feature = center;
    for k = 1:8
        feature = [feature mid(k,:)];
    end
    for k = 1:8
        feature = [feature boundary(k,:)];
    end
    feature = (feature-min(feature(:)))./(max(feature(:))-min(feature(:)));
    features = [features; feature];
end
end

