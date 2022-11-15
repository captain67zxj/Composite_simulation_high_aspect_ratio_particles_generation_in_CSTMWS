function y = image_ellipse_3D_fast(a, b, c, alpha, beta, gamma)

% Mark Tschopp
% 2016
% This subroutine generates a 3D ellipse in a matrix (y) using the
% orthogonal distances in the ellipse (a,b,c) and the Euler angles
% (psi1,psi2,phi), which define the rotation of the ellipse.
% First, identify what the size of the matrix must be to contain the
% ellipse and also what the central symmetry plane will be (ic).

if a > b; diameter = 2*a; else diameter = 2*b; end
if 2*c > diameter; diameter = 2*c; end
if mod(diameter,round(diameter))~= 0; diameter = ceil(diameter); end
radius = diameter/2;
if mod(radius,round(radius))~= 0;
diameter = diameter+1; radius = diameter/2;
end
dist(1:diameter+1,1:diameter+1,1:diameter+1) = 2;
ic = 1 + radius;

% M is the rotation matrix for the ellipse, based on the Euler angles
% psi1, psi2, and phi. Different rotation matrices and Euler angle
% conventions can be used, if necessary.

%%%%%changed rotation matrix%%%%%%%%%%%%%%%%%%%
% using a general rotation matrix:
M = zeros(3);
M(1,1) = cos(alpha)*cos(beta);
M(2,1) = sin(alpha)*cos(beta);
M(3,1) = -sin(beta);

M(1,2) = cos(alpha)*sin(beta)*sin(gamma)-sin(alpha)*cos(gamma);
M(2,2) = sin(alpha)*sin(beta)*sin(gamma)+cos(alpha)*cos(gamma);
M(3,2) = cos(beta)*sin(gamma);

M(1,3) = cos(alpha)*sin(beta)*cos(gamma)+sin(alpha)*sin(gamma);
M(2,3) = sin(alpha)*sin(beta)*cos(gamma)-cos(alpha)*sin(gamma);
M(3,3) = cos(beta)*cos(gamma);

% This step creates a matrix with the distances to the ellipse
% centroid (ic, ic, ic). This has been optimized to minimize the
% time to generate the 3D ellipse. The changes resulted in a
% 94% decrease in the cpu time required to generate the ellipse.

k = ic-1;
i0 = 1; i1 = diameter + 1;
j0 = 1; j1 = diameter + 1;
while k < diameter+1
    k = k + 1;
    % This loops over all the pixels in the first plane to find
    % the pixels belonging to the ellipse
    for i = i0:i1
        for j = j0:j1
            a1 = [i-ic, j-ic, k-ic];
            a2 = [a^2, b^2, c^2];
            c1 = a1*M;
            c2 = c1.^2./a2;
            dist(i,j,k) = sum(c2);
        end
    end
    % If there are no pixels belonging to the ellipse on this plane,
    % then go ahead and exit out of the loop by setting k to the
    % final plane
    if sum(sum(dist(:,:,k)<=1))==0
        k = diameter + 1;
    end
    % If this is not the first or last plane, then the program
    % is smarter about which pixels it checks for ellipse pixels in
    if k ~= ic && k ~= diameter + 1
        d = dist(:,:,k-1) <= 1;
        e = dist(:,:,k) <= 1;
        d1 = diff(sum(d,1)~=0); dmin = find(d1 == 1);
        dmax = find(d1 == -1);
        if size(dmin,2) > 1; dmin = dmin(1); dmax = dmax(2); end
        e1 = diff(sum(e,1)~=0); emin = find(e1 == 1);
        emax = find(e1 == -1);
        if size(emin,2) > 1; emin = emin(1); emax = emax(2); end
        if dmin - emin < 0;
            j0 = emin - 1;
            j1 = j0 + 3 + (dmax-dmin);
            if j1 > diameter + 1; j1 = diameter + 1; end
        end
        if dmax - emax > 0;
        j1 = emax + 1;
        j0 = j1 - 3 - (dmax-dmin);
        if j0 < 1; j0 = 1; end
        end
        d1 = diff(sum(d,2)~=0); dmin = find(d1 == 1);
        dmax = find(d1 == -1);
        if size(dmin,1) > 1; dmin = dmin(1); dmax = dmax(2); end
        e1 = diff(sum(e,2)~=0); emin = find(e1 == 1);
        emax = find(e1 == -1);
        if size(emin,1) > 1; emin = emin(1); emax = emax(2); end
        if dmin - emin < 0;
        i0 = emin - 1;
        i1 = i0 + 3 + (dmax-dmin);
        if i1 > diameter + 1; i1 = diameter + 1; end
        end
        if dmax - emax > 0;
            i1 = emax + 1;
            i0 = i1 - 3 - (dmax-dmin);
            if i0 < 1; i0 = 1; end
        end
    end
end

% Generate whole ellipse
% This section uses symmetry of the ellipse about the center plane
% to generate the entire ellipse in matrix y. The defined distance
% matrix in the previous section has a threshold of 1. Distances
% less than or equal to 1 belong to the ellipse; all other distances
% do not.

y = dist <= 1;
x = y(1:diameter+1,1:diameter+1,ic + 1:diameter+1);
x1(1:diameter+1,1:diameter+1,1:ic-1) = 0;
for i = 1:size(x,3)
    x1(:,:,size(x,3)-i+1) = flipud(fliplr(x(:,:,i)));
end
y(1:diameter+1,1:diameter+1,1:ic-1) = x1;

% Show images
% For debug purposes, change the 'while 0' to 'while 1' for a stack
% of images through the ellipse.

while 0
    for i = 1:length(y)
        image_view(1-y(:,:,i));
        pause(0.15)
    end
end
